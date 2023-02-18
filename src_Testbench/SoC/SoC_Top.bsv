// Copyright (c) 2016-2020 Bluespec, Inc. All Rights Reserved.

//-
// RVFI_DII modifications:
//     Copyright (c) 2018 Peter Rugg
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

package SoC_Top;

// ================================================================
// This package is the SoC "top-level".

// (Note: there will be further layer(s) above this for
//    simulation top-level, FPGA top-level, etc.)

// ================================================================
// Exports

export SoC_Top_IFC (..), mkSoC_Top;

// ================================================================
// BSV library imports

import FIFOF         :: *;
import GetPut        :: *;
import ClientServer  :: *;
import Connectable   :: *;
import Memory        :: *;
import Vector        :: *;

// ----------------
// BSV additional libs

import Cur_Cycle   :: *;
import GetPut_Aux  :: *;
import Routable    :: *;
import AXI4        :: *;
import AXI4Lite :: *;

// ================================================================
// Project imports

import Fabric_Defs :: *;
import SoC_Map     :: *;

// SoC components (CPU, mem, and IPs)

import Near_Mem_IFC :: *;    // For Wd_{Id,Addr,Data,User}_Dma
import Core_IFC     :: *;
import Core         :: *;
import PLIC         :: *;    // For interface to PLIC interrupt sources, in Core_IFC

import Boot_ROM       :: *;
import Mem_Controller :: *;
import UART_Model     :: *;

`ifdef INCLUDE_CAMERA_MODEL
import Camera_Model   :: *;
`endif

`ifdef INCLUDE_ACCEL0
import AXI4_Accel_IFC :: *;
import AXI4_Accel     :: *;
`endif

import AXI4_Types  :: *;
import Fabric_Defs :: *;

`ifdef INCLUDE_TANDEM_VERIF
import TV_Info :: *;
`endif

`ifdef RVFI_DII
import RVFI_DII  :: *;
import ISA_Decls :: *;
`endif

`ifdef INCLUDE_GDB_CONTROL
import External_Control :: *;    // Control requests/responses from HSFE
import Debug_Module     :: *;
`endif

// import ContinuousMonitoringStruct :: *;
import ContinuousMonitoring_IFC :: *;
import CPU_Globals :: *;
import ISA_Decls :: *;

// for mkResetInverter
import Clocks :: *;

// ================================================================
// The outermost interface of the SoC

interface SoC_Top_IFC;
`ifdef INCLUDE_GDB_CONTROL
   // To external controller (E.g., GDB)
   interface Server #(Control_Req, Control_Rsp) server_external_control;
`endif

`ifdef INCLUDE_TANDEM_VERIF
   // To tandem verifier
   interface Get #(Info_CPU_to_Verifier) tv_verifier_info_get;
`elsif RVFI_DII
   interface Flute_RVFI_DII_Server rvfi_dii_server;
`endif

   // External real memory
   interface MemoryClient #(Bits_per_Raw_Mem_Addr, Bits_per_Raw_Mem_Word)  to_raw_mem;

   // UART0 to external console
   interface Get #(Bit #(8)) get_to_console;
   interface Put #(Bit #(8)) put_from_console;



   // Catch-all status; return-value can identify the origin (0 = none)
   (* always_ready *)
   method Bit #(8) status;

   // ----------------------------------------------------------------
   // Misc. control and status

   // ----------------
   // Debugging: set core's verbosity
   method Action  set_verbosity (Bit #(4)  verbosity, Bit #(64)  logdelay);

   // ----------------
   // For ISA tests: watch memory writes to <tohost> addr
`ifdef WATCH_TOHOST
   method Action set_watch_tohost (Bool  watch_tohost, Fabric_Addr  tohost_addr);
   method Bit #(64) mv_tohost_value;
