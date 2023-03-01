//
// Generated by Bluespec Compiler, version untagged-gb2fda995 (build b2fda995)
//
//
// Ports:
// Name                         I/O  size props
// RDY_mv_vm_put_va               O     1 const
// mv_vm_get_xlate                O   204
// RDY_mv_vm_get_xlate            O     1 const
// RDY_ma_insert                  O     1 const
// RDY_ma_flush                   O     1 const
// CLK                            I     1 clock
// RST_N                          I     1 reset
// mv_vm_put_va_full_va           I    64
// mv_vm_get_xlate_satp           I    64
// mv_vm_get_xlate_read_not_write  I     1
// mv_vm_get_xlate_cap            I     1
// mv_vm_get_xlate_priv           I     2
// mv_vm_get_xlate_sstatus_SUM    I     1
// mv_vm_get_xlate_mstatus_MXR    I     1
// ma_insert_asid                 I    16
// ma_insert_vpn                  I    27
// ma_insert_pte                  I    64
// ma_insert_level                I     2
// ma_insert_pte_pa               I    64
// EN_mv_vm_put_va                I     1
// EN_ma_insert                   I     1
// EN_ma_flush                    I     1
//
// Combinational paths from inputs to outputs:
//   (mv_vm_get_xlate_satp,
//    mv_vm_get_xlate_read_not_write,
//    mv_vm_get_xlate_cap,
//    mv_vm_get_xlate_priv,
//    mv_vm_get_xlate_sstatus_SUM,
//    mv_vm_get_xlate_mstatus_MXR) -> mv_vm_get_xlate
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkTLB(CLK,
	     RST_N,

	     mv_vm_put_va_full_va,
	     EN_mv_vm_put_va,
	     RDY_mv_vm_put_va,

	     mv_vm_get_xlate_satp,
	     mv_vm_get_xlate_read_not_write,
	     mv_vm_get_xlate_cap,
	     mv_vm_get_xlate_priv,
	     mv_vm_get_xlate_sstatus_SUM,
	     mv_vm_get_xlate_mstatus_MXR,
	     mv_vm_get_xlate,
	     RDY_mv_vm_get_xlate,

	     ma_insert_asid,
	     ma_insert_vpn,
	     ma_insert_pte,
	     ma_insert_level,
	     ma_insert_pte_pa,
	     EN_ma_insert,
	     RDY_ma_insert,

	     EN_ma_flush,
	     RDY_ma_flush);
  parameter [0 : 0] dmem_not_imem = 1'b0;
  parameter [2 : 0] verbosity = 3'b0;
  input  CLK;
  input  RST_N;

  // action method mv_vm_put_va
  input  [63 : 0] mv_vm_put_va_full_va;
  input  EN_mv_vm_put_va;
  output RDY_mv_vm_put_va;

  // value method mv_vm_get_xlate
  input  [63 : 0] mv_vm_get_xlate_satp;
  input  mv_vm_get_xlate_read_not_write;
  input  mv_vm_get_xlate_cap;
  input  [1 : 0] mv_vm_get_xlate_priv;
  input  mv_vm_get_xlate_sstatus_SUM;
  input  mv_vm_get_xlate_mstatus_MXR;
  output [203 : 0] mv_vm_get_xlate;
  output RDY_mv_vm_get_xlate;

  // action method ma_insert
  input  [15 : 0] ma_insert_asid;
  input  [26 : 0] ma_insert_vpn;
  input  [63 : 0] ma_insert_pte;
  input  [1 : 0] ma_insert_level;
  input  [63 : 0] ma_insert_pte_pa;
  input  EN_ma_insert;
  output RDY_ma_insert;

  // action method ma_flush
  input  EN_ma_flush;
  output RDY_ma_flush;

  // signals for module outputs
  wire [203 : 0] mv_vm_get_xlate;
  wire RDY_ma_flush, RDY_ma_insert, RDY_mv_vm_get_xlate, RDY_mv_vm_put_va;

  // inlined wires
  wire [170 : 0] tlb0_entries_updateWire$wget;
  wire [26 : 0] tlb0_entries_lookupWire$wget;
  wire tlb0_entries_updateRegFresh_1$whas, tlb0_entries_updateWire$whas;

  // register rg_va
  reg [63 : 0] rg_va;
  wire [63 : 0] rg_va$D_IN;
  wire rg_va$EN;

  // register tlb0_entries_clearIx
  reg [7 : 0] tlb0_entries_clearIx;
  wire [7 : 0] tlb0_entries_clearIx$D_IN;
  wire tlb0_entries_clearIx$EN;

  // register tlb0_entries_lookupReg
  reg [26 : 0] tlb0_entries_lookupReg;
  wire [26 : 0] tlb0_entries_lookupReg$D_IN;
  wire tlb0_entries_lookupReg$EN;

  // register tlb0_entries_updateReg
  reg [171 : 0] tlb0_entries_updateReg;
  wire [171 : 0] tlb0_entries_updateReg$D_IN;
  wire tlb0_entries_updateReg$EN;

  // register tlb0_entries_updateRegFresh
  reg tlb0_entries_updateRegFresh;
  wire tlb0_entries_updateRegFresh$D_IN, tlb0_entries_updateRegFresh$EN;

  // register tlb0_entries_wayNext
  reg tlb0_entries_wayNext;
  wire tlb0_entries_wayNext$D_IN, tlb0_entries_wayNext$EN;

  // register tlb1_entries_clearCount
  reg [1 : 0] tlb1_entries_clearCount;
  wire [1 : 0] tlb1_entries_clearCount$D_IN;
  wire tlb1_entries_clearCount$EN;

  // register tlb1_entries_clearReg
  reg tlb1_entries_clearReg;
  wire tlb1_entries_clearReg$D_IN, tlb1_entries_clearReg$EN;

  // register tlb2_entries_clearCount
  reg [1 : 0] tlb2_entries_clearCount;
  wire [1 : 0] tlb2_entries_clearCount$D_IN;
  wire tlb2_entries_clearCount$EN;

  // register tlb2_entries_clearReg
  reg tlb2_entries_clearReg;
  wire tlb2_entries_clearReg$D_IN, tlb2_entries_clearReg$EN;

  // ports of submodule tlb0_entries_clearReqQ
  wire tlb0_entries_clearReqQ$CLR,
       tlb0_entries_clearReqQ$DEQ,
       tlb0_entries_clearReqQ$EMPTY_N,
       tlb0_entries_clearReqQ$ENQ,
       tlb0_entries_clearReqQ$FULL_N;

  // ports of submodule tlb0_entries_mem_0_bram
  wire [163 : 0] tlb0_entries_mem_0_bram$DIA,
		 tlb0_entries_mem_0_bram$DIB,
		 tlb0_entries_mem_0_bram$DOA;
  wire [7 : 0] tlb0_entries_mem_0_bram$ADDRA, tlb0_entries_mem_0_bram$ADDRB;
  wire tlb0_entries_mem_0_bram$ENA,
       tlb0_entries_mem_0_bram$ENB,
       tlb0_entries_mem_0_bram$WEA,
       tlb0_entries_mem_0_bram$WEB;

  // ports of submodule tlb0_entries_mem_1_bram
  wire [163 : 0] tlb0_entries_mem_1_bram$DIA,
		 tlb0_entries_mem_1_bram$DIB,
		 tlb0_entries_mem_1_bram$DOA;
  wire [7 : 0] tlb0_entries_mem_1_bram$ADDRA, tlb0_entries_mem_1_bram$ADDRB;
  wire tlb0_entries_mem_1_bram$ENA,
       tlb0_entries_mem_1_bram$ENB,
       tlb0_entries_mem_1_bram$WEA,
       tlb0_entries_mem_1_bram$WEB;

  // ports of submodule tlb0_entries_updateKeys_0_bram
  wire [19 : 0] tlb0_entries_updateKeys_0_bram$DIA,
		tlb0_entries_updateKeys_0_bram$DIB,
		tlb0_entries_updateKeys_0_bram$DOA;
  wire [7 : 0] tlb0_entries_updateKeys_0_bram$ADDRA,
	       tlb0_entries_updateKeys_0_bram$ADDRB;
  wire tlb0_entries_updateKeys_0_bram$ENA,
       tlb0_entries_updateKeys_0_bram$ENB,
       tlb0_entries_updateKeys_0_bram$WEA,
       tlb0_entries_updateKeys_0_bram$WEB;

  // ports of submodule tlb0_entries_updateKeys_1_bram
  wire [19 : 0] tlb0_entries_updateKeys_1_bram$DIA,
		tlb0_entries_updateKeys_1_bram$DIB,
		tlb0_entries_updateKeys_1_bram$DOA;
  wire [7 : 0] tlb0_entries_updateKeys_1_bram$ADDRA,
	       tlb0_entries_updateKeys_1_bram$ADDRB;
  wire tlb0_entries_updateKeys_1_bram$ENA,
       tlb0_entries_updateKeys_1_bram$ENB,
       tlb0_entries_updateKeys_1_bram$WEA,
       tlb0_entries_updateKeys_1_bram$WEB;

  // ports of submodule tlb1_entries_mem_0
  wire [160 : 0] tlb1_entries_mem_0$D_IN, tlb1_entries_mem_0$D_OUT_1;
  wire [1 : 0] tlb1_entries_mem_0$ADDR_1,
	       tlb1_entries_mem_0$ADDR_2,
	       tlb1_entries_mem_0$ADDR_3,
	       tlb1_entries_mem_0$ADDR_4,
	       tlb1_entries_mem_0$ADDR_5,
	       tlb1_entries_mem_0$ADDR_IN;
  wire tlb1_entries_mem_0$WE;

  // ports of submodule tlb2_entries_mem_0
  wire [151 : 0] tlb2_entries_mem_0$D_IN, tlb2_entries_mem_0$D_OUT_1;
  wire [1 : 0] tlb2_entries_mem_0$ADDR_1,
	       tlb2_entries_mem_0$ADDR_2,
	       tlb2_entries_mem_0$ADDR_3,
	       tlb2_entries_mem_0$ADDR_4,
	       tlb2_entries_mem_0$ADDR_5,
	       tlb2_entries_mem_0$ADDR_IN;
  wire tlb2_entries_mem_0$WE;

  // rule scheduling signals
  wire CAN_FIRE_RL_rl_flush,
       CAN_FIRE_RL_tlb0_entries_updateCanonClear,
       CAN_FIRE_RL_tlb0_entries_updateRegFresh__dreg_update,
       CAN_FIRE_RL_tlb0_entries_writeUpdateReg,
       CAN_FIRE_RL_tlb1_entries_doClear,
       CAN_FIRE_RL_tlb2_entries_doClear,
       CAN_FIRE_ma_flush,
       CAN_FIRE_ma_insert,
       CAN_FIRE_mv_vm_put_va,
       WILL_FIRE_RL_rl_flush,
       WILL_FIRE_RL_tlb0_entries_updateCanonClear,
       WILL_FIRE_RL_tlb0_entries_updateRegFresh__dreg_update,
       WILL_FIRE_RL_tlb0_entries_writeUpdateReg,
       WILL_FIRE_RL_tlb1_entries_doClear,
       WILL_FIRE_RL_tlb2_entries_doClear,
       WILL_FIRE_ma_flush,
       WILL_FIRE_ma_insert,
       WILL_FIRE_mv_vm_put_va;

  // inputs to muxes for submodule ports
  wire [160 : 0] MUX_tlb1_entries_mem_0$upd_2__VAL_1;
  wire [151 : 0] MUX_tlb2_entries_mem_0$upd_2__VAL_1;
  wire MUX_tlb1_entries_clearReg$write_1__SEL_1,
       MUX_tlb1_entries_mem_0$upd_1__SEL_1,
       MUX_tlb2_entries_clearReg$write_1__SEL_1,
       MUX_tlb2_entries_mem_0$upd_1__SEL_1;

  // declarations used by system tasks
  // synopsys translate_off
  reg [31 : 0] v__h6249;
  reg [31 : 0] v__h4392;
  reg [31 : 0] v__h4386;
  reg [31 : 0] v__h6243;
  // synopsys translate_on

  // remaining internal signals
  reg [63 : 0] _theResult___fst__h4610;
  wire [129 : 0] IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d170,
		 IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175;
  wire [63 : 0] IF_tlb0_entries_mem_1_bram_a_read__00_BIT_163__ETC___d123,
		IF_tlb0_entries_mem_1_bram_a_read__00_BIT_163__ETC___d162,
		_theResult_____3_fst__h5888,
		_theResult_____4_fst__h5844,
		pa___1__h5933,
		pa___1__h5982,
		pa___1__h6050,
		pte___1__h4607,
		pte___1__h4609,
		result0_pte__h4950,
		result0_pte_pa__h4952,
		x__h4969,
		x__h4976,
		x__h5929,
		x__h6188;
  wire [55 : 0] x__h5936, x__h5985, x__h6053;
  wire [15 : 0] IF_tlb0_entries_mem_1_bram_a_read__00_BIT_163__ETC___d116;
  wire [7 : 0] v__h3816;
  wire [5 : 0] exc_code___1__h6146, result_exc_code__h4565;
  wire [1 : 0] IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d217;
  wire IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d119,
       NOT_mv_vm_get_xlate_cap_56_OR_dmem_not_imem_AN_ETC___d261,
       NOT_verbosity_ULE_1_4___d85,
       _theResult____h3129,
       dmem_not_imem_OR_NOT_mv_vm_get_xlate_read_not__ETC___d196,
       mv_vm_get_xlate_priv_EQ_0b0_57_AND_NOT_IF_tlb0_ETC___d202,
       mv_vm_get_xlate_priv_EQ_0b0_57_AND_NOT_IF_tlb0_ETC___d215,
       mv_vm_get_xlate_priv_EQ_0b0_57_AND_NOT_IF_tlb0_ETC___d263,
       mv_vm_get_xlate_priv_ULE_0b1_1_AND_mv_vm_get_x_ETC___d274,
       mv_vm_get_xlate_priv_ULE_0b1___d91,
       tlb0_entries_updateKeys_1_bram_a_read__6_BIT_1_ETC___d54,
       tlb0_entries_updateKeys_1_bram_a_read__6_BIT_1_ETC___d57,
       tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_en_ETC___d127,
       tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_en_ETC___d99,
       tlb1_entries_mem_0_sub_rg_va_28_BITS_22_TO_21__ETC___d141,
       tlb2_entries_mem_0_sub_rg_va_28_BITS_31_TO_30__ETC___d155,
       y__h5625;

  // action method mv_vm_put_va
  assign RDY_mv_vm_put_va = 1'd1 ;
  assign CAN_FIRE_mv_vm_put_va = 1'd1 ;
  assign WILL_FIRE_mv_vm_put_va = EN_mv_vm_put_va ;

  // value method mv_vm_get_xlate
  assign mv_vm_get_xlate =
	     { (mv_vm_get_xlate_priv_ULE_0b1___d91 &&
		mv_vm_get_xlate_satp[63:60] == 4'd8) ?
		 IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d217 :
		 2'd0,
	       !mv_vm_get_xlate_priv_ULE_0b1___d91 ||
	       mv_vm_get_xlate_satp[63:60] != 4'd8 ||
	       pte___1__h4609[62],
	       x__h5929,
	       result_exc_code__h4565,
	       mv_vm_get_xlate_priv_ULE_0b1_1_AND_mv_vm_get_x_ETC___d274,
	       x__h6188,
	       IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[65:0] } ;
  assign RDY_mv_vm_get_xlate = 1'd1 ;

  // action method ma_insert
  assign RDY_ma_insert = 1'd1 ;
  assign CAN_FIRE_ma_insert = 1'd1 ;
  assign WILL_FIRE_ma_insert = EN_ma_insert ;

  // action method ma_flush
  assign RDY_ma_flush = 1'd1 ;
  assign CAN_FIRE_ma_flush = 1'd1 ;
  assign WILL_FIRE_ma_flush = EN_ma_flush ;

  // submodule tlb0_entries_clearReqQ
  FIFO10 #(.guarded(1'd0)) tlb0_entries_clearReqQ(.RST(RST_N),
						  .CLK(CLK),
						  .ENQ(tlb0_entries_clearReqQ$ENQ),
						  .DEQ(tlb0_entries_clearReqQ$DEQ),
						  .CLR(tlb0_entries_clearReqQ$CLR),
						  .FULL_N(tlb0_entries_clearReqQ$FULL_N),
						  .EMPTY_N(tlb0_entries_clearReqQ$EMPTY_N));

  // submodule tlb0_entries_mem_0_bram
  BRAM2 #(.PIPELINED(1'd0),
	  .ADDR_WIDTH(32'd8),
	  .DATA_WIDTH(32'd164),
	  .MEMSIZE(9'd256)) tlb0_entries_mem_0_bram(.CLKA(CLK),
						    .CLKB(CLK),
						    .ADDRA(tlb0_entries_mem_0_bram$ADDRA),
						    .ADDRB(tlb0_entries_mem_0_bram$ADDRB),
						    .DIA(tlb0_entries_mem_0_bram$DIA),
						    .DIB(tlb0_entries_mem_0_bram$DIB),
						    .WEA(tlb0_entries_mem_0_bram$WEA),
						    .WEB(tlb0_entries_mem_0_bram$WEB),
						    .ENA(tlb0_entries_mem_0_bram$ENA),
						    .ENB(tlb0_entries_mem_0_bram$ENB),
						    .DOA(tlb0_entries_mem_0_bram$DOA),
						    .DOB());

  // submodule tlb0_entries_mem_1_bram
  BRAM2 #(.PIPELINED(1'd0),
	  .ADDR_WIDTH(32'd8),
	  .DATA_WIDTH(32'd164),
	  .MEMSIZE(9'd256)) tlb0_entries_mem_1_bram(.CLKA(CLK),
						    .CLKB(CLK),
						    .ADDRA(tlb0_entries_mem_1_bram$ADDRA),
						    .ADDRB(tlb0_entries_mem_1_bram$ADDRB),
						    .DIA(tlb0_entries_mem_1_bram$DIA),
						    .DIB(tlb0_entries_mem_1_bram$DIB),
						    .WEA(tlb0_entries_mem_1_bram$WEA),
						    .WEB(tlb0_entries_mem_1_bram$WEB),
						    .ENA(tlb0_entries_mem_1_bram$ENA),
						    .ENB(tlb0_entries_mem_1_bram$ENB),
						    .DOA(tlb0_entries_mem_1_bram$DOA),
						    .DOB());

  // submodule tlb0_entries_updateKeys_0_bram
  BRAM2 #(.PIPELINED(1'd0),
	  .ADDR_WIDTH(32'd8),
	  .DATA_WIDTH(32'd20),
	  .MEMSIZE(9'd256)) tlb0_entries_updateKeys_0_bram(.CLKA(CLK),
							   .CLKB(CLK),
							   .ADDRA(tlb0_entries_updateKeys_0_bram$ADDRA),
							   .ADDRB(tlb0_entries_updateKeys_0_bram$ADDRB),
							   .DIA(tlb0_entries_updateKeys_0_bram$DIA),
							   .DIB(tlb0_entries_updateKeys_0_bram$DIB),
							   .WEA(tlb0_entries_updateKeys_0_bram$WEA),
							   .WEB(tlb0_entries_updateKeys_0_bram$WEB),
							   .ENA(tlb0_entries_updateKeys_0_bram$ENA),
							   .ENB(tlb0_entries_updateKeys_0_bram$ENB),
							   .DOA(tlb0_entries_updateKeys_0_bram$DOA),
							   .DOB());

  // submodule tlb0_entries_updateKeys_1_bram
  BRAM2 #(.PIPELINED(1'd0),
	  .ADDR_WIDTH(32'd8),
	  .DATA_WIDTH(32'd20),
	  .MEMSIZE(9'd256)) tlb0_entries_updateKeys_1_bram(.CLKA(CLK),
							   .CLKB(CLK),
							   .ADDRA(tlb0_entries_updateKeys_1_bram$ADDRA),
							   .ADDRB(tlb0_entries_updateKeys_1_bram$ADDRB),
							   .DIA(tlb0_entries_updateKeys_1_bram$DIA),
							   .DIB(tlb0_entries_updateKeys_1_bram$DIB),
							   .WEA(tlb0_entries_updateKeys_1_bram$WEA),
							   .WEB(tlb0_entries_updateKeys_1_bram$WEB),
							   .ENA(tlb0_entries_updateKeys_1_bram$ENA),
							   .ENB(tlb0_entries_updateKeys_1_bram$ENB),
							   .DOA(tlb0_entries_updateKeys_1_bram$DOA),
							   .DOB());

  // submodule tlb1_entries_mem_0
  RegFile #(.addr_width(32'd2),
	    .data_width(32'd161),
	    .lo(2'd0),
	    .hi(2'd3)) tlb1_entries_mem_0(.CLK(CLK),
					  .ADDR_1(tlb1_entries_mem_0$ADDR_1),
					  .ADDR_2(tlb1_entries_mem_0$ADDR_2),
					  .ADDR_3(tlb1_entries_mem_0$ADDR_3),
					  .ADDR_4(tlb1_entries_mem_0$ADDR_4),
					  .ADDR_5(tlb1_entries_mem_0$ADDR_5),
					  .ADDR_IN(tlb1_entries_mem_0$ADDR_IN),
					  .D_IN(tlb1_entries_mem_0$D_IN),
					  .WE(tlb1_entries_mem_0$WE),
					  .D_OUT_1(tlb1_entries_mem_0$D_OUT_1),
					  .D_OUT_2(),
					  .D_OUT_3(),
					  .D_OUT_4(),
					  .D_OUT_5());

  // submodule tlb2_entries_mem_0
  RegFile #(.addr_width(32'd2),
	    .data_width(32'd152),
	    .lo(2'd0),
	    .hi(2'd3)) tlb2_entries_mem_0(.CLK(CLK),
					  .ADDR_1(tlb2_entries_mem_0$ADDR_1),
					  .ADDR_2(tlb2_entries_mem_0$ADDR_2),
					  .ADDR_3(tlb2_entries_mem_0$ADDR_3),
					  .ADDR_4(tlb2_entries_mem_0$ADDR_4),
					  .ADDR_5(tlb2_entries_mem_0$ADDR_5),
					  .ADDR_IN(tlb2_entries_mem_0$ADDR_IN),
					  .D_IN(tlb2_entries_mem_0$D_IN),
					  .WE(tlb2_entries_mem_0$WE),
					  .D_OUT_1(tlb2_entries_mem_0$D_OUT_1),
					  .D_OUT_2(),
					  .D_OUT_3(),
					  .D_OUT_4(),
					  .D_OUT_5());

  // rule RL_rl_flush
  assign CAN_FIRE_RL_rl_flush =
	     !tlb2_entries_clearReg && !tlb1_entries_clearReg && EN_ma_flush ;
  assign WILL_FIRE_RL_rl_flush = CAN_FIRE_RL_rl_flush ;

  // rule RL_tlb2_entries_doClear
  assign CAN_FIRE_RL_tlb2_entries_doClear =
	     tlb2_entries_clearReg && !MUX_tlb2_entries_mem_0$upd_1__SEL_1 ;
  assign WILL_FIRE_RL_tlb2_entries_doClear =
	     CAN_FIRE_RL_tlb2_entries_doClear && !EN_ma_insert ;

  // rule RL_tlb1_entries_doClear
  assign CAN_FIRE_RL_tlb1_entries_doClear =
	     tlb1_entries_clearReg && !MUX_tlb1_entries_mem_0$upd_1__SEL_1 ;
  assign WILL_FIRE_RL_tlb1_entries_doClear =
	     CAN_FIRE_RL_tlb1_entries_doClear && !EN_ma_insert ;

  // rule RL_tlb0_entries_updateCanonClear
  assign CAN_FIRE_RL_tlb0_entries_updateCanonClear = 1'd1 ;
  assign WILL_FIRE_RL_tlb0_entries_updateCanonClear = 1'd1 ;

  // rule RL_tlb0_entries_writeUpdateReg
  assign CAN_FIRE_RL_tlb0_entries_writeUpdateReg = 1'd1 ;
  assign WILL_FIRE_RL_tlb0_entries_writeUpdateReg = 1'd1 ;

  // rule RL_tlb0_entries_updateRegFresh__dreg_update
  assign CAN_FIRE_RL_tlb0_entries_updateRegFresh__dreg_update = 1'd1 ;
  assign WILL_FIRE_RL_tlb0_entries_updateRegFresh__dreg_update = 1'd1 ;

  // inputs to muxes for submodule ports
  assign MUX_tlb1_entries_clearReg$write_1__SEL_1 =
	     WILL_FIRE_RL_tlb1_entries_doClear &&
	     tlb1_entries_clearCount == 2'd3 ;
  assign MUX_tlb1_entries_mem_0$upd_1__SEL_1 =
	     EN_ma_insert && ma_insert_level == 2'd1 ;
  assign MUX_tlb2_entries_clearReg$write_1__SEL_1 =
	     WILL_FIRE_RL_tlb2_entries_doClear &&
	     tlb2_entries_clearCount == 2'd3 ;
  assign MUX_tlb2_entries_mem_0$upd_1__SEL_1 =
	     EN_ma_insert && ma_insert_level == 2'd2 ;
  assign MUX_tlb1_entries_mem_0$upd_2__VAL_1 =
	     { 1'd1,
	       ma_insert_vpn[26:11],
	       ma_insert_asid,
	       ma_insert_pte,
	       ma_insert_pte_pa } ;
  assign MUX_tlb2_entries_mem_0$upd_2__VAL_1 =
	     { 1'd1,
	       ma_insert_vpn[26:20],
	       ma_insert_asid,
	       ma_insert_pte,
	       ma_insert_pte_pa } ;

  // inlined wires
  assign tlb0_entries_lookupWire$wget = mv_vm_put_va_full_va[38:12] ;
  assign tlb0_entries_updateRegFresh_1$whas =
	     !tlb0_entries_clearReqQ$EMPTY_N && tlb0_entries_updateWire$whas ;
  assign tlb0_entries_updateWire$wget =
	     { ma_insert_vpn,
	       ma_insert_asid,
	       ma_insert_pte,
	       ma_insert_pte_pa } ;
  assign tlb0_entries_updateWire$whas =
	     EN_ma_insert && ma_insert_level == 2'd0 ;

  // register rg_va
  assign rg_va$D_IN = mv_vm_put_va_full_va ;
  assign rg_va$EN = EN_mv_vm_put_va ;

  // register tlb0_entries_clearIx
  assign tlb0_entries_clearIx$D_IN = tlb0_entries_clearIx + 8'd1 ;
  assign tlb0_entries_clearIx$EN = tlb0_entries_clearReqQ$EMPTY_N ;

  // register tlb0_entries_lookupReg
  assign tlb0_entries_lookupReg$D_IN =
	     EN_mv_vm_put_va ?
	       mv_vm_put_va_full_va[38:12] :
	       tlb0_entries_lookupReg ;
  assign tlb0_entries_lookupReg$EN = 1'd1 ;

  // register tlb0_entries_updateReg
  assign tlb0_entries_updateReg$D_IN =
	     { !tlb0_entries_clearReqQ$EMPTY_N,
	       tlb0_entries_updateWire$wget } ;
  assign tlb0_entries_updateReg$EN =
	     tlb0_entries_clearReqQ$EMPTY_N || tlb0_entries_updateWire$whas ;

  // register tlb0_entries_updateRegFresh
  assign tlb0_entries_updateRegFresh$D_IN =
	     tlb0_entries_updateRegFresh_1$whas ;
  assign tlb0_entries_updateRegFresh$EN = 1'd1 ;

  // register tlb0_entries_wayNext
  assign tlb0_entries_wayNext$D_IN = tlb0_entries_wayNext + 1'd1 ;
  assign tlb0_entries_wayNext$EN =
	     !tlb0_entries_clearReqQ$EMPTY_N && tlb0_entries_updateReg[171] &&
	     tlb0_entries_updateRegFresh ;

  // register tlb1_entries_clearCount
  assign tlb1_entries_clearCount$D_IN = tlb1_entries_clearCount + 2'd1 ;
  assign tlb1_entries_clearCount$EN = WILL_FIRE_RL_tlb1_entries_doClear ;

  // register tlb1_entries_clearReg
  assign tlb1_entries_clearReg$D_IN =
	     !MUX_tlb1_entries_clearReg$write_1__SEL_1 ;
  assign tlb1_entries_clearReg$EN =
	     WILL_FIRE_RL_tlb1_entries_doClear &&
	     tlb1_entries_clearCount == 2'd3 ||
	     WILL_FIRE_RL_rl_flush ;

  // register tlb2_entries_clearCount
  assign tlb2_entries_clearCount$D_IN = tlb2_entries_clearCount + 2'd1 ;
  assign tlb2_entries_clearCount$EN = WILL_FIRE_RL_tlb2_entries_doClear ;

  // register tlb2_entries_clearReg
  assign tlb2_entries_clearReg$D_IN =
	     !MUX_tlb2_entries_clearReg$write_1__SEL_1 ;
  assign tlb2_entries_clearReg$EN =
	     WILL_FIRE_RL_tlb2_entries_doClear &&
	     tlb2_entries_clearCount == 2'd3 ||
	     WILL_FIRE_RL_rl_flush ;

  // submodule tlb0_entries_clearReqQ
  assign tlb0_entries_clearReqQ$ENQ =
	     WILL_FIRE_RL_rl_flush && tlb0_entries_clearReqQ$FULL_N ;
  assign tlb0_entries_clearReqQ$DEQ =
	     tlb0_entries_clearReqQ$EMPTY_N &&
	     tlb0_entries_clearIx == 8'd255 ;
  assign tlb0_entries_clearReqQ$CLR = 1'b0 ;

  // submodule tlb0_entries_mem_0_bram
  assign tlb0_entries_mem_0_bram$ADDRA =
	     EN_mv_vm_put_va ?
	       tlb0_entries_lookupWire$wget[7:0] :
	       tlb0_entries_lookupReg[7:0] ;
  assign tlb0_entries_mem_0_bram$ADDRB =
	     tlb0_entries_clearReqQ$EMPTY_N ?
	       tlb0_entries_clearIx :
	       tlb0_entries_updateReg[151:144] ;
  assign tlb0_entries_mem_0_bram$DIA =
	     164'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA /* unspecified value */  ;
  assign tlb0_entries_mem_0_bram$DIB =
	     tlb0_entries_clearReqQ$EMPTY_N ?
	       164'h2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA :
	       { 1'd1,
		 tlb0_entries_updateReg[170:152],
		 tlb0_entries_updateReg[143:0] } ;
  assign tlb0_entries_mem_0_bram$WEA = 1'd0 ;
  assign tlb0_entries_mem_0_bram$WEB = 1'd1 ;
  assign tlb0_entries_mem_0_bram$ENA = 1'd1 ;
  assign tlb0_entries_mem_0_bram$ENB =
	     tlb0_entries_clearReqQ$EMPTY_N ||
	     tlb0_entries_updateKeys_1_bram_a_read__6_BIT_1_ETC___d54 ;

  // submodule tlb0_entries_mem_1_bram
  assign tlb0_entries_mem_1_bram$ADDRA =
	     EN_mv_vm_put_va ?
	       tlb0_entries_lookupWire$wget[7:0] :
	       tlb0_entries_lookupReg[7:0] ;
  assign tlb0_entries_mem_1_bram$ADDRB =
	     tlb0_entries_clearReqQ$EMPTY_N ?
	       tlb0_entries_clearIx :
	       tlb0_entries_updateReg[151:144] ;
  assign tlb0_entries_mem_1_bram$DIA =
	     164'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA /* unspecified value */  ;
  assign tlb0_entries_mem_1_bram$DIB =
	     tlb0_entries_clearReqQ$EMPTY_N ?
	       164'h2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA :
	       { 1'd1,
		 tlb0_entries_updateReg[170:152],
		 tlb0_entries_updateReg[143:0] } ;
  assign tlb0_entries_mem_1_bram$WEA = 1'd0 ;
  assign tlb0_entries_mem_1_bram$WEB = 1'd1 ;
  assign tlb0_entries_mem_1_bram$ENA = 1'd1 ;
  assign tlb0_entries_mem_1_bram$ENB =
	     tlb0_entries_clearReqQ$EMPTY_N ||
	     tlb0_entries_updateKeys_1_bram_a_read__6_BIT_1_ETC___d57 ;

  // submodule tlb0_entries_updateKeys_0_bram
  assign tlb0_entries_updateKeys_0_bram$ADDRA =
	     tlb0_entries_clearReqQ$EMPTY_N ?
	       tlb0_entries_updateReg[151:144] :
	       v__h3816 ;
  assign tlb0_entries_updateKeys_0_bram$ADDRB =
	     tlb0_entries_clearReqQ$EMPTY_N ?
	       tlb0_entries_clearIx :
	       tlb0_entries_updateReg[151:144] ;
  assign tlb0_entries_updateKeys_0_bram$DIA =
	     20'b10101010101010101010 /* unspecified value */  ;
  assign tlb0_entries_updateKeys_0_bram$DIB =
	     tlb0_entries_clearReqQ$EMPTY_N ?
	       20'd174762 :
	       { 1'd1, tlb0_entries_updateReg[170:152] } ;
  assign tlb0_entries_updateKeys_0_bram$WEA = 1'd0 ;
  assign tlb0_entries_updateKeys_0_bram$WEB = 1'd1 ;
  assign tlb0_entries_updateKeys_0_bram$ENA = 1'd1 ;
  assign tlb0_entries_updateKeys_0_bram$ENB =
	     tlb0_entries_clearReqQ$EMPTY_N ||
	     tlb0_entries_updateKeys_1_bram_a_read__6_BIT_1_ETC___d54 ;

  // submodule tlb0_entries_updateKeys_1_bram
  assign tlb0_entries_updateKeys_1_bram$ADDRA =
	     tlb0_entries_clearReqQ$EMPTY_N ?
	       tlb0_entries_updateReg[151:144] :
	       v__h3816 ;
  assign tlb0_entries_updateKeys_1_bram$ADDRB =
	     tlb0_entries_clearReqQ$EMPTY_N ?
	       tlb0_entries_clearIx :
	       tlb0_entries_updateReg[151:144] ;
  assign tlb0_entries_updateKeys_1_bram$DIA =
	     20'b10101010101010101010 /* unspecified value */  ;
  assign tlb0_entries_updateKeys_1_bram$DIB =
	     tlb0_entries_clearReqQ$EMPTY_N ?
	       20'd174762 :
	       { 1'd1, tlb0_entries_updateReg[170:152] } ;
  assign tlb0_entries_updateKeys_1_bram$WEA = 1'd0 ;
  assign tlb0_entries_updateKeys_1_bram$WEB = 1'd1 ;
  assign tlb0_entries_updateKeys_1_bram$ENA = 1'd1 ;
  assign tlb0_entries_updateKeys_1_bram$ENB =
	     tlb0_entries_clearReqQ$EMPTY_N ||
	     tlb0_entries_updateKeys_1_bram_a_read__6_BIT_1_ETC___d57 ;

  // submodule tlb1_entries_mem_0
  assign tlb1_entries_mem_0$ADDR_1 = rg_va[22:21] ;
  assign tlb1_entries_mem_0$ADDR_2 = 2'h0 ;
  assign tlb1_entries_mem_0$ADDR_3 = 2'h0 ;
  assign tlb1_entries_mem_0$ADDR_4 = 2'h0 ;
  assign tlb1_entries_mem_0$ADDR_5 = 2'h0 ;
  assign tlb1_entries_mem_0$ADDR_IN =
	     MUX_tlb1_entries_mem_0$upd_1__SEL_1 ?
	       ma_insert_vpn[10:9] :
	       tlb1_entries_clearCount ;
  assign tlb1_entries_mem_0$D_IN =
	     MUX_tlb1_entries_mem_0$upd_1__SEL_1 ?
	       MUX_tlb1_entries_mem_0$upd_2__VAL_1 :
	       161'h0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ;
  assign tlb1_entries_mem_0$WE =
	     EN_ma_insert && ma_insert_level == 2'd1 ||
	     WILL_FIRE_RL_tlb1_entries_doClear ;

  // submodule tlb2_entries_mem_0
  assign tlb2_entries_mem_0$ADDR_1 = rg_va[31:30] ;
  assign tlb2_entries_mem_0$ADDR_2 = 2'h0 ;
  assign tlb2_entries_mem_0$ADDR_3 = 2'h0 ;
  assign tlb2_entries_mem_0$ADDR_4 = 2'h0 ;
  assign tlb2_entries_mem_0$ADDR_5 = 2'h0 ;
  assign tlb2_entries_mem_0$ADDR_IN =
	     MUX_tlb2_entries_mem_0$upd_1__SEL_1 ?
	       ma_insert_vpn[19:18] :
	       tlb2_entries_clearCount ;
  assign tlb2_entries_mem_0$D_IN =
	     MUX_tlb2_entries_mem_0$upd_1__SEL_1 ?
	       MUX_tlb2_entries_mem_0$upd_2__VAL_1 :
	       152'h2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ;
  assign tlb2_entries_mem_0$WE =
	     EN_ma_insert && ma_insert_level == 2'd2 ||
	     WILL_FIRE_RL_tlb2_entries_doClear ;

  // remaining internal signals
  assign IF_tlb0_entries_mem_1_bram_a_read__00_BIT_163__ETC___d116 =
	     (tlb0_entries_mem_1_bram$DOA[163] &&
	      tlb0_entries_lookupReg[26:8] ==
	      tlb0_entries_mem_1_bram$DOA[162:144]) ?
	       tlb0_entries_mem_1_bram$DOA[143:128] :
	       tlb0_entries_mem_0_bram$DOA[143:128] ;
  assign IF_tlb0_entries_mem_1_bram_a_read__00_BIT_163__ETC___d123 =
	     (tlb0_entries_mem_1_bram$DOA[163] &&
	      tlb0_entries_lookupReg[26:8] ==
	      tlb0_entries_mem_1_bram$DOA[162:144]) ?
	       tlb0_entries_mem_1_bram$DOA[127:64] :
	       tlb0_entries_mem_0_bram$DOA[127:64] ;
  assign IF_tlb0_entries_mem_1_bram_a_read__00_BIT_163__ETC___d162 =
	     (tlb0_entries_mem_1_bram$DOA[163] &&
	      tlb0_entries_lookupReg[26:8] ==
	      tlb0_entries_mem_1_bram$DOA[162:144]) ?
	       tlb0_entries_mem_1_bram$DOA[63:0] :
	       tlb0_entries_mem_0_bram$DOA[63:0] ;
  assign IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d119 =
	     (tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_en_ETC___d99 ?
		tlb0_entries_updateReg[143:128] :
		IF_tlb0_entries_mem_1_bram_a_read__00_BIT_163__ETC___d116) ==
	     mv_vm_get_xlate_satp[59:44] ;
  assign IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d170 =
	     { x__h4969, 2'd0, x__h4976 } |
	     (tlb1_entries_mem_0_sub_rg_va_28_BITS_22_TO_21__ETC___d141 ?
		{ tlb1_entries_mem_0$D_OUT_1[127:64],
		  2'd1,
		  tlb1_entries_mem_0$D_OUT_1[63:0] } :
		130'd0) ;
  assign IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175 =
	     IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d170 |
	     (tlb2_entries_mem_0_sub_rg_va_28_BITS_31_TO_30__ETC___d155 ?
		{ tlb2_entries_mem_0$D_OUT_1[127:64],
		  2'd2,
		  tlb2_entries_mem_0$D_OUT_1[63:0] } :
		130'd0) ;
  assign IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d217 =
	     (tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_en_ETC___d127 |
	      tlb1_entries_mem_0_sub_rg_va_28_BITS_22_TO_21__ETC___d141 |
	      tlb2_entries_mem_0_sub_rg_va_28_BITS_31_TO_30__ETC___d155) ?
	       (mv_vm_get_xlate_priv_EQ_0b0_57_AND_NOT_IF_tlb0_ETC___d215 ?
		  2'd2 :
		  2'd0) :
	       2'd1 ;
  assign NOT_mv_vm_get_xlate_cap_56_OR_dmem_not_imem_AN_ETC___d261 =
	     !mv_vm_get_xlate_cap ||
	     dmem_not_imem &&
	     (mv_vm_get_xlate_read_not_write ||
	      !mv_vm_get_xlate_read_not_write &&
	      IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[129]) ;
  assign NOT_verbosity_ULE_1_4___d85 = verbosity > 3'd1 ;
  assign _theResult_____3_fst__h5888 =
	     { pte___1__h4607[63:8], 1'd1, pte___1__h4607[6:0] } ;
  assign _theResult_____4_fst__h5844 =
	     { IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[129:73],
	       1'd1,
	       IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[71:66] } ;
  assign _theResult____h3129 =
	     tlb0_entries_updateKeys_1_bram$DOA[19] &&
	     tlb0_entries_updateReg[170:152] ==
	     tlb0_entries_updateKeys_1_bram$DOA[18:0] ||
	     (!tlb0_entries_updateKeys_0_bram$DOA[19] ||
	      tlb0_entries_updateReg[170:152] !=
	      tlb0_entries_updateKeys_0_bram$DOA[18:0]) &&
	     tlb0_entries_wayNext ;
  assign dmem_not_imem_OR_NOT_mv_vm_get_xlate_read_not__ETC___d196 =
	     (dmem_not_imem || !mv_vm_get_xlate_read_not_write ||
	      !IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[69]) &&
	     (!dmem_not_imem || !mv_vm_get_xlate_read_not_write ||
	      !(IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[67] |
		y__h5625)) ;
  assign exc_code___1__h6146 =
	     dmem_not_imem ?
	       (mv_vm_get_xlate_read_not_write ? 6'd13 : 6'd15) :
	       6'd12 ;
  assign mv_vm_get_xlate_priv_EQ_0b0_57_AND_NOT_IF_tlb0_ETC___d202 =
	     mv_vm_get_xlate_priv == 2'b0 &&
	     !IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[70] ||
	     mv_vm_get_xlate_priv == 2'b01 &&
	     IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[70] &&
	     !mv_vm_get_xlate_sstatus_SUM ||
	     dmem_not_imem_OR_NOT_mv_vm_get_xlate_read_not__ETC___d196 &&
	     (!dmem_not_imem || mv_vm_get_xlate_read_not_write ||
	      !IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[68]) ;
  assign mv_vm_get_xlate_priv_EQ_0b0_57_AND_NOT_IF_tlb0_ETC___d215 =
	     mv_vm_get_xlate_priv_EQ_0b0_57_AND_NOT_IF_tlb0_ETC___d202 ||
	     mv_vm_get_xlate_cap &&
	     (!dmem_not_imem || !mv_vm_get_xlate_read_not_write) &&
	     (!dmem_not_imem || mv_vm_get_xlate_read_not_write ||
	      !IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[129]) ||
	     !IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[72] ||
	     !mv_vm_get_xlate_read_not_write &&
	     !IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[73] ;
  assign mv_vm_get_xlate_priv_EQ_0b0_57_AND_NOT_IF_tlb0_ETC___d263 =
	     mv_vm_get_xlate_priv_EQ_0b0_57_AND_NOT_IF_tlb0_ETC___d202 ||
	     NOT_mv_vm_get_xlate_cap_56_OR_dmem_not_imem_AN_ETC___d261 &&
	     (!IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[72] ||
	      !mv_vm_get_xlate_read_not_write &&
	      !IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[73]) ;
  assign mv_vm_get_xlate_priv_ULE_0b1_1_AND_mv_vm_get_x_ETC___d274 =
	     mv_vm_get_xlate_priv_ULE_0b1___d91 &&
	     mv_vm_get_xlate_satp[63:60] == 4'd8 &&
	     (!pte___1__h4607[7] && !mv_vm_get_xlate_read_not_write ||
	      !IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[72]) ;
  assign mv_vm_get_xlate_priv_ULE_0b1___d91 = mv_vm_get_xlate_priv <= 2'b01 ;
  assign pa___1__h5933 = { 8'd0, x__h5936 } ;
  assign pa___1__h5982 = { 8'd0, x__h5985 } ;
  assign pa___1__h6050 = { 8'd0, x__h6053 } ;
  assign pte___1__h4607 =
	     IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[72] ?
	       IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[129:66] :
	       _theResult_____4_fst__h5844 ;
  assign pte___1__h4609 =
	     (!pte___1__h4607[7] && !mv_vm_get_xlate_read_not_write) ?
	       _theResult_____3_fst__h5888 :
	       pte___1__h4607 ;
  assign result0_pte__h4950 =
	     tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_en_ETC___d99 ?
	       tlb0_entries_updateReg[127:64] :
	       IF_tlb0_entries_mem_1_bram_a_read__00_BIT_163__ETC___d123 ;
  assign result0_pte_pa__h4952 =
	     tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_en_ETC___d99 ?
	       tlb0_entries_updateReg[63:0] :
	       IF_tlb0_entries_mem_1_bram_a_read__00_BIT_163__ETC___d162 ;
  assign result_exc_code__h4565 =
	     mv_vm_get_xlate_priv_EQ_0b0_57_AND_NOT_IF_tlb0_ETC___d263 ?
	       exc_code___1__h6146 :
	       6'd27 ;
  assign tlb0_entries_updateKeys_1_bram_a_read__6_BIT_1_ETC___d54 =
	     _theResult____h3129 == 1'd0 && !tlb0_entries_clearReqQ$EMPTY_N &&
	     tlb0_entries_updateReg[171] &&
	     tlb0_entries_updateRegFresh ;
  assign tlb0_entries_updateKeys_1_bram_a_read__6_BIT_1_ETC___d57 =
	     _theResult____h3129 == 1'd1 && !tlb0_entries_clearReqQ$EMPTY_N &&
	     tlb0_entries_updateReg[171] &&
	     tlb0_entries_updateRegFresh ;
  assign tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_en_ETC___d127 =
	     (tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_en_ETC___d99 ||
	      !tlb0_entries_clearReqQ$EMPTY_N &&
	      (tlb0_entries_mem_1_bram$DOA[163] &&
	       tlb0_entries_lookupReg[26:8] ==
	       tlb0_entries_mem_1_bram$DOA[162:144] ||
	       tlb0_entries_mem_0_bram$DOA[163] &&
	       tlb0_entries_lookupReg[26:8] ==
	       tlb0_entries_mem_0_bram$DOA[162:144])) &&
	     (IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d119 ||
	      result0_pte__h4950[5]) ;
  assign tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_en_ETC___d99 =
	     tlb0_entries_updateReg[171] &&
	     tlb0_entries_lookupReg[7:0] == tlb0_entries_updateReg[151:144] &&
	     tlb0_entries_lookupReg[26:8] == tlb0_entries_updateReg[170:152] ;
  assign tlb1_entries_mem_0_sub_rg_va_28_BITS_22_TO_21__ETC___d141 =
	     (tlb1_entries_mem_0$D_OUT_1[143:128] ==
	      mv_vm_get_xlate_satp[59:44] ||
	      tlb1_entries_mem_0$D_OUT_1[69]) &&
	     tlb1_entries_mem_0$D_OUT_1[160] &&
	     tlb1_entries_mem_0$D_OUT_1[159:144] == rg_va[38:23] &&
	     !tlb1_entries_clearReg ;
  assign tlb2_entries_mem_0_sub_rg_va_28_BITS_31_TO_30__ETC___d155 =
	     (tlb2_entries_mem_0$D_OUT_1[143:128] ==
	      mv_vm_get_xlate_satp[59:44] ||
	      tlb2_entries_mem_0$D_OUT_1[69]) &&
	     tlb2_entries_mem_0$D_OUT_1[151] &&
	     tlb2_entries_mem_0$D_OUT_1[150:144] == rg_va[38:32] &&
	     !tlb2_entries_clearReg ;
  assign v__h3816 =
	     tlb0_entries_updateWire$whas ?
	       tlb0_entries_updateWire$wget[151:144] :
	       tlb0_entries_updateReg[151:144] ;
  assign x__h4969 =
	     tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_en_ETC___d127 ?
	       result0_pte__h4950 :
	       64'd0 ;
  assign x__h4976 =
	     tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_en_ETC___d127 ?
	       result0_pte_pa__h4952 :
	       64'd0 ;
  assign x__h5929 =
	     (mv_vm_get_xlate_priv_ULE_0b1___d91 &&
	      mv_vm_get_xlate_satp[63:60] == 4'd8) ?
	       _theResult___fst__h4610 :
	       rg_va ;
  assign x__h5936 =
	     { IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[119:76],
	       rg_va[11:0] } ;
  assign x__h5985 =
	     { IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[119:85],
	       rg_va[20:0] } ;
  assign x__h6053 =
	     { IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[119:94],
	       rg_va[29:0] } ;
  assign x__h6188 =
	     (mv_vm_get_xlate_priv_ULE_0b1___d91 &&
	      mv_vm_get_xlate_satp[63:60] == 4'd8) ?
	       pte___1__h4609 :
	       IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[129:66] ;
  assign y__h5625 =
	     mv_vm_get_xlate_mstatus_MXR &
	     IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[69] ;
  always@(IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175 or
	  rg_va or pa___1__h5933 or pa___1__h5982 or pa___1__h6050)
  begin
    case (IF_tlb0_entries_updateReg_8_BIT_171_9_AND_tlb0_ETC___d175[65:64])
      2'd0: _theResult___fst__h4610 = pa___1__h5933;
      2'd1: _theResult___fst__h4610 = pa___1__h5982;
      2'd2: _theResult___fst__h4610 = pa___1__h6050;
      2'd3: _theResult___fst__h4610 = rg_va;
    endcase
  end

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        tlb0_entries_clearIx <= `BSV_ASSIGNMENT_DELAY 8'd0;
	tlb0_entries_lookupReg <= `BSV_ASSIGNMENT_DELAY 27'd0;
	tlb0_entries_updateReg <= `BSV_ASSIGNMENT_DELAY
	    172'h2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
	tlb0_entries_updateRegFresh <= `BSV_ASSIGNMENT_DELAY 1'd0;
	tlb0_entries_wayNext <= `BSV_ASSIGNMENT_DELAY 1'd0;
	tlb1_entries_clearCount <= `BSV_ASSIGNMENT_DELAY 2'd0;
	tlb1_entries_clearReg <= `BSV_ASSIGNMENT_DELAY 1'd0;
	tlb2_entries_clearCount <= `BSV_ASSIGNMENT_DELAY 2'd0;
	tlb2_entries_clearReg <= `BSV_ASSIGNMENT_DELAY 1'd0;
      end
    else
      begin
        if (tlb0_entries_clearIx$EN)
	  tlb0_entries_clearIx <= `BSV_ASSIGNMENT_DELAY
	      tlb0_entries_clearIx$D_IN;
	if (tlb0_entries_lookupReg$EN)
	  tlb0_entries_lookupReg <= `BSV_ASSIGNMENT_DELAY
	      tlb0_entries_lookupReg$D_IN;
	if (tlb0_entries_updateReg$EN)
	  tlb0_entries_updateReg <= `BSV_ASSIGNMENT_DELAY
	      tlb0_entries_updateReg$D_IN;
	if (tlb0_entries_updateRegFresh$EN)
	  tlb0_entries_updateRegFresh <= `BSV_ASSIGNMENT_DELAY
	      tlb0_entries_updateRegFresh$D_IN;
	if (tlb0_entries_wayNext$EN)
	  tlb0_entries_wayNext <= `BSV_ASSIGNMENT_DELAY
	      tlb0_entries_wayNext$D_IN;
	if (tlb1_entries_clearCount$EN)
	  tlb1_entries_clearCount <= `BSV_ASSIGNMENT_DELAY
	      tlb1_entries_clearCount$D_IN;
	if (tlb1_entries_clearReg$EN)
	  tlb1_entries_clearReg <= `BSV_ASSIGNMENT_DELAY
	      tlb1_entries_clearReg$D_IN;
	if (tlb2_entries_clearCount$EN)
	  tlb2_entries_clearCount <= `BSV_ASSIGNMENT_DELAY
	      tlb2_entries_clearCount$D_IN;
	if (tlb2_entries_clearReg$EN)
	  tlb2_entries_clearReg <= `BSV_ASSIGNMENT_DELAY
	      tlb2_entries_clearReg$D_IN;
      end
    if (rg_va$EN) rg_va <= `BSV_ASSIGNMENT_DELAY rg_va$D_IN;
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    rg_va = 64'hAAAAAAAAAAAAAAAA;
    tlb0_entries_clearIx = 8'hAA;
    tlb0_entries_lookupReg = 27'h2AAAAAA;
    tlb0_entries_updateReg = 172'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
    tlb0_entries_updateRegFresh = 1'h0;
    tlb0_entries_wayNext = 1'h0;
    tlb1_entries_clearCount = 2'h2;
    tlb1_entries_clearReg = 1'h0;
    tlb2_entries_clearCount = 2'h2;
    tlb2_entries_clearReg = 1'h0;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_mv_vm_put_va)
	$display("MapLookup - index: %x, key: %x",
		 mv_vm_put_va_full_va[19:12],
		 mv_vm_put_va_full_va[38:20]);
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_ma_insert && NOT_verbosity_ULE_1_4___d85)
	begin
	  v__h6249 = $stime;
	  #0;
	end
    v__h6243 = v__h6249 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_ma_insert && NOT_verbosity_ULE_1_4___d85)
	$display("%0d: %m.ma_insert: asid 0x%0h  vpn 0x%0h  pte 0x%0h  level %0d  pa 0x%0h",
		 v__h6243,
		 ma_insert_asid,
		 ma_insert_vpn,
		 ma_insert_pte,
		 ma_insert_level,
		 ma_insert_pte_pa);
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_flush && NOT_verbosity_ULE_1_4___d85)
	begin
	  v__h4392 = $stime;
	  #0;
	end
    v__h4386 = v__h4392 / 32'd10;
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_rl_flush && NOT_verbosity_ULE_1_4___d85)
	$display("%0d: %m.rl_flush", v__h4386);
    if (RST_N != `BSV_RESET_VALUE)
      if (!tlb0_entries_clearReqQ$EMPTY_N && tlb0_entries_updateReg[171] &&
	  tlb0_entries_updateRegFresh)
	$display("MapUpdate - index: %x, key: %x, value: %x, way: %x",
		 tlb0_entries_updateReg[151:144],
		 tlb0_entries_updateReg[170:152],
		 tlb0_entries_updateReg[143:0],
		 _theResult____h3129);
  end
  // synopsys translate_on
endmodule  // mkTLB

