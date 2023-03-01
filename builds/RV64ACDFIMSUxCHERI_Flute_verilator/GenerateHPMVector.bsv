/*-
 * SPDX-License-Identifier: BSD-2-Clause
 *
 * This software was developed by SRI International and the University of
 * Cambridge Computer Laboratory (Department of Computer Science and
 * Technology) under DARPA contract HR0011-18-C-0016 ("ECATS"), as part of the
 * DARPA SSITH research programme.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

/*
 * This file was generated by the parse_counters.py script
 * 2022-12-14 17:00:45.129970
 */

import Vector::*;
import StatCounters::*;
import ISA_Decls::*;

function Vector#(115, Bit#(Report_Width)) generateHPMVector(HPMEvents ev);
	Vector#(115, Bit#(Report_Width)) events = replicate(0);
	if (ev.mab_EventsCore matches tagged Valid .t) begin
		events[0] = t.evt_NO_EV;
		events[1] = t.evt_REDIRECT;
		events[2] = t.evt_TRAP;
		events[3] = t.evt_BRANCH;
		events[4] = t.evt_JAL;
		events[5] = t.evt_JALR;
		events[6] = t.evt_AUIPC;
		events[7] = t.evt_LOAD;
		events[8] = t.evt_STORE;
		events[9] = t.evt_LR;
		events[10] = t.evt_SC;
		events[11] = t.evt_AMO;
		events[12] = t.evt_SERIAL_SHIFT;
		events[13] = t.evt_INT_MUL_DIV_REM;
		events[14] = t.evt_FP;
		events[15] = t.evt_SC_SUCCESS;
		events[16] = t.evt_LOAD_WAIT;
		events[17] = t.evt_STORE_WAIT;
		events[18] = t.evt_FENCE;
		events[19] = t.evt_F_BUSY_NO_CONSUME;
		events[20] = t.evt_D_BUSY_NO_CONSUME;
		events[21] = t.evt_1_BUSY_NO_CONSUME;
		events[22] = t.evt_2_BUSY_NO_CONSUME;
		events[23] = t.evt_3_BUSY_NO_CONSUME;
		events[24] = t.evt_IMPRECISE_SETBOUND;
		events[25] = t.evt_UNREPRESENTABLE_CAP;
		events[26] = t.evt_MEM_CAP_LOAD;
		events[27] = t.evt_MEM_CAP_STORE;
		events[28] = t.evt_MEM_CAP_LOAD_TAG_SET;
		events[29] = t.evt_MEM_CAP_STORE_TAG_SET;
		events[30] = t.evt_INTERRUPT;
	end
	if (ev.mab_EventsL1I matches tagged Valid .t) begin
		events[32] = t.evt_LD;
		events[33] = t.evt_LD_MISS;
		events[34] = t.evt_LD_MISS_LAT;
		events[41] = t.evt_TLB;
		events[42] = t.evt_TLB_MISS;
		events[43] = t.evt_TLB_MISS_LAT;
		events[44] = t.evt_TLB_FLUSH;
	end
	if (ev.mab_EventsL1D matches tagged Valid .t) begin
		events[48] = t.evt_LD;
		events[49] = t.evt_LD_MISS;
		events[50] = t.evt_LD_MISS_LAT;
		events[51] = t.evt_ST;
		events[52] = t.evt_ST_MISS;
		events[53] = t.evt_ST_MISS_LAT;
		events[54] = t.evt_AMO;
		events[55] = t.evt_AMO_MISS;
		events[56] = t.evt_AMO_MISS_LAT;
		events[57] = t.evt_TLB;
		events[58] = t.evt_TLB_MISS;
		events[59] = t.evt_TLB_MISS_LAT;
		events[60] = t.evt_TLB_FLUSH;
		events[61] = t.evt_EVICT;
	end
	if (ev.mab_EventsTGC matches tagged Valid .t) begin
		events[64] = t.evt_WRITE;
		events[65] = t.evt_WRITE_MISS;
		events[66] = t.evt_READ;
		events[67] = t.evt_READ_MISS;
		events[68] = t.evt_EVICT;
		events[69] = t.evt_SET_TAG_WRITE;
		events[70] = t.evt_SET_TAG_READ;
	end
	if (ev.mab_AXI4_Slave_Events matches tagged Valid .t) begin
		events[71] = t.evt_AW_FLIT;
		events[72] = t.evt_W_FLIT;
		events[73] = t.evt_W_FLIT_FINAL;
		events[74] = t.evt_B_FLIT;
		events[75] = t.evt_AR_FLIT;
		events[76] = t.evt_R_FLIT;
		events[77] = t.evt_R_FLIT_FINAL;
	end
	if (ev.mab_AXI4_Master_Events matches tagged Valid .t) begin
		events[78] = t.evt_AW_FLIT;
		events[79] = t.evt_W_FLIT;
		events[80] = t.evt_W_FLIT_FINAL;
		events[81] = t.evt_B_FLIT;
		events[82] = t.evt_AR_FLIT;
		events[83] = t.evt_R_FLIT;
		events[84] = t.evt_R_FLIT_FINAL;
	end
	if (ev.mab_EventsLL matches tagged Valid .t) begin
		events[96] = t.evt_LD;
		events[97] = t.evt_LD_MISS;
		events[98] = t.evt_LD_MISS_LAT;
		events[99] = t.evt_ST;
		events[100] = t.evt_ST_MISS;
		events[105] = t.evt_TLB;
		events[106] = t.evt_TLB_MISS;
		events[108] = t.evt_TLB_FLUSH;
		events[109] = t.evt_EVICT;
	end
	if (ev.mab_EventsTransExe matches tagged Valid .t) begin
		events[112] = t.evt_RENAMED_INST;
		events[113] = t.evt_WILD_JUMP;
		events[114] = t.evt_WILD_EXCEPTION;
	end
	return events;
endfunction