`endif

   // ----------------
   // Inform core that DDR4 has been initialized and is ready to accept requests
   method Action ma_ddr4_ready;

   // ----------------
   // Misc. status; 0 = running, no error
   (* always_ready *)
   method Bit #(8) mv_status;

   // (* always_ready, always_enabled *)
   // method ContinuousMonitoringStruct cms;
   interface ContinuousMonitoring_IFC cms_ifc;

   // (* always_ready, always_enabled *)
   // method PCC_T pcc;

   //(* always_ready, always_enabled *)
   //method WordXL pc;

   //(* always_ready, always_enabled *)
   //method Instr instr;

   //(* always_ready, always_enabled *)
   //method Bool pc_valid;

   interface AXI4_Master_Sig #( Wd_MId_ext, Wd_Addr, Wd_Data, Wd_AW_User_ext, Wd_W_User_ext, Wd_B_User_ext, Wd_AR_User_ext, Wd_R_User_ext) core_dmem_pre_fabric;
   // interface AXI4_Master_Sig #( Wd_MId_ext, Wd_Addr, Wd_Data, Wd_AW_User_ext, Wd_W_User_ext, Wd_B_User_ext, Wd_AR_User_ext, Wd_R_User_ext) core_dmem_post_fabric;
   interface AXI4_Master_Sig #(7, Wd_Addr, Wd_Data, Wd_AW_User_ext, Wd_W_User_ext, Wd_B_User_ext, Wd_AR_User_ext, Wd_R_User_ext) core_dmem_post_fabric;
   // interface AXI4_Slave #(Wd_SId, Wd_Addr, Wd_Data_Periph, 0, 0, 0, 0, 0) other_peripherals;
   // interface AXI4_Slave_Sig #(Wd_SId, Wd_Addr, Wd_Data_Periph, 0, 0, 0, 0, 0) other_peripherals_sig;

   (* always_enabled, always_ready *)
   interface Bool cpu_reset_completed;
endinterface

// ================================================================
// Local types and constants

typedef enum {SOC_START,
	      SOC_RESETTING,
`ifdef INCLUDE_GDB_CONTROL
	      SOC_RESETTING_NDM,
`endif
	      SOC_IDLE} SoC_State
deriving (Bits, Eq, FShow);

// ================================================================
// The module

(* synthesize *)
module mkSoC_Top (SoC_Top_IFC);
   Integer verbosity = 2;    // Normally 0; non-zero for debugging

   Reg #(SoC_State) rg_state <- mkReg (SOC_START);

   // SoC address map specifying base and limit for memories, IPs, etc.
   SoC_Map_IFC soc_map <- mkSoC_Map;

   // Core: CPU + Near_Mem_IO (CLINT) + PLIC + Debug module (optional) + TV (optional)
   Core_IFC #(N_External_Interrupt_Sources)  core <- mkCore;

   // SoC Boot ROM
   Boot_ROM_IFC  boot_rom <- mkBoot_ROM;
   // AXI4 Deburster in front of Boot_ROM
   AXI4_Shim#( Wd_SId, Wd_Addr, Wd_Data
             , 0, 0, 0, 0, 0)
      boot_rom_axi4_deburster <- mkBurstToNoBurst;

   // SoC Memory
   Mem_Controller_IFC  mem0_controller <- mkMem_Controller;
   // AXI4 Deburster in front of SoC Memory
   AXI4_Shim#( Wd_SId, Wd_Addr, Wd_Data
             , 0, 0, 0, 0, 0)
      mem0_controller_axi4_deburster <- mkBurstToNoBurst;

   // AXI4 Deburster in front of the new port (other_peripherals)
   AXI4_Shim#( Wd_SId, Wd_Addr, Wd_Data
             , 0, 0, 0, 0, 0)
      other_peripherals_deburster <- mkBurstToNoBurst;

   // SoC IPs
   UART_IFC   uart0  <- mkUART;


   let core_mem_master_sig <- toAXI4_Master_Sig (core.core_mem_master);


   let s_otherPeripheralsPortShim <- mkAXI4ShimFF;
   // let m_otherPeripheralsPortShim <- mkAXI4Shim;
   // let m_otherPeripheralsPortShim_sig <- toAXI4_Master_Sig (m_otherPeripheralsPortShim.master);
   // this test_sig is just to get rid of the error message (due to ambiguity), I'm not sure how to fix/declare it properly
   // AXI4_Slave_Sig #(Wd_SId, Wd_Addr, Wd_Data_Periph, 0, 0, 0, 0, 0) test_sig <- toAXI4_Slave_Sig( s_otherPeripheralsPortShim.slave );
   let test <- toAXI4_Master_Sig( s_otherPeripheralsPortShim.master );

   //mkConnection(s_otherPeripheralsPortShim.master, s_otherPeripheralsPortShim.slave);

   // mkConnection(test, test_sig);

`ifdef INCLUDE_ACCEL0
   // Accel0 master to fabric
   AXI4_Accel_IFC  accel0 <- mkAXI4_Accel;
