// Copyright (c) 2018-2020 Bluespec, Inc. All Rights Reserved.

//-
// AXI (user fields) modifications:
//     Copyright (c) 2019 Alexandre Joannou
//     Copyright (c) 2019 Peter Rugg
//     Copyright (c) 2019 Jonathan Woodruff
//     All rights reserved.
//
//     This software was developed by SRI International and the University of
//     Cambridge Computer Laboratory (Department of Computer Science and
//     Technology) under DARPA contract HR0011-18-C-0016 ("ECATS"), as part of the
//     DARPA SSITH research programme.
//-

package P2_Core;

// ================================================================
// This package defines the interface and implementation of the 'P2 Core'
// for the DARPA SSITH project.
// This P2 core contains:
//    - Flute CPU, including
//        - Near_Mem (ICache and DCache)
//        - Near_Mem_IO (Timer, Software-interrupt, and other mem-mapped-locations)
//        - External interrupt request lines
//        - 2 x AXI4 Master interfaces (from DM and ICache, and from DCache)
//    - RISC-V Debug Module (DM)
//    - JTAG TAP interface for DM
//    - Optional Tandem Verification trace stream output interface

// ================================================================
// BSV library imports

import Vector        :: *;
import FIFO          :: *;
import GetPut        :: *;
import ClientServer  :: *;
import Connectable   :: *;
import Bus           :: *;

// ----------------
// BSV additional libs

import GetPut_Aux :: *;
import Semi_FIFOF :: *;

`ifdef INCLUDE_DMEM_SLAVE
import AXI4Lite :: *;
`endif

// ================================================================
// Project imports

import SoC_Map  :: *;

// The basic core
import Core_IFC :: *;
import Core     :: *;
import Near_Mem_IFC :: *;    // For Wd_{Id,Addr,Data,User}_Dma

// External interrupt request interface
import PLIC :: *;    // for PLIC_Source_IFC type which is exposed at P2_Core interface

// Main Fabric
import AXI4         :: *;
import Fabric_Defs  :: *;

`ifdef INCLUDE_TANDEM_VERIF
import TV_Info :: *;
import AXI4_Stream ::*;
`endif

`ifdef INCLUDE_GDB_CONTROL
import Debug_Module :: *;
import JtagTap      :: *;
import Giraffe_IFC  :: *;
`endif

// ================================================================
// The P2_Core interface

interface P2_Core_IFC;

   // ----------------------------------------------------------------
   // Core CPU interfaces

   // CPU IMem to Fabric master interface
   interface AXI4_Master_Sig #(Wd_MId, Wd_Addr, Wd_Data,
                                 0, 0, 0, 0, 0) master0;

   // CPU DMem (incl. I/O) to Fabric master interface
   interface AXI4_Master_Sig #( Wd_MId_ext, Wd_Addr, Wd_Data
                                , Wd_AW_User_ext, Wd_W_User_ext, Wd_B_User_ext
                                , Wd_AR_User_ext, Wd_R_User_ext) master1;

   // External interrupt sources
   (* always_ready, always_enabled, prefix="" *)
   method  Action interrupt_reqs ((* port="cpu_external_interrupt_req" *) Bit #(N_External_Interrupt_Sources)  reqs);

`ifdef INCLUDE_DMEM_SLAVE
   // ----------------------------------------------------------------
   // Optional AXI4-Lite D-cache slave interface

   interface AXI4Lite_Slave_Sig #(Wd_Addr, Wd_Data, 0, 0, 0, 0, 0) slave0;
`endif

`ifdef INCLUDE_TANDEM_VERIF
   // ----------------------------------------------------------------
   // Optional Tandem Verifier interface.  The data signal is
   // packed output tuples (n,vb),/ where 'vb' is a vector of
   // bytes with relevant bytes in locations [0]..[n-1]

      interface AXI4_Stream_Master_IFC #(Wd_SId, Wd_SDest, Wd_SData, Wd_SUser)  tv_verifier_info_tx;
`endif

`ifdef INCLUDE_GDB_CONTROL
   // ----------------
   // JTAG interface

`ifdef JTAG_TAP
   interface JTAG_IFC jtag;
`endif
`endif
endinterface

// ================================================================

(* synthesize *)
module mkP2_Core (P2_Core_IFC);

   // Core: CPU + Near_Mem_IO (CLINT) + PLIC + Debug module (optional) + TV (optional)
   Core_IFC::Core_IFC_Synth #(N_External_Interrupt_Sources)  core <- mkCore_Synth;

   // ================================================================
   // Tie-offs (not used in SSITH GFE)

   // Set core's verbosity
   rule rl_never (False);
      core.set_verbosity (?, ?);
   endrule

   // Tie-offs
   rule rl_always (True);
      // Non-maskable interrupt request.
      core.nmi_req (False);
   endrule

   AXI4_Master_Sig #( Wd_Id_Dma, Wd_Addr_Dma, Wd_Data_Dma
                      , Wd_AW_User_Dma, Wd_W_User_Dma, Wd_B_User_Dma
                      , Wd_AR_User_Dma, Wd_R_User_Dma) dummy = culDeSac;
   mkConnection (dummy, core.dma_server);

   // ================================================================
   // Reset on startup, and also on NDM reset from Debug Module
   // (NDM reset from Debug Module = "non-debug-module-reset" = reset all except Debug Module)

   Reg #(Bool)          rg_once      <- mkReg (False);
   Reg #(Maybe #(Bool)) rg_ndm_reset <- mkReg (tagged Invalid);

   rule rl_once (! rg_once);
      Bool running = True;
      if (rg_ndm_reset matches tagged Valid False)
	 running = False;
      core.cpu_reset_server.request.put (running);
      core.ma_ddr4_ready;
      rg_once <= True;
   endrule

   rule rl_reset_response;
      let running <- core.cpu_reset_server.response.get;