`endif

   // ----------------
   // SoC fabric master connections
   // Note: see 'SoC_Map' for 'master_num' definitions

   Vector#(Num_Masters, AXI4_Master #( Wd_MId_ext, Wd_Addr, Wd_Data
                                     , Wd_AW_User_ext, Wd_W_User_ext, Wd_B_User_ext
                                     , Wd_AR_User_ext, Wd_R_User_ext))
      master_vector = newVector;

   // CPU IMem master to fabric
   master_vector[imem_master_num] = prepend_AXI4_Master_id(0, zero_AXI4_Master_user(core.cpu_imem_master));

   // CPU DMem master to fabric
   master_vector[dmem_master_num] = core.core_mem_master;

   // Tie-off unused 'coherent DMA port' into optional L2 cache (LLC, Last Level Cache)
   AXI4_Master #( Wd_Id_Dma, Wd_Addr_Dma, Wd_Data_Dma
                , Wd_AW_User_Dma, Wd_W_User_Dma, Wd_B_User_Dma
                , Wd_AR_User_Dma, Wd_R_User_Dma)
                   dummy_master = culDeSac;
   mkConnection (dummy_master, core.dma_server);

`ifdef INCLUDE_ACCEL0
   // accel_aes0 to fabric
   mkConnection (accel0.master,  fabric.v_from_masters [accel0_master_num]);
`endif

   // ----------------
   // SoC fabric slave connections
   // Note: see 'SoC_Map' for 'slave_num' definitions

   Vector#(Num_Slaves, AXI4_Slave #( Wd_SId, Wd_Addr, Wd_Data
                                   , Wd_AW_User_ext, Wd_W_User_ext, Wd_B_User_ext
                                   , Wd_AR_User_ext, Wd_R_User_ext))
      slave_vector = newVector;
   Vector#(Num_Slaves, Range#(Wd_Addr))   route_vector = newVector;


   // let shim_test <- mkAXI4ShimFF; 
   // mkConnection (shim_test.master,  fabric.v_from_masters [other_peripherals_master_num]);

   // Fabric to Boot ROM
   mkConnection(boot_rom_axi4_deburster.master, boot_rom.slave);
   slave_vector[boot_rom_slave_num] = zero_AXI4_Slave_user(boot_rom_axi4_deburster.slave);
   route_vector[boot_rom_slave_num] = soc_map.m_boot_rom_addr_range;

   // Fabric to Mem Controller
   mkConnection(mem0_controller_axi4_deburster.master, mem0_controller.slave);
   slave_vector[mem0_controller_slave_num] = zero_AXI4_Slave_user(mem0_controller_axi4_deburster.slave);
   route_vector[mem0_controller_slave_num] = soc_map.m_mem0_controller_addr_range;

   // Fabric to UART0
   slave_vector[uart0_slave_num] = zero_AXI4_Slave_user(uart0.slave);
   route_vector[uart0_slave_num] = soc_map.m_uart0_addr_range;

   // Fabric to other peripherals
   // slave_vector[other_peripherals_slave_num] = zero_AXI4_Slave_user(s_otherPeripheralsPortShim.slave);
   mkConnection(other_peripherals_deburster.master, s_otherPeripheralsPortShim.slave);
   slave_vector[other_peripherals_slave_num] = zero_AXI4_Slave_user(other_peripherals_deburster.slave);
   route_vector[other_peripherals_slave_num] = soc_map.m_other_peripherals_addr_range;

`ifdef HTIF_MEMORY
   AXI4_Slave_IFC#(Wd_Id, Wd_Addr, Wd_Data, Wd_User) htif <- mkAxi4LRegFile(bytes_per_htif);

   slave_vector[htif_slave_num] = htif;
   route_vector[htif_slave_num] = soc_map.m_htif_addr_range;
`endif

   // SoC Fabric
   let bus <- mkAXI4Bus ( routeFromMappingTable(route_vector)
                        , master_vector, slave_vector);


   Reset rst_n <- exposeCurrentReset;
   // Reset rst_n <- mkResetInverter(rst);
   Reg#(Bool) rg_cpu_reset_completed <- mkReg(False, reset_by rst_n);

   // ----------------
   // Connect interrupt sources for CPU external interrupt request inputs.

   // Reg #(Bool) rg_intr_prev <- mkReg (False);    // For debugging only

   (* fire_when_enabled, no_implicit_conditions *)
   rule rl_connect_external_interrupt_requests;
      Bool intr = uart0.intr;

      // UART
      core.core_external_interrupt_sources [irq_num_uart0].m_interrupt_req (intr);
      Integer last_irq_num = irq_num_uart0;

`ifdef INCLUDE_ACCEL0
      Bool intr_accel0 = accel0.interrupt_req;
      core.core_external_interrupt_sources [irq_num_accel0].m_interrupt_req (intr_accel0);
      last_irq_num = irq_num_accel0;
`endif

      // Tie off remaining interrupt request lines (2..N)
      for (Integer j = last_irq_num + 1; j < valueOf (N_External_Interrupt_Sources); j = j + 1)
	 core.core_external_interrupt_sources [j].m_interrupt_req (False);

      // Non-maskable interrupt request. [Tie-off; TODO: connect to genuine sources]
      core.nmi_req (False);

      /* For debugging only
      if ((! rg_intr_prev) && intr)
	 $display ("SoC_Top: intr posedge");
      else if (rg_intr_prev && (! intr))
	 $display ("SoC_Top: intr negedge");

      rg_intr_prev <= intr;
      */
   endrule

   // ================================================================
   // SOFT RESET

   function Action fa_reset_start_actions (Bool running);
      action
	 core.cpu_reset_server.request.put (running);
	 mem0_controller.server_reset.request.put (?);
	 uart0.server_reset.request.put (?);
         boot_rom_axi4_deburster.clear;
         mem0_controller_axi4_deburster.clear;
         other_peripherals_deburster.clear;
      endaction
   endfunction

   function Action fa_reset_complete_actions ();
      action
	 let cpu_rsp             <- core.cpu_reset_server.response.get;
	 let mem0_controller_rsp <- mem0_controller.server_reset.response.get;
	 let uart0_rsp           <- uart0.server_reset.response.get;

    // if cpu_reset_server response is ready, then reset is complete
    rg_cpu_reset_completed <= True;

	 // Initialize address maps of slave IPs
	 boot_rom.set_addr_map (rangeBase(soc_map.m_boot_rom_addr_range),
				rangeTop(soc_map.m_boot_rom_addr_range));

	 mem0_controller.set_addr_map (rangeBase(soc_map.m_mem0_controller_addr_range),
				       rangeTop(soc_map.m_mem0_controller_addr_range));

	 uart0.set_addr_map (rangeBase(soc_map.m_uart0_addr_range),
                             rangeTop(soc_map.m_uart0_addr_range));

`ifdef INCLUDE_ACCEL0
	 accel0.init (fabric_default_id,
		      soc_map.m_accel0_addr_base,
		      soc_map.m_accel0_addr_lim);
`endif

	 if (verbosity != 0) begin
	    $display ("  SoC address map:");
	    $display ("  Boot ROM:        0x%0h .. 0x%0h",
		      rangeBase(soc_map.m_boot_rom_addr_range),
		      rangeTop(soc_map.m_boot_rom_addr_range));
	    $display ("  Mem0 Controller: 0x%0h .. 0x%0h",
		      rangeBase(soc_map.m_mem0_controller_addr_range),
		      rangeTop(soc_map.m_mem0_controller_addr_range));
	    $display ("  UART0:           0x%0h .. 0x%0h",
		      rangeBase(soc_map.m_uart0_addr_range),
		      rangeTop(soc_map.m_uart0_addr_range));
	 end
      endaction
   endfunction

   // ----------------
   // Initial reset; CPU comes up running.

   rule rl_reset_start_initial (rg_state == SOC_START);
      Bool running = True;
      fa_reset_start_actions (running);
      rg_state <= SOC_RESETTING;

      $display ("%0d:%m.rl_reset_start_initial ...", cur_cycle);
   endrule

   rule rl_reset_complete_initial (rg_state == SOC_RESETTING);
      fa_reset_complete_actions;
      rg_state <= SOC_IDLE;

      $display ("%0d:%m.rl_reset_complete_initial", cur_cycle);
   endrule

   // ----------------
   // NDM (non-debug-module) reset (requested from Debug Module)
   // Request argument indicates if CPU comes up running or halted

`ifdef INCLUDE_GDB_CONTROL
   Reg #(Bool) rg_running <- mkRegU;

   rule rl_ndm_reset_start (rg_state == SOC_IDLE);
      let running <- core.ndm_reset_client.request.get;
      rg_running <= running;

      fa_reset_start_actions (running);
      rg_state <= SOC_RESETTING_NDM;

      $display ("%0d:%m.rl_ndm_reset_start (non-debug-module) running = ",
		cur_cycle, fshow (running));
   endrule

   rule rl_ndm_reset_complete (rg_state == SOC_RESETTING_NDM);
      fa_reset_complete_actions;
      rg_state <= SOC_IDLE;

      core.ndm_reset_client.response.put (rg_running);

      $display ("%0d:%m.rl_ndm_reset_complete (non-debug-module) running = ",
		cur_cycle, fshow (rg_running));
   endrule