`ifdef INCLUDE_GDB_CONTROL
      // Respond to Debug module if this is an ndm-reset
      if (rg_ndm_reset matches tagged Valid .x)
	 core.ndm_reset_client.response.put (running);
      rg_ndm_reset <= tagged Invalid;
`endif
   endrule

   // ----------------
   // Also do a reset if requested from Debug Module (NDM = Non-Debug-Module reset)

   rule rl_ndmreset (rg_once);
`ifdef INCLUDE_GDB_CONTROL
      let running <- core.ndm_reset_client.request.get;
      rg_ndm_reset <= tagged Valid running;
`endif

      rg_once <= False;
   endrule

   // ================================================================
`ifdef INCLUDE_GDB_CONTROL

   // Instantiate JTAG TAP controller,
   // connect to core.dm_dmi;
   // and export its JTAG interface

   Wire#(Bit#(7)) w_dmi_req_addr <- mkDWire(0);
   Wire#(Bit#(32)) w_dmi_req_data <- mkDWire(0);
   Wire#(Bit#(2)) w_dmi_req_op <- mkDWire(0);

   Wire#(Bit#(32)) w_dmi_rsp_data <- mkDWire(0);
   Wire#(Bit#(2)) w_dmi_rsp_response <- mkDWire(0);

   BusReceiver#(Tuple3#(Bit#(7),Bit#(32),Bit#(2))) bus_dmi_req <- mkBusReceiver;
   BusSender#(Tuple2#(Bit#(32),Bit#(2))) bus_dmi_rsp <- mkBusSender(unpack(0));

`ifdef JTAG_TAP
   let jtagtap <- mkJtagTap;

   mkConnection(jtagtap.dmi.req_ready, pack(bus_dmi_req.in.ready));
   mkConnection(jtagtap.dmi.req_valid, compose(bus_dmi_req.in.valid, unpack));
   mkConnection(jtagtap.dmi.req_addr, w_dmi_req_addr._write);
   mkConnection(jtagtap.dmi.req_data, w_dmi_req_data._write);
   mkConnection(jtagtap.dmi.req_op, w_dmi_req_op._write);
   mkConnection(jtagtap.dmi.rsp_valid, pack(bus_dmi_rsp.out.valid));
   mkConnection(jtagtap.dmi.rsp_ready, compose(bus_dmi_rsp.out.ready, unpack));
   mkConnection(jtagtap.dmi.rsp_data, w_dmi_rsp_data);
   mkConnection(jtagtap.dmi.rsp_response, w_dmi_rsp_response);