`endif

   // ================================================================
   // BEHAVIOR WITH DEBUG MODULE

`ifdef INCLUDE_GDB_CONTROL
   // ----------------------------------------------------------------
   // External debug requests and responses (e.g., GDB)

   FIFOF #(Control_Req) f_external_control_reqs <- mkFIFOF;
   FIFOF #(Control_Rsp) f_external_control_rsps <- mkFIFOF;

   Control_Req req = f_external_control_reqs.first;

   rule rl_handle_external_req_read_request (req.op == external_control_req_op_read_control_fabric);
      f_external_control_reqs.deq;
      core.dm_dmi.read_addr (truncate (req.arg1));
      if (verbosity != 0) begin
	 $display ("%0d:%m.rl_handle_external_req_read_request", cur_cycle);
         $display ("    ", fshow (req));
      end
   endrule

   PulseWire didReadResponse <- mkPulseWire ();
   rule rl_handle_external_req_read_response;
      let x <- core.dm_dmi.read_data;
      let rsp = Control_Rsp {status: external_control_rsp_status_ok, result: signExtend (x)};
      f_external_control_rsps.enq (rsp);
      if (verbosity != 0) begin
	 $display ("%0d:%m.rl_handle_external_req_read_response", cur_cycle);
         $display ("    ", fshow (rsp));
      end
      didReadResponse.send();
   endrule

   rule rl_handle_external_req_write (req.op == external_control_req_op_write_control_fabric && !didReadResponse);
      f_external_control_reqs.deq;
      core.dm_dmi.write (truncate (req.arg1), truncate (req.arg2));
      // let rsp = Control_Rsp {status: external_control_rsp_status_ok, result: 0};
      // f_external_control_rsps.enq (rsp);
      if (verbosity != 0) begin
         $display ("%0d:%m.rl_handle_external_req_write", cur_cycle);
         $display ("    ", fshow (req));
      end
   endrule

   rule rl_handle_external_req_err (   (req.op != external_control_req_op_read_control_fabric)
				    && (req.op != external_control_req_op_write_control_fabric)
                                    && !didReadResponse);
      f_external_control_reqs.deq;
      let rsp = Control_Rsp {status: external_control_rsp_status_err, result: 0};
      f_external_control_rsps.enq (rsp);

      $display ("%0d:%m.rl_handle_external_req_err: unknown req.op", cur_cycle);
      $display ("    ", fshow (req));
   endrule

   // ----------------------------------------------------------------
   // NDM reset (all except Debug Module) request from debug module

   rule rl_reset_start (rg_state != SOC_RESETTING);
      let req <- core.ndm_reset_client.request.get;

      core.cpu_reset_server.request.put (?);
      mem0_controller.server_reset.request.put (?);
      uart0.server_reset.request.put (?);

      boot_rom_axi4_deburster.clear;
      mem0_controller_axi4_deburster.clear;
      other_peripherals_deburster.clear;

      rg_state <= SOC_RESETTING;

      $display ("%0d: SoC_Top.rl_reset_start (Debug Module NDM reset, all except debug module) ...",
		cur_cycle);
   endrule

`endif
/*
   rule rl_reset_complete (rg_state == SOC_RESETTING);
      let cpu_rsp             <- core.cpu_reset_server.response.get;
      let mem0_controller_rsp <- mem0_controller.server_reset.response.get;
      let uart0_rsp           <- uart0.server_reset.response.get;

      // Initialize address maps of slave IPs
      boot_rom.set_addr_map (rangeBase(soc_map.m_boot_rom_addr_range),
			     rangeTop(soc_map.m_boot_rom_addr_range));

      mem0_controller.set_addr_map (rangeBase(soc_map.m_mem0_controller_addr_range),
				    rangeTop(soc_map.m_mem0_controller_addr_range));

      uart0.set_addr_map (rangeBase(soc_map.m_uart0_addr_range),
                          rangeTop(soc_map.m_uart0_addr_range));

      rg_state <= SOC_IDLE;

`ifdef INCLUDE_GDB_CONTROL
      $display ("%0d: SoC_Top: NDM reset complete (all except debug module)", cur_cycle);
`else
      $display ("%0d: SoC_Top. Reset complete ...", cur_cycle);
`endif

      if (verbosity != 0) begin
	 $display ("  SoC address map:");
	 $display ("  Boot ROM:        0x%0h .. 0x%0h",
		   rangeBase(soc_map.m_boot_rom_addr_range),
		   rangeTop(soc_map.m_boot_rom_addr_range));
	 $display ("  Mem0 Controller: 0x%0h .. 0x%0h",
		   rangeBase(soc_map.m_mem0_controller_addr_range),
		   rangeTop(soc_map.m_mem0_controller_addr_range));
	 $display ("  UART0:           0x%0h .. 0x%0h",
		   rangeBase(soc_map.m_uart0_addr_range),
		   rangeTop(soc_map.m_uart0_addr_range));
      end
   endrule
*/

   method Bool cpu_reset_completed;
      return rg_cpu_reset_completed;
   endmethod

   // ================================================================
   // INTERFACE

   // To external controller (E.g., GDB)
`ifdef INCLUDE_GDB_CONTROL
   interface server_external_control = toGPServer (f_external_control_reqs, f_external_control_rsps);
`endif

`ifdef INCLUDE_TANDEM_VERIF
   // To tandem verifier
   interface tv_verifier_info_get = core.tv_verifier_info_get;
`elsif RVFI_DII
   interface rvfi_dii_server = core.rvfi_dii_server;
`endif

   // External real memory
   interface to_raw_mem = mem0_controller.to_raw_mem;

   // UART to external console
   interface get_to_console   = uart0.get_to_console;
   interface put_from_console = uart0.put_from_console;

   interface core_dmem_pre_fabric = core_mem_master_sig;
   // interface core_dmem_post_fabric = m_otherPeripheralsPortShim_sig;
   interface core_dmem_post_fabric = test;

   // Catch-all status; return-value can identify the origin (0 = none)
   method Bit #(8) status = 0;

   // ----------------------------------------------------------------
   // Misc. control and status

   method Action  set_verbosity (Bit #(4)  verbosity1, Bit #(64)  logdelay);
      core.set_verbosity (verbosity1, logdelay);
   endmethod

`ifdef WATCH_TOHOST
   // For ISA tests: watch memory writes to <tohost> addr
   method Action set_watch_tohost (Bool  watch_tohost, Fabric_Addr  tohost_addr);
      core.set_watch_tohost (watch_tohost, tohost_addr);
   endmethod

   method Bit #(64) mv_tohost_value;
      Bit #(64) tohost_value = 0;
      tohost_value = core.mv_tohost_value;
      return tohost_value;
   endmethod
`endif

   method Action ma_ddr4_ready;
      core.ma_ddr4_ready;
   endmethod

   method Bit #(8) mv_status;
      return core.mv_status;    // 0 = running, no error
   endmethod

   // method cms = core.cms;
   interface cms_ifc = core.cms_ifc;

   //method PCC_T pcc;
   //   return core.cms.pcc;
   //endmethod

   //method WordXL pc;
   //   //return getPC(core.cms.pcc);
   //   return core.cms.pc;
   //endmethod

   //method Instr instr;
   //   return core.cms.instr;
   //endmethod

   //method Bool pc_valid;
   //   return core.cms.pc_valid;
   //endmethod

   // Main Fabric Reqs/Rsps
   // interface  other_peripherals = s_otherPeripheralsPortShim.slave;
   // interface  other_peripherals_sig = test_sig;
endmodule: mkSoC_Top

// ================================================================

endpackage