`endif

   rule rl_dmi_req;
      bus_dmi_req.in.data(tuple3(w_dmi_req_addr, w_dmi_req_data, w_dmi_req_op));
   endrule

   rule rl_dmi_rsp;
      match {.data, .response} = bus_dmi_rsp.out.data;
      w_dmi_rsp_data <= data;
      w_dmi_rsp_response <= response;
   endrule

   (* preempts = "rl_dmi_req_cpu, rl_dmi_rsp_cpu" *)
   rule rl_dmi_req_cpu;
      match {.addr, .data, .op} = bus_dmi_req.out.first;
      bus_dmi_req.out.deq;
      case (op)
	 1: core.dm_dmi.read_addr(addr);
	 2: begin
	       core.dm_dmi.write(addr, data);
	       bus_dmi_rsp.in.enq(tuple2(?, 0));
	    end
	 default: bus_dmi_rsp.in.enq(tuple2(?, 2));
      endcase
   endrule

   rule rl_dmi_rsp_cpu;
      let data <- core.dm_dmi.read_data;
      bus_dmi_rsp.in.enq(tuple2(data, 0));
   endrule

`endif

`ifdef INCLUDE_TANDEM_VERIF
   let tv_xactor <- mkTV_Xactor;
   mkConnection (core.tv_verifier_info_get, tv_xactor.tv_in);
`endif

   // ================================================================
   // INTERFACE

   // CPU IMem to Fabric master interface
   interface master0 = core.cpu_imem_master;

   // CPU DMem to Fabric master interface
   interface master1 = core.core_mem_master;

   // External interrupts
   method  Action interrupt_reqs (Bit #(N_External_Interrupt_Sources) reqs);
      for (Integer j = 0; j < valueOf (N_External_Interrupt_Sources); j = j + 1) begin
	 Bool req_j = unpack (reqs [j]);
	 core.core_external_interrupt_sources [j].m_interrupt_req (req_j);
      end
   endmethod

`ifdef INCLUDE_DMEM_SLAVE
   // ----------------------------------------------------------------
   // Optional AXI4-Lite D-cache slave interface

   interface AXI4Lite_Slave_Sig slave0 = core.cpu_dmem_slave;
`endif

`ifdef INCLUDE_TANDEM_VERIF
   // ----------------------------------------------------------------
   // Optional Tandem Verifier interface.  The data signal is
   // packed output tuples (n,vb),/ where 'vb' is a vector of
   // bytes with relevant bytes in locations [0]..[n-1]

   interface tv_verifier_info_tx = tv_xactor.axi_out;
`endif

`ifdef INCLUDE_GDB_CONTROL
   // ----------------------------------------------------------------
   // Optional Debug Module interfaces

`ifdef JTAG_TAP
   interface JTAG_IFC jtag = jtagtap.jtag;
`endif

`endif
endmodule

// ================================================================
// The TV to AXI4 Stream transactor

`ifdef INCLUDE_TANDEM_VERIF

// ================================================================
// TV AXI4 Stream Parameters

typedef SizeOf #(Info_CPU_to_Verifier)Wd_SData;
typedef 0 Wd_SDest;
typedef 0 Wd_SUser;
typedef 0 Wd_SId;

// ================================================================

interface TV_Xactor;
   interface Put #(Info_CPU_to_Verifier) tv_in;
   interface AXI4_Stream_Master_IFC #(Wd_SId, Wd_SDest, Wd_SData, Wd_SUser)  axi_out;
endinterface

function AXI4_Stream #(Wd_SId, Wd_SDest, Wd_SData, Wd_SUser) fn_TVToAxiS (Info_CPU_to_Verifier x);
   return AXI4_Stream {tid: ?,
		       tdata: pack(x),
		       tstrb: '1,
		       tkeep: '1,
		       tlast: True,
		       tdest: ?,
		       tuser: ? };
endfunction

(*synthesize*)
module mkTV_Xactor (TV_Xactor);
   AXI4_Stream_Master_Xactor_IFC #(Wd_SId, Wd_SDest, Wd_SData, Wd_SUser)
                               tv_xactor <- mkAXI4_Stream_Master_Xactor;

   interface Put tv_in;
      method Action put(x);
	 toPut(tv_xactor.i_stream).put(fn_TVToAxiS(x));
      endmethod
   endinterface

   interface axi_out = tv_xactor.axi_side;
endmodule
`endif

// ================================================================

endpackage
