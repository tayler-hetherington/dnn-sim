// FE Release Version: 2.2.12 
//
//       CONFIDENTIAL AND PROPRIETARY SOFTWARE OF ARM PHYSICAL IP, INC.
//      
//       Copyright (c) 1993 - 2015 ARM Physical IP, Inc.  All Rights Reserved.
//      
//       Use of this Software is subject to the terms and conditions of the
//       applicable license agreement with ARM Physical IP, Inc.
//       In addition, this Software is protected by patents, copyright law 
//       and international treaties.
//      
//       The copyright notice(s) in this Software does not indicate actual or
//       intended publication of this Software.
//
//      Verilog model for Synchronous Single-Port Register File
//
//      Instance Name:              nb_64x128b
//      Words:                      64
//      Bits:                       128
//      Mux:                        1
//      Drive:                      4
//      Write Mask:                 Off
//      Extra Margin Adjustment:    On
//      Accelerated Retention Test: Off
//      Redundant Rows:             0
//      Redundant Columns:          0
//      Test Muxes                  Off
//
//      Creation Date:  Wed Nov 18 11:46:16 2015
//      Version: 	2009Q1V1
//
//      Modeling Assumptions: This model supports full gate level simulation
//          including proper x-handling and timing check behavior.  Unit
//          delay timing is included in the model. Back-annotation of SDF
//          (v2.1) is supported.  SDF can be created utilyzing the delay
//          calculation views provided with this generator and supported
//          delay calculators.  All buses are modeled [MSB:LSB].  All 
//          ports are padded with Verilog primitives.
//
//      Modeling Limitations: None.
//
//      Known Bugs: None.
//
//      Known Work Arounds: N/A
//
`ifdef ARM_UD_MODEL

`timescale 1 ns/1 ps

`ifdef ARM_UD_DP
`else
`define ARM_UD_DP #0.001
`endif
`ifdef ARM_UD_CP
`else
`define ARM_UD_CP
`endif
`ifdef ARM_UD_SEQ
`else
`define ARM_UD_SEQ #0.01
`endif

`celldefine
`ifdef POWER_PINS
module nb_64x128b (VDDCE, VDDPE, VSSE, Q, CLK, CEN, WEN, A, D, EMA, RETN);
`else
module nb_64x128b (Q, CLK, CEN, WEN, A, D, EMA, RETN);
`endif

  parameter BITS = 128;
  parameter WORDS = 64;
  parameter MUX = 1;
  parameter MEM_WIDTH = 128;
  parameter MEM_HEIGHT = 64;
  parameter WP_SIZE = 128 ;
  parameter UPM_WIDTH = 3;

  output [127:0] Q;
  input  CLK;
  input  CEN;
  input  WEN;
  input [5:0] A;
  input [127:0] D;
  input [2:0] EMA;
  input  RETN;
`ifdef POWER_PINS
  inout VDDCE;
  inout VDDPE;
  inout VSSE;
`endif

  integer row_address;
  integer mux_address;
  reg [127:0] mem [0:63];
  reg [127:0] row;
  reg LAST_CLK;
  reg [127:0] data_out;
  reg [127:0] row_mask;
  reg [127:0] new_data;
  reg [127:0] Q_int;
  reg [127:0] writeEnable;
  reg clk0_int;
  reg CREN_legal;
  initial CREN_legal = 1'b1;

  wire [127:0] Q_;
 wire  CLK_;
  wire  CEN_;
  reg  CEN_int;
  wire  WEN_;
  reg  WEN_int;
  wire [5:0] A_;
  reg [5:0] A_int;
  wire [127:0] D_;
  reg [127:0] D_int;
  wire [2:0] EMA_;
  reg [2:0] EMA_int;
  wire  RETN_;
  reg  RETN_int;

  assign Q[0] = Q_[0]; 
  assign Q[1] = Q_[1]; 
  assign Q[2] = Q_[2]; 
  assign Q[3] = Q_[3]; 
  assign Q[4] = Q_[4]; 
  assign Q[5] = Q_[5]; 
  assign Q[6] = Q_[6]; 
  assign Q[7] = Q_[7]; 
  assign Q[8] = Q_[8]; 
  assign Q[9] = Q_[9]; 
  assign Q[10] = Q_[10]; 
  assign Q[11] = Q_[11]; 
  assign Q[12] = Q_[12]; 
  assign Q[13] = Q_[13]; 
  assign Q[14] = Q_[14]; 
  assign Q[15] = Q_[15]; 
  assign Q[16] = Q_[16]; 
  assign Q[17] = Q_[17]; 
  assign Q[18] = Q_[18]; 
  assign Q[19] = Q_[19]; 
  assign Q[20] = Q_[20]; 
  assign Q[21] = Q_[21]; 
  assign Q[22] = Q_[22]; 
  assign Q[23] = Q_[23]; 
  assign Q[24] = Q_[24]; 
  assign Q[25] = Q_[25]; 
  assign Q[26] = Q_[26]; 
  assign Q[27] = Q_[27]; 
  assign Q[28] = Q_[28]; 
  assign Q[29] = Q_[29]; 
  assign Q[30] = Q_[30]; 
  assign Q[31] = Q_[31]; 
  assign Q[32] = Q_[32]; 
  assign Q[33] = Q_[33]; 
  assign Q[34] = Q_[34]; 
  assign Q[35] = Q_[35]; 
  assign Q[36] = Q_[36]; 
  assign Q[37] = Q_[37]; 
  assign Q[38] = Q_[38]; 
  assign Q[39] = Q_[39]; 
  assign Q[40] = Q_[40]; 
  assign Q[41] = Q_[41]; 
  assign Q[42] = Q_[42]; 
  assign Q[43] = Q_[43]; 
  assign Q[44] = Q_[44]; 
  assign Q[45] = Q_[45]; 
  assign Q[46] = Q_[46]; 
  assign Q[47] = Q_[47]; 
  assign Q[48] = Q_[48]; 
  assign Q[49] = Q_[49]; 
  assign Q[50] = Q_[50]; 
  assign Q[51] = Q_[51]; 
  assign Q[52] = Q_[52]; 
  assign Q[53] = Q_[53]; 
  assign Q[54] = Q_[54]; 
  assign Q[55] = Q_[55]; 
  assign Q[56] = Q_[56]; 
  assign Q[57] = Q_[57]; 
  assign Q[58] = Q_[58]; 
  assign Q[59] = Q_[59]; 
  assign Q[60] = Q_[60]; 
  assign Q[61] = Q_[61]; 
  assign Q[62] = Q_[62]; 
  assign Q[63] = Q_[63]; 
  assign Q[64] = Q_[64]; 
  assign Q[65] = Q_[65]; 
  assign Q[66] = Q_[66]; 
  assign Q[67] = Q_[67]; 
  assign Q[68] = Q_[68]; 
  assign Q[69] = Q_[69]; 
  assign Q[70] = Q_[70]; 
  assign Q[71] = Q_[71]; 
  assign Q[72] = Q_[72]; 
  assign Q[73] = Q_[73]; 
  assign Q[74] = Q_[74]; 
  assign Q[75] = Q_[75]; 
  assign Q[76] = Q_[76]; 
  assign Q[77] = Q_[77]; 
  assign Q[78] = Q_[78]; 
  assign Q[79] = Q_[79]; 
  assign Q[80] = Q_[80]; 
  assign Q[81] = Q_[81]; 
  assign Q[82] = Q_[82]; 
  assign Q[83] = Q_[83]; 
  assign Q[84] = Q_[84]; 
  assign Q[85] = Q_[85]; 
  assign Q[86] = Q_[86]; 
  assign Q[87] = Q_[87]; 
  assign Q[88] = Q_[88]; 
  assign Q[89] = Q_[89]; 
  assign Q[90] = Q_[90]; 
  assign Q[91] = Q_[91]; 
  assign Q[92] = Q_[92]; 
  assign Q[93] = Q_[93]; 
  assign Q[94] = Q_[94]; 
  assign Q[95] = Q_[95]; 
  assign Q[96] = Q_[96]; 
  assign Q[97] = Q_[97]; 
  assign Q[98] = Q_[98]; 
  assign Q[99] = Q_[99]; 
  assign Q[100] = Q_[100]; 
  assign Q[101] = Q_[101]; 
  assign Q[102] = Q_[102]; 
  assign Q[103] = Q_[103]; 
  assign Q[104] = Q_[104]; 
  assign Q[105] = Q_[105]; 
  assign Q[106] = Q_[106]; 
  assign Q[107] = Q_[107]; 
  assign Q[108] = Q_[108]; 
  assign Q[109] = Q_[109]; 
  assign Q[110] = Q_[110]; 
  assign Q[111] = Q_[111]; 
  assign Q[112] = Q_[112]; 
  assign Q[113] = Q_[113]; 
  assign Q[114] = Q_[114]; 
  assign Q[115] = Q_[115]; 
  assign Q[116] = Q_[116]; 
  assign Q[117] = Q_[117]; 
  assign Q[118] = Q_[118]; 
  assign Q[119] = Q_[119]; 
  assign Q[120] = Q_[120]; 
  assign Q[121] = Q_[121]; 
  assign Q[122] = Q_[122]; 
  assign Q[123] = Q_[123]; 
  assign Q[124] = Q_[124]; 
  assign Q[125] = Q_[125]; 
  assign Q[126] = Q_[126]; 
  assign Q[127] = Q_[127]; 
  assign CLK_ = CLK;
  assign CEN_ = CEN;
  assign WEN_ = WEN;
  assign A_[0] = A[0];
  assign A_[1] = A[1];
  assign A_[2] = A[2];
  assign A_[3] = A[3];
  assign A_[4] = A[4];
  assign A_[5] = A[5];
  assign D_[0] = D[0];
  assign D_[1] = D[1];
  assign D_[2] = D[2];
  assign D_[3] = D[3];
  assign D_[4] = D[4];
  assign D_[5] = D[5];
  assign D_[6] = D[6];
  assign D_[7] = D[7];
  assign D_[8] = D[8];
  assign D_[9] = D[9];
  assign D_[10] = D[10];
  assign D_[11] = D[11];
  assign D_[12] = D[12];
  assign D_[13] = D[13];
  assign D_[14] = D[14];
  assign D_[15] = D[15];
  assign D_[16] = D[16];
  assign D_[17] = D[17];
  assign D_[18] = D[18];
  assign D_[19] = D[19];
  assign D_[20] = D[20];
  assign D_[21] = D[21];
  assign D_[22] = D[22];
  assign D_[23] = D[23];
  assign D_[24] = D[24];
  assign D_[25] = D[25];
  assign D_[26] = D[26];
  assign D_[27] = D[27];
  assign D_[28] = D[28];
  assign D_[29] = D[29];
  assign D_[30] = D[30];
  assign D_[31] = D[31];
  assign D_[32] = D[32];
  assign D_[33] = D[33];
  assign D_[34] = D[34];
  assign D_[35] = D[35];
  assign D_[36] = D[36];
  assign D_[37] = D[37];
  assign D_[38] = D[38];
  assign D_[39] = D[39];
  assign D_[40] = D[40];
  assign D_[41] = D[41];
  assign D_[42] = D[42];
  assign D_[43] = D[43];
  assign D_[44] = D[44];
  assign D_[45] = D[45];
  assign D_[46] = D[46];
  assign D_[47] = D[47];
  assign D_[48] = D[48];
  assign D_[49] = D[49];
  assign D_[50] = D[50];
  assign D_[51] = D[51];
  assign D_[52] = D[52];
  assign D_[53] = D[53];
  assign D_[54] = D[54];
  assign D_[55] = D[55];
  assign D_[56] = D[56];
  assign D_[57] = D[57];
  assign D_[58] = D[58];
  assign D_[59] = D[59];
  assign D_[60] = D[60];
  assign D_[61] = D[61];
  assign D_[62] = D[62];
  assign D_[63] = D[63];
  assign D_[64] = D[64];
  assign D_[65] = D[65];
  assign D_[66] = D[66];
  assign D_[67] = D[67];
  assign D_[68] = D[68];
  assign D_[69] = D[69];
  assign D_[70] = D[70];
  assign D_[71] = D[71];
  assign D_[72] = D[72];
  assign D_[73] = D[73];
  assign D_[74] = D[74];
  assign D_[75] = D[75];
  assign D_[76] = D[76];
  assign D_[77] = D[77];
  assign D_[78] = D[78];
  assign D_[79] = D[79];
  assign D_[80] = D[80];
  assign D_[81] = D[81];
  assign D_[82] = D[82];
  assign D_[83] = D[83];
  assign D_[84] = D[84];
  assign D_[85] = D[85];
  assign D_[86] = D[86];
  assign D_[87] = D[87];
  assign D_[88] = D[88];
  assign D_[89] = D[89];
  assign D_[90] = D[90];
  assign D_[91] = D[91];
  assign D_[92] = D[92];
  assign D_[93] = D[93];
  assign D_[94] = D[94];
  assign D_[95] = D[95];
  assign D_[96] = D[96];
  assign D_[97] = D[97];
  assign D_[98] = D[98];
  assign D_[99] = D[99];
  assign D_[100] = D[100];
  assign D_[101] = D[101];
  assign D_[102] = D[102];
  assign D_[103] = D[103];
  assign D_[104] = D[104];
  assign D_[105] = D[105];
  assign D_[106] = D[106];
  assign D_[107] = D[107];
  assign D_[108] = D[108];
  assign D_[109] = D[109];
  assign D_[110] = D[110];
  assign D_[111] = D[111];
  assign D_[112] = D[112];
  assign D_[113] = D[113];
  assign D_[114] = D[114];
  assign D_[115] = D[115];
  assign D_[116] = D[116];
  assign D_[117] = D[117];
  assign D_[118] = D[118];
  assign D_[119] = D[119];
  assign D_[120] = D[120];
  assign D_[121] = D[121];
  assign D_[122] = D[122];
  assign D_[123] = D[123];
  assign D_[124] = D[124];
  assign D_[125] = D[125];
  assign D_[126] = D[126];
  assign D_[127] = D[127];
  assign EMA_[0] = EMA[0];
  assign EMA_[1] = EMA[1];
  assign EMA_[2] = EMA[2];
  assign RETN_ = RETN;

  assign `ARM_UD_SEQ Q_ = RETN_ ? (Q_int) : {128{1'b0}};

`ifdef INITIALIZE_MEMORY
  integer i;
  initial
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'b0}};
`endif

  task failedWrite;
  input port;
  integer i;
  begin
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'bx}};
  end
  endtask

  function isBitX;
    input bitIn;
    begin
      isBitX = ( bitIn===1'bx || bitIn===1'bz ) ? 1'b1 : 1'b0;
    end
  endfunction


  task readWrite;
  begin
    if (RETN_int === 1'bx) begin
      failedWrite(0);
      Q_int = {128{1'bx}};
    end else if (RETN_int === 1'b0 && CEN_int === 1'b0) begin
      failedWrite(0);
      Q_int = {128{1'bx}};
    end else if (RETN_int === 1'b0) begin
      // no cycle in retention mode
    end else if (^{CEN_int, EMA_int} === 1'bx) begin
      failedWrite(0);
      Q_int = {128{1'bx}};
    end else if ((A_int >= WORDS) && (CEN_int === 1'b0)) begin
      writeEnable = ~{128{WEN_int}};
      Q_int = ((writeEnable & D_int) | (~writeEnable & {128{1'bx}}));
    end else if (CEN_int === 1'b0 && (^A_int) === 1'bx) begin
      if (WEN_int !== 1'b1) failedWrite(0);
      Q_int = {128{1'bx}};
    end else if (CEN_int === 1'b0) begin
      mux_address = 0;
      row_address = A_int;
      if (row_address >= 64)
        row = {128{1'bx}};
      else
        row = mem[row_address];
      writeEnable = ~{128{WEN_int}};
      row_mask =  writeEnable;
      new_data =  D_int;
      row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
      mem[row_address] = row;
      data_out = row;
      Q_int = data_out;
    end
  end
  endtask

  always @ RETN_ begin
    if (RETN_ == 1'b0) begin
      Q_int = {128{1'b0}};
      CEN_int = 1'b0;
      WEN_int = 1'b0;
      A_int = {6{1'b0}};
      D_int = {128{1'b0}};
      EMA_int = {3{1'b0}};
      RETN_int = 1'b0;
    end else begin
      Q_int = {128{1'bx}};
      CEN_int = 1'bx;
      WEN_int = 1'bx;
      A_int = {6{1'bx}};
      D_int = {128{1'bx}};
      EMA_int = {3{1'bx}};
      RETN_int = 1'bx;
    end
    RETN_int = RETN_;
  end

  always @ CLK_ begin
`ifdef POWER_PINS
    if (VDDCE === 1'bx || VDDCE === 1'bz)
      $display("ERROR: Illegal value for VDDCE %b", VDDCE);
    if (VDDPE === 1'bx || VDDPE === 1'bz)
      $display("ERROR: Illegal value for VDDPE %b", VDDPE);
    if (VSSE === 1'bx || VSSE === 1'bz)
      $display("ERROR: Illegal value for VSSE %b", VSSE);
`endif
    if (CLK_ === 1'bx && (CEN_ !== 1'b1)) begin
      failedWrite(0);
      Q_int = {128{1'bx}};
    end else if (CLK_ === 1'b1 && LAST_CLK === 1'b0) begin
      CEN_int = CEN_;
      WEN_int = WEN_;
      A_int = A_;
      D_int = D_;
      EMA_int = EMA_;
      RETN_int = RETN_;
      clk0_int = 1'b0;
      readWrite;
    end
    LAST_CLK = CLK_;
  end


endmodule
`endcelldefine
`else
`timescale 1 ns/1 ps
`celldefine
`ifdef POWER_PINS
module nb_64x128b (VDDCE, VDDPE, VSSE, Q, CLK, CEN, WEN, A, D, EMA, RETN);
`else
module nb_64x128b (Q, CLK, CEN, WEN, A, D, EMA, RETN);
`endif

  parameter BITS = 128;
  parameter WORDS = 64;
  parameter MUX = 1;
  parameter MEM_WIDTH = 128;
  parameter MEM_HEIGHT = 64;
  parameter WP_SIZE = 128 ;
  parameter UPM_WIDTH = 3;

  output [127:0] Q;
  input  CLK;
  input  CEN;
  input  WEN;
  input [5:0] A;
  input [127:0] D;
  input [2:0] EMA;
  input  RETN;
`ifdef POWER_PINS
  inout VDDCE;
  inout VDDPE;
  inout VSSE;
`endif

  integer row_address;
  integer mux_address;
  reg [127:0] mem [0:63];
  reg [127:0] row;
  reg LAST_CLK;
  reg [127:0] data_out;
  reg [127:0] row_mask;
  reg [127:0] new_data;
  reg [127:0] Q_int;
  reg [127:0] writeEnable;

  reg NOT_A0, NOT_A1, NOT_A2, NOT_A3, NOT_A4, NOT_A5, NOT_CEN, NOT_CLK_MINH, NOT_CLK_MINL;
  reg NOT_CLK_PER, NOT_D0, NOT_D1, NOT_D10, NOT_D100, NOT_D101, NOT_D102, NOT_D103;
  reg NOT_D104, NOT_D105, NOT_D106, NOT_D107, NOT_D108, NOT_D109, NOT_D11, NOT_D110;
  reg NOT_D111, NOT_D112, NOT_D113, NOT_D114, NOT_D115, NOT_D116, NOT_D117, NOT_D118;
  reg NOT_D119, NOT_D12, NOT_D120, NOT_D121, NOT_D122, NOT_D123, NOT_D124, NOT_D125;
  reg NOT_D126, NOT_D127, NOT_D13, NOT_D14, NOT_D15, NOT_D16, NOT_D17, NOT_D18, NOT_D19;
  reg NOT_D2, NOT_D20, NOT_D21, NOT_D22, NOT_D23, NOT_D24, NOT_D25, NOT_D26, NOT_D27;
  reg NOT_D28, NOT_D29, NOT_D3, NOT_D30, NOT_D31, NOT_D32, NOT_D33, NOT_D34, NOT_D35;
  reg NOT_D36, NOT_D37, NOT_D38, NOT_D39, NOT_D4, NOT_D40, NOT_D41, NOT_D42, NOT_D43;
  reg NOT_D44, NOT_D45, NOT_D46, NOT_D47, NOT_D48, NOT_D49, NOT_D5, NOT_D50, NOT_D51;
  reg NOT_D52, NOT_D53, NOT_D54, NOT_D55, NOT_D56, NOT_D57, NOT_D58, NOT_D59, NOT_D6;
  reg NOT_D60, NOT_D61, NOT_D62, NOT_D63, NOT_D64, NOT_D65, NOT_D66, NOT_D67, NOT_D68;
  reg NOT_D69, NOT_D7, NOT_D70, NOT_D71, NOT_D72, NOT_D73, NOT_D74, NOT_D75, NOT_D76;
  reg NOT_D77, NOT_D78, NOT_D79, NOT_D8, NOT_D80, NOT_D81, NOT_D82, NOT_D83, NOT_D84;
  reg NOT_D85, NOT_D86, NOT_D87, NOT_D88, NOT_D89, NOT_D9, NOT_D90, NOT_D91, NOT_D92;
  reg NOT_D93, NOT_D94, NOT_D95, NOT_D96, NOT_D97, NOT_D98, NOT_D99, NOT_EMA0, NOT_EMA1;
  reg NOT_EMA2, NOT_RETN, NOT_WEN;
  reg clk0_int;
  reg CREN_legal;
  initial CREN_legal = 1'b1;

  wire [127:0] Q_;
 wire  CLK_;
  wire  CEN_;
  reg  CEN_int;
  wire  WEN_;
  reg  WEN_int;
  wire [5:0] A_;
  reg [5:0] A_int;
  wire [127:0] D_;
  reg [127:0] D_int;
  wire [2:0] EMA_;
  reg [2:0] EMA_int;
  wire  RETN_;
  reg  RETN_int;

  buf B0(Q[0], Q_[0]);
  buf B1(Q[1], Q_[1]);
  buf B2(Q[2], Q_[2]);
  buf B3(Q[3], Q_[3]);
  buf B4(Q[4], Q_[4]);
  buf B5(Q[5], Q_[5]);
  buf B6(Q[6], Q_[6]);
  buf B7(Q[7], Q_[7]);
  buf B8(Q[8], Q_[8]);
  buf B9(Q[9], Q_[9]);
  buf B10(Q[10], Q_[10]);
  buf B11(Q[11], Q_[11]);
  buf B12(Q[12], Q_[12]);
  buf B13(Q[13], Q_[13]);
  buf B14(Q[14], Q_[14]);
  buf B15(Q[15], Q_[15]);
  buf B16(Q[16], Q_[16]);
  buf B17(Q[17], Q_[17]);
  buf B18(Q[18], Q_[18]);
  buf B19(Q[19], Q_[19]);
  buf B20(Q[20], Q_[20]);
  buf B21(Q[21], Q_[21]);
  buf B22(Q[22], Q_[22]);
  buf B23(Q[23], Q_[23]);
  buf B24(Q[24], Q_[24]);
  buf B25(Q[25], Q_[25]);
  buf B26(Q[26], Q_[26]);
  buf B27(Q[27], Q_[27]);
  buf B28(Q[28], Q_[28]);
  buf B29(Q[29], Q_[29]);
  buf B30(Q[30], Q_[30]);
  buf B31(Q[31], Q_[31]);
  buf B32(Q[32], Q_[32]);
  buf B33(Q[33], Q_[33]);
  buf B34(Q[34], Q_[34]);
  buf B35(Q[35], Q_[35]);
  buf B36(Q[36], Q_[36]);
  buf B37(Q[37], Q_[37]);
  buf B38(Q[38], Q_[38]);
  buf B39(Q[39], Q_[39]);
  buf B40(Q[40], Q_[40]);
  buf B41(Q[41], Q_[41]);
  buf B42(Q[42], Q_[42]);
  buf B43(Q[43], Q_[43]);
  buf B44(Q[44], Q_[44]);
  buf B45(Q[45], Q_[45]);
  buf B46(Q[46], Q_[46]);
  buf B47(Q[47], Q_[47]);
  buf B48(Q[48], Q_[48]);
  buf B49(Q[49], Q_[49]);
  buf B50(Q[50], Q_[50]);
  buf B51(Q[51], Q_[51]);
  buf B52(Q[52], Q_[52]);
  buf B53(Q[53], Q_[53]);
  buf B54(Q[54], Q_[54]);
  buf B55(Q[55], Q_[55]);
  buf B56(Q[56], Q_[56]);
  buf B57(Q[57], Q_[57]);
  buf B58(Q[58], Q_[58]);
  buf B59(Q[59], Q_[59]);
  buf B60(Q[60], Q_[60]);
  buf B61(Q[61], Q_[61]);
  buf B62(Q[62], Q_[62]);
  buf B63(Q[63], Q_[63]);
  buf B64(Q[64], Q_[64]);
  buf B65(Q[65], Q_[65]);
  buf B66(Q[66], Q_[66]);
  buf B67(Q[67], Q_[67]);
  buf B68(Q[68], Q_[68]);
  buf B69(Q[69], Q_[69]);
  buf B70(Q[70], Q_[70]);
  buf B71(Q[71], Q_[71]);
  buf B72(Q[72], Q_[72]);
  buf B73(Q[73], Q_[73]);
  buf B74(Q[74], Q_[74]);
  buf B75(Q[75], Q_[75]);
  buf B76(Q[76], Q_[76]);
  buf B77(Q[77], Q_[77]);
  buf B78(Q[78], Q_[78]);
  buf B79(Q[79], Q_[79]);
  buf B80(Q[80], Q_[80]);
  buf B81(Q[81], Q_[81]);
  buf B82(Q[82], Q_[82]);
  buf B83(Q[83], Q_[83]);
  buf B84(Q[84], Q_[84]);
  buf B85(Q[85], Q_[85]);
  buf B86(Q[86], Q_[86]);
  buf B87(Q[87], Q_[87]);
  buf B88(Q[88], Q_[88]);
  buf B89(Q[89], Q_[89]);
  buf B90(Q[90], Q_[90]);
  buf B91(Q[91], Q_[91]);
  buf B92(Q[92], Q_[92]);
  buf B93(Q[93], Q_[93]);
  buf B94(Q[94], Q_[94]);
  buf B95(Q[95], Q_[95]);
  buf B96(Q[96], Q_[96]);
  buf B97(Q[97], Q_[97]);
  buf B98(Q[98], Q_[98]);
  buf B99(Q[99], Q_[99]);
  buf B100(Q[100], Q_[100]);
  buf B101(Q[101], Q_[101]);
  buf B102(Q[102], Q_[102]);
  buf B103(Q[103], Q_[103]);
  buf B104(Q[104], Q_[104]);
  buf B105(Q[105], Q_[105]);
  buf B106(Q[106], Q_[106]);
  buf B107(Q[107], Q_[107]);
  buf B108(Q[108], Q_[108]);
  buf B109(Q[109], Q_[109]);
  buf B110(Q[110], Q_[110]);
  buf B111(Q[111], Q_[111]);
  buf B112(Q[112], Q_[112]);
  buf B113(Q[113], Q_[113]);
  buf B114(Q[114], Q_[114]);
  buf B115(Q[115], Q_[115]);
  buf B116(Q[116], Q_[116]);
  buf B117(Q[117], Q_[117]);
  buf B118(Q[118], Q_[118]);
  buf B119(Q[119], Q_[119]);
  buf B120(Q[120], Q_[120]);
  buf B121(Q[121], Q_[121]);
  buf B122(Q[122], Q_[122]);
  buf B123(Q[123], Q_[123]);
  buf B124(Q[124], Q_[124]);
  buf B125(Q[125], Q_[125]);
  buf B126(Q[126], Q_[126]);
  buf B127(Q[127], Q_[127]);
  buf B128(CLK_, CLK);
  buf B129(CEN_, CEN);
  buf B130(WEN_, WEN);
  buf B131(A_[0], A[0]);
  buf B132(A_[1], A[1]);
  buf B133(A_[2], A[2]);
  buf B134(A_[3], A[3]);
  buf B135(A_[4], A[4]);
  buf B136(A_[5], A[5]);
  buf B137(D_[0], D[0]);
  buf B138(D_[1], D[1]);
  buf B139(D_[2], D[2]);
  buf B140(D_[3], D[3]);
  buf B141(D_[4], D[4]);
  buf B142(D_[5], D[5]);
  buf B143(D_[6], D[6]);
  buf B144(D_[7], D[7]);
  buf B145(D_[8], D[8]);
  buf B146(D_[9], D[9]);
  buf B147(D_[10], D[10]);
  buf B148(D_[11], D[11]);
  buf B149(D_[12], D[12]);
  buf B150(D_[13], D[13]);
  buf B151(D_[14], D[14]);
  buf B152(D_[15], D[15]);
  buf B153(D_[16], D[16]);
  buf B154(D_[17], D[17]);
  buf B155(D_[18], D[18]);
  buf B156(D_[19], D[19]);
  buf B157(D_[20], D[20]);
  buf B158(D_[21], D[21]);
  buf B159(D_[22], D[22]);
  buf B160(D_[23], D[23]);
  buf B161(D_[24], D[24]);
  buf B162(D_[25], D[25]);
  buf B163(D_[26], D[26]);
  buf B164(D_[27], D[27]);
  buf B165(D_[28], D[28]);
  buf B166(D_[29], D[29]);
  buf B167(D_[30], D[30]);
  buf B168(D_[31], D[31]);
  buf B169(D_[32], D[32]);
  buf B170(D_[33], D[33]);
  buf B171(D_[34], D[34]);
  buf B172(D_[35], D[35]);
  buf B173(D_[36], D[36]);
  buf B174(D_[37], D[37]);
  buf B175(D_[38], D[38]);
  buf B176(D_[39], D[39]);
  buf B177(D_[40], D[40]);
  buf B178(D_[41], D[41]);
  buf B179(D_[42], D[42]);
  buf B180(D_[43], D[43]);
  buf B181(D_[44], D[44]);
  buf B182(D_[45], D[45]);
  buf B183(D_[46], D[46]);
  buf B184(D_[47], D[47]);
  buf B185(D_[48], D[48]);
  buf B186(D_[49], D[49]);
  buf B187(D_[50], D[50]);
  buf B188(D_[51], D[51]);
  buf B189(D_[52], D[52]);
  buf B190(D_[53], D[53]);
  buf B191(D_[54], D[54]);
  buf B192(D_[55], D[55]);
  buf B193(D_[56], D[56]);
  buf B194(D_[57], D[57]);
  buf B195(D_[58], D[58]);
  buf B196(D_[59], D[59]);
  buf B197(D_[60], D[60]);
  buf B198(D_[61], D[61]);
  buf B199(D_[62], D[62]);
  buf B200(D_[63], D[63]);
  buf B201(D_[64], D[64]);
  buf B202(D_[65], D[65]);
  buf B203(D_[66], D[66]);
  buf B204(D_[67], D[67]);
  buf B205(D_[68], D[68]);
  buf B206(D_[69], D[69]);
  buf B207(D_[70], D[70]);
  buf B208(D_[71], D[71]);
  buf B209(D_[72], D[72]);
  buf B210(D_[73], D[73]);
  buf B211(D_[74], D[74]);
  buf B212(D_[75], D[75]);
  buf B213(D_[76], D[76]);
  buf B214(D_[77], D[77]);
  buf B215(D_[78], D[78]);
  buf B216(D_[79], D[79]);
  buf B217(D_[80], D[80]);
  buf B218(D_[81], D[81]);
  buf B219(D_[82], D[82]);
  buf B220(D_[83], D[83]);
  buf B221(D_[84], D[84]);
  buf B222(D_[85], D[85]);
  buf B223(D_[86], D[86]);
  buf B224(D_[87], D[87]);
  buf B225(D_[88], D[88]);
  buf B226(D_[89], D[89]);
  buf B227(D_[90], D[90]);
  buf B228(D_[91], D[91]);
  buf B229(D_[92], D[92]);
  buf B230(D_[93], D[93]);
  buf B231(D_[94], D[94]);
  buf B232(D_[95], D[95]);
  buf B233(D_[96], D[96]);
  buf B234(D_[97], D[97]);
  buf B235(D_[98], D[98]);
  buf B236(D_[99], D[99]);
  buf B237(D_[100], D[100]);
  buf B238(D_[101], D[101]);
  buf B239(D_[102], D[102]);
  buf B240(D_[103], D[103]);
  buf B241(D_[104], D[104]);
  buf B242(D_[105], D[105]);
  buf B243(D_[106], D[106]);
  buf B244(D_[107], D[107]);
  buf B245(D_[108], D[108]);
  buf B246(D_[109], D[109]);
  buf B247(D_[110], D[110]);
  buf B248(D_[111], D[111]);
  buf B249(D_[112], D[112]);
  buf B250(D_[113], D[113]);
  buf B251(D_[114], D[114]);
  buf B252(D_[115], D[115]);
  buf B253(D_[116], D[116]);
  buf B254(D_[117], D[117]);
  buf B255(D_[118], D[118]);
  buf B256(D_[119], D[119]);
  buf B257(D_[120], D[120]);
  buf B258(D_[121], D[121]);
  buf B259(D_[122], D[122]);
  buf B260(D_[123], D[123]);
  buf B261(D_[124], D[124]);
  buf B262(D_[125], D[125]);
  buf B263(D_[126], D[126]);
  buf B264(D_[127], D[127]);
  buf B265(EMA_[0], EMA[0]);
  buf B266(EMA_[1], EMA[1]);
  buf B267(EMA_[2], EMA[2]);
  buf B268(RETN_, RETN);

  assign Q_ = RETN_ ? (Q_int) : {128{1'b0}};

`ifdef INITIALIZE_MEMORY
  integer i;
  initial
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'b0}};
`endif

  task failedWrite;
  input port;
  integer i;
  begin
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'bx}};
  end
  endtask

  function isBitX;
    input bitIn;
    begin
      isBitX = ( bitIn===1'bx || bitIn===1'bz ) ? 1'b1 : 1'b0;
    end
  endfunction


  task readWrite;
  begin
    if (RETN_int === 1'bx) begin
      failedWrite(0);
      Q_int = {128{1'bx}};
    end else if (RETN_int === 1'b0 && CEN_int === 1'b0) begin
      failedWrite(0);
      Q_int = {128{1'bx}};
    end else if (RETN_int === 1'b0) begin
      // no cycle in retention mode
    end else if (^{CEN_int, EMA_int} === 1'bx) begin
      failedWrite(0);
      Q_int = {128{1'bx}};
    end else if ((A_int >= WORDS) && (CEN_int === 1'b0)) begin
      writeEnable = ~{128{WEN_int}};
      Q_int = ((writeEnable & D_int) | (~writeEnable & {128{1'bx}}));
    end else if (CEN_int === 1'b0 && (^A_int) === 1'bx) begin
      if (WEN_int !== 1'b1) failedWrite(0);
      Q_int = {128{1'bx}};
    end else if (CEN_int === 1'b0) begin
      mux_address = 0;
      row_address = A_int;
      if (row_address >= 64)
        row = {128{1'bx}};
      else
        row = mem[row_address];
      writeEnable = ~{128{WEN_int}};
      row_mask =  writeEnable;
      new_data =  D_int;
      row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
      mem[row_address] = row;
      data_out = row;
      Q_int = data_out;
    end
  end
  endtask

  always @ RETN_ begin
    if (RETN_ == 1'b0) begin
      Q_int = {128{1'b0}};
      CEN_int = 1'b0;
      WEN_int = 1'b0;
      A_int = {6{1'b0}};
      D_int = {128{1'b0}};
      EMA_int = {3{1'b0}};
      RETN_int = 1'b0;
    end else begin
      Q_int = {128{1'bx}};
      CEN_int = 1'bx;
      WEN_int = 1'bx;
      A_int = {6{1'bx}};
      D_int = {128{1'bx}};
      EMA_int = {3{1'bx}};
      RETN_int = 1'bx;
    end
    RETN_int = RETN_;
  end

  always @ CLK_ begin
`ifdef POWER_PINS
    if (VDDCE === 1'bx || VDDCE === 1'bz)
      $display("ERROR: Illegal value for VDDCE %b", VDDCE);
    if (VDDPE === 1'bx || VDDPE === 1'bz)
      $display("ERROR: Illegal value for VDDPE %b", VDDPE);
    if (VSSE === 1'bx || VSSE === 1'bz)
      $display("ERROR: Illegal value for VSSE %b", VSSE);
`endif
    if (CLK_ === 1'bx && (CEN_ !== 1'b1)) begin
      failedWrite(0);
      Q_int = {128{1'bx}};
    end else if (CLK_ === 1'b1 && LAST_CLK === 1'b0) begin
      CEN_int = CEN_;
      WEN_int = WEN_;
      A_int = A_;
      D_int = D_;
      EMA_int = EMA_;
      RETN_int = RETN_;
      clk0_int = 1'b0;
      readWrite;
    end
    LAST_CLK = CLK_;
  end

  reg globalNotifier0;
  initial globalNotifier0 = 1'b0;

  always @ globalNotifier0 begin
    if ($realtime == 0) begin
    end else if (CEN_int === 1'bx || EMA_int[0] === 1'bx || EMA_int[1] === 1'bx || 
      EMA_int[2] === 1'bx || RETN_int === 1'bx || clk0_int === 1'bx) begin
      Q_int = {128{1'bx}};
      failedWrite(0);
    end else begin
      readWrite;
   end
    globalNotifier0 = 1'b0;
  end

  always @ NOT_A0 begin
    A_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A1 begin
    A_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A2 begin
    A_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A3 begin
    A_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A4 begin
    A_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A5 begin
    A_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CEN begin
    CEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D0 begin
    D_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D100 begin
    D_int[100] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D101 begin
    D_int[101] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D102 begin
    D_int[102] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D103 begin
    D_int[103] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D104 begin
    D_int[104] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D105 begin
    D_int[105] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D106 begin
    D_int[106] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D107 begin
    D_int[107] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D108 begin
    D_int[108] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D109 begin
    D_int[109] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D10 begin
    D_int[10] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D110 begin
    D_int[110] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D111 begin
    D_int[111] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D112 begin
    D_int[112] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D113 begin
    D_int[113] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D114 begin
    D_int[114] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D115 begin
    D_int[115] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D116 begin
    D_int[116] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D117 begin
    D_int[117] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D118 begin
    D_int[118] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D119 begin
    D_int[119] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D11 begin
    D_int[11] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D120 begin
    D_int[120] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D121 begin
    D_int[121] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D122 begin
    D_int[122] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D123 begin
    D_int[123] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D124 begin
    D_int[124] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D125 begin
    D_int[125] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D126 begin
    D_int[126] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D127 begin
    D_int[127] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D12 begin
    D_int[12] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D13 begin
    D_int[13] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D14 begin
    D_int[14] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D15 begin
    D_int[15] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D16 begin
    D_int[16] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D17 begin
    D_int[17] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D18 begin
    D_int[18] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D19 begin
    D_int[19] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D1 begin
    D_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D20 begin
    D_int[20] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D21 begin
    D_int[21] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D22 begin
    D_int[22] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D23 begin
    D_int[23] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D24 begin
    D_int[24] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D25 begin
    D_int[25] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D26 begin
    D_int[26] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D27 begin
    D_int[27] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D28 begin
    D_int[28] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D29 begin
    D_int[29] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D2 begin
    D_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D30 begin
    D_int[30] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D31 begin
    D_int[31] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D32 begin
    D_int[32] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D33 begin
    D_int[33] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D34 begin
    D_int[34] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D35 begin
    D_int[35] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D36 begin
    D_int[36] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D37 begin
    D_int[37] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D38 begin
    D_int[38] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D39 begin
    D_int[39] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D3 begin
    D_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D40 begin
    D_int[40] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D41 begin
    D_int[41] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D42 begin
    D_int[42] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D43 begin
    D_int[43] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D44 begin
    D_int[44] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D45 begin
    D_int[45] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D46 begin
    D_int[46] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D47 begin
    D_int[47] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D48 begin
    D_int[48] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D49 begin
    D_int[49] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D4 begin
    D_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D50 begin
    D_int[50] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D51 begin
    D_int[51] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D52 begin
    D_int[52] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D53 begin
    D_int[53] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D54 begin
    D_int[54] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D55 begin
    D_int[55] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D56 begin
    D_int[56] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D57 begin
    D_int[57] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D58 begin
    D_int[58] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D59 begin
    D_int[59] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D5 begin
    D_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D60 begin
    D_int[60] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D61 begin
    D_int[61] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D62 begin
    D_int[62] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D63 begin
    D_int[63] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D64 begin
    D_int[64] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D65 begin
    D_int[65] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D66 begin
    D_int[66] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D67 begin
    D_int[67] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D68 begin
    D_int[68] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D69 begin
    D_int[69] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D6 begin
    D_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D70 begin
    D_int[70] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D71 begin
    D_int[71] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D72 begin
    D_int[72] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D73 begin
    D_int[73] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D74 begin
    D_int[74] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D75 begin
    D_int[75] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D76 begin
    D_int[76] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D77 begin
    D_int[77] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D78 begin
    D_int[78] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D79 begin
    D_int[79] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D7 begin
    D_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D80 begin
    D_int[80] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D81 begin
    D_int[81] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D82 begin
    D_int[82] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D83 begin
    D_int[83] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D84 begin
    D_int[84] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D85 begin
    D_int[85] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D86 begin
    D_int[86] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D87 begin
    D_int[87] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D88 begin
    D_int[88] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D89 begin
    D_int[89] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D8 begin
    D_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D90 begin
    D_int[90] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D91 begin
    D_int[91] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D92 begin
    D_int[92] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D93 begin
    D_int[93] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D94 begin
    D_int[94] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D95 begin
    D_int[95] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D96 begin
    D_int[96] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D97 begin
    D_int[97] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D98 begin
    D_int[98] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D99 begin
    D_int[99] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D9 begin
    D_int[9] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA0 begin
    EMA_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA1 begin
    EMA_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA2 begin
    EMA_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_RETN begin
    RETN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN begin
    WEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_MINH begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_MINL begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_PER begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end

  wire CEN_flag;
  wire flag;
  wire D_flag;
  wire cyc_flag;
  wire EMA2eq0andEMA1eq0andEMA0eq0;
  wire EMA2eq0andEMA1eq0andEMA0eq1;
  wire EMA2eq0andEMA1eq1andEMA0eq0;
  wire EMA2eq0andEMA1eq1andEMA0eq1;
  wire EMA2eq1andEMA1eq0andEMA0eq0;
  wire EMA2eq1andEMA1eq0andEMA0eq1;
  wire EMA2eq1andEMA1eq1andEMA0eq0;
  wire EMA2eq1andEMA1eq1andEMA0eq1;
  assign CEN_flag = 1'b1;
  assign flag = !CEN_;
  assign D_flag = !(CEN_ || WEN_);
  assign cyc_flag = !CEN_;
  assign EMA2eq0andEMA1eq0andEMA0eq0 = !EMA_[2] && !EMA_[1] && !EMA_[0] && cyc_flag;
  assign EMA2eq0andEMA1eq0andEMA0eq1 = !EMA_[2] && !EMA_[1] && EMA_[0] && cyc_flag;
  assign EMA2eq0andEMA1eq1andEMA0eq0 = !EMA_[2] && EMA_[1] && !EMA_[0] && cyc_flag;
  assign EMA2eq0andEMA1eq1andEMA0eq1 = !EMA_[2] && EMA_[1] && EMA_[0] && cyc_flag;
  assign EMA2eq1andEMA1eq0andEMA0eq0 = EMA_[2] && !EMA_[1] && !EMA_[0] && cyc_flag;
  assign EMA2eq1andEMA1eq0andEMA0eq1 = EMA_[2] && !EMA_[1] && EMA_[0] && cyc_flag;
  assign EMA2eq1andEMA1eq1andEMA0eq0 = EMA_[2] && EMA_[1] && !EMA_[0] && cyc_flag;
  assign EMA2eq1andEMA1eq1andEMA0eq1 = EMA_[2] && EMA_[1] && EMA_[0] && cyc_flag;

  specify
      $setuphold(posedge CLK &&& CEN_flag, posedge CEN, 1.000, 0.500, NOT_CEN);
      $setuphold(posedge CLK &&& CEN_flag, negedge CEN, 1.000, 0.500, NOT_CEN);
      $setuphold(posedge CLK &&& flag, posedge WEN, 1.000, 0.500, NOT_WEN);
      $setuphold(posedge CLK &&& flag, negedge WEN, 1.000, 0.500, NOT_WEN);
      $setuphold(posedge CLK &&& flag, posedge A[5], 1.000, 0.500, NOT_A5);
      $setuphold(posedge CLK &&& flag, negedge A[5], 1.000, 0.500, NOT_A5);
      $setuphold(posedge CLK &&& flag, posedge A[4], 1.000, 0.500, NOT_A4);
      $setuphold(posedge CLK &&& flag, negedge A[4], 1.000, 0.500, NOT_A4);
      $setuphold(posedge CLK &&& flag, posedge A[3], 1.000, 0.500, NOT_A3);
      $setuphold(posedge CLK &&& flag, negedge A[3], 1.000, 0.500, NOT_A3);
      $setuphold(posedge CLK &&& flag, posedge A[2], 1.000, 0.500, NOT_A2);
      $setuphold(posedge CLK &&& flag, negedge A[2], 1.000, 0.500, NOT_A2);
      $setuphold(posedge CLK &&& flag, posedge A[1], 1.000, 0.500, NOT_A1);
      $setuphold(posedge CLK &&& flag, negedge A[1], 1.000, 0.500, NOT_A1);
      $setuphold(posedge CLK &&& flag, posedge A[0], 1.000, 0.500, NOT_A0);
      $setuphold(posedge CLK &&& flag, negedge A[0], 1.000, 0.500, NOT_A0);
      $setuphold(posedge CLK &&& D_flag, posedge D[127], 1.000, 0.500, NOT_D127);
      $setuphold(posedge CLK &&& D_flag, negedge D[127], 1.000, 0.500, NOT_D127);
      $setuphold(posedge CLK &&& D_flag, posedge D[126], 1.000, 0.500, NOT_D126);
      $setuphold(posedge CLK &&& D_flag, negedge D[126], 1.000, 0.500, NOT_D126);
      $setuphold(posedge CLK &&& D_flag, posedge D[125], 1.000, 0.500, NOT_D125);
      $setuphold(posedge CLK &&& D_flag, negedge D[125], 1.000, 0.500, NOT_D125);
      $setuphold(posedge CLK &&& D_flag, posedge D[124], 1.000, 0.500, NOT_D124);
      $setuphold(posedge CLK &&& D_flag, negedge D[124], 1.000, 0.500, NOT_D124);
      $setuphold(posedge CLK &&& D_flag, posedge D[123], 1.000, 0.500, NOT_D123);
      $setuphold(posedge CLK &&& D_flag, negedge D[123], 1.000, 0.500, NOT_D123);
      $setuphold(posedge CLK &&& D_flag, posedge D[122], 1.000, 0.500, NOT_D122);
      $setuphold(posedge CLK &&& D_flag, negedge D[122], 1.000, 0.500, NOT_D122);
      $setuphold(posedge CLK &&& D_flag, posedge D[121], 1.000, 0.500, NOT_D121);
      $setuphold(posedge CLK &&& D_flag, negedge D[121], 1.000, 0.500, NOT_D121);
      $setuphold(posedge CLK &&& D_flag, posedge D[120], 1.000, 0.500, NOT_D120);
      $setuphold(posedge CLK &&& D_flag, negedge D[120], 1.000, 0.500, NOT_D120);
      $setuphold(posedge CLK &&& D_flag, posedge D[119], 1.000, 0.500, NOT_D119);
      $setuphold(posedge CLK &&& D_flag, negedge D[119], 1.000, 0.500, NOT_D119);
      $setuphold(posedge CLK &&& D_flag, posedge D[118], 1.000, 0.500, NOT_D118);
      $setuphold(posedge CLK &&& D_flag, negedge D[118], 1.000, 0.500, NOT_D118);
      $setuphold(posedge CLK &&& D_flag, posedge D[117], 1.000, 0.500, NOT_D117);
      $setuphold(posedge CLK &&& D_flag, negedge D[117], 1.000, 0.500, NOT_D117);
      $setuphold(posedge CLK &&& D_flag, posedge D[116], 1.000, 0.500, NOT_D116);
      $setuphold(posedge CLK &&& D_flag, negedge D[116], 1.000, 0.500, NOT_D116);
      $setuphold(posedge CLK &&& D_flag, posedge D[115], 1.000, 0.500, NOT_D115);
      $setuphold(posedge CLK &&& D_flag, negedge D[115], 1.000, 0.500, NOT_D115);
      $setuphold(posedge CLK &&& D_flag, posedge D[114], 1.000, 0.500, NOT_D114);
      $setuphold(posedge CLK &&& D_flag, negedge D[114], 1.000, 0.500, NOT_D114);
      $setuphold(posedge CLK &&& D_flag, posedge D[113], 1.000, 0.500, NOT_D113);
      $setuphold(posedge CLK &&& D_flag, negedge D[113], 1.000, 0.500, NOT_D113);
      $setuphold(posedge CLK &&& D_flag, posedge D[112], 1.000, 0.500, NOT_D112);
      $setuphold(posedge CLK &&& D_flag, negedge D[112], 1.000, 0.500, NOT_D112);
      $setuphold(posedge CLK &&& D_flag, posedge D[111], 1.000, 0.500, NOT_D111);
      $setuphold(posedge CLK &&& D_flag, negedge D[111], 1.000, 0.500, NOT_D111);
      $setuphold(posedge CLK &&& D_flag, posedge D[110], 1.000, 0.500, NOT_D110);
      $setuphold(posedge CLK &&& D_flag, negedge D[110], 1.000, 0.500, NOT_D110);
      $setuphold(posedge CLK &&& D_flag, posedge D[109], 1.000, 0.500, NOT_D109);
      $setuphold(posedge CLK &&& D_flag, negedge D[109], 1.000, 0.500, NOT_D109);
      $setuphold(posedge CLK &&& D_flag, posedge D[108], 1.000, 0.500, NOT_D108);
      $setuphold(posedge CLK &&& D_flag, negedge D[108], 1.000, 0.500, NOT_D108);
      $setuphold(posedge CLK &&& D_flag, posedge D[107], 1.000, 0.500, NOT_D107);
      $setuphold(posedge CLK &&& D_flag, negedge D[107], 1.000, 0.500, NOT_D107);
      $setuphold(posedge CLK &&& D_flag, posedge D[106], 1.000, 0.500, NOT_D106);
      $setuphold(posedge CLK &&& D_flag, negedge D[106], 1.000, 0.500, NOT_D106);
      $setuphold(posedge CLK &&& D_flag, posedge D[105], 1.000, 0.500, NOT_D105);
      $setuphold(posedge CLK &&& D_flag, negedge D[105], 1.000, 0.500, NOT_D105);
      $setuphold(posedge CLK &&& D_flag, posedge D[104], 1.000, 0.500, NOT_D104);
      $setuphold(posedge CLK &&& D_flag, negedge D[104], 1.000, 0.500, NOT_D104);
      $setuphold(posedge CLK &&& D_flag, posedge D[103], 1.000, 0.500, NOT_D103);
      $setuphold(posedge CLK &&& D_flag, negedge D[103], 1.000, 0.500, NOT_D103);
      $setuphold(posedge CLK &&& D_flag, posedge D[102], 1.000, 0.500, NOT_D102);
      $setuphold(posedge CLK &&& D_flag, negedge D[102], 1.000, 0.500, NOT_D102);
      $setuphold(posedge CLK &&& D_flag, posedge D[101], 1.000, 0.500, NOT_D101);
      $setuphold(posedge CLK &&& D_flag, negedge D[101], 1.000, 0.500, NOT_D101);
      $setuphold(posedge CLK &&& D_flag, posedge D[100], 1.000, 0.500, NOT_D100);
      $setuphold(posedge CLK &&& D_flag, negedge D[100], 1.000, 0.500, NOT_D100);
      $setuphold(posedge CLK &&& D_flag, posedge D[99], 1.000, 0.500, NOT_D99);
      $setuphold(posedge CLK &&& D_flag, negedge D[99], 1.000, 0.500, NOT_D99);
      $setuphold(posedge CLK &&& D_flag, posedge D[98], 1.000, 0.500, NOT_D98);
      $setuphold(posedge CLK &&& D_flag, negedge D[98], 1.000, 0.500, NOT_D98);
      $setuphold(posedge CLK &&& D_flag, posedge D[97], 1.000, 0.500, NOT_D97);
      $setuphold(posedge CLK &&& D_flag, negedge D[97], 1.000, 0.500, NOT_D97);
      $setuphold(posedge CLK &&& D_flag, posedge D[96], 1.000, 0.500, NOT_D96);
      $setuphold(posedge CLK &&& D_flag, negedge D[96], 1.000, 0.500, NOT_D96);
      $setuphold(posedge CLK &&& D_flag, posedge D[95], 1.000, 0.500, NOT_D95);
      $setuphold(posedge CLK &&& D_flag, negedge D[95], 1.000, 0.500, NOT_D95);
      $setuphold(posedge CLK &&& D_flag, posedge D[94], 1.000, 0.500, NOT_D94);
      $setuphold(posedge CLK &&& D_flag, negedge D[94], 1.000, 0.500, NOT_D94);
      $setuphold(posedge CLK &&& D_flag, posedge D[93], 1.000, 0.500, NOT_D93);
      $setuphold(posedge CLK &&& D_flag, negedge D[93], 1.000, 0.500, NOT_D93);
      $setuphold(posedge CLK &&& D_flag, posedge D[92], 1.000, 0.500, NOT_D92);
      $setuphold(posedge CLK &&& D_flag, negedge D[92], 1.000, 0.500, NOT_D92);
      $setuphold(posedge CLK &&& D_flag, posedge D[91], 1.000, 0.500, NOT_D91);
      $setuphold(posedge CLK &&& D_flag, negedge D[91], 1.000, 0.500, NOT_D91);
      $setuphold(posedge CLK &&& D_flag, posedge D[90], 1.000, 0.500, NOT_D90);
      $setuphold(posedge CLK &&& D_flag, negedge D[90], 1.000, 0.500, NOT_D90);
      $setuphold(posedge CLK &&& D_flag, posedge D[89], 1.000, 0.500, NOT_D89);
      $setuphold(posedge CLK &&& D_flag, negedge D[89], 1.000, 0.500, NOT_D89);
      $setuphold(posedge CLK &&& D_flag, posedge D[88], 1.000, 0.500, NOT_D88);
      $setuphold(posedge CLK &&& D_flag, negedge D[88], 1.000, 0.500, NOT_D88);
      $setuphold(posedge CLK &&& D_flag, posedge D[87], 1.000, 0.500, NOT_D87);
      $setuphold(posedge CLK &&& D_flag, negedge D[87], 1.000, 0.500, NOT_D87);
      $setuphold(posedge CLK &&& D_flag, posedge D[86], 1.000, 0.500, NOT_D86);
      $setuphold(posedge CLK &&& D_flag, negedge D[86], 1.000, 0.500, NOT_D86);
      $setuphold(posedge CLK &&& D_flag, posedge D[85], 1.000, 0.500, NOT_D85);
      $setuphold(posedge CLK &&& D_flag, negedge D[85], 1.000, 0.500, NOT_D85);
      $setuphold(posedge CLK &&& D_flag, posedge D[84], 1.000, 0.500, NOT_D84);
      $setuphold(posedge CLK &&& D_flag, negedge D[84], 1.000, 0.500, NOT_D84);
      $setuphold(posedge CLK &&& D_flag, posedge D[83], 1.000, 0.500, NOT_D83);
      $setuphold(posedge CLK &&& D_flag, negedge D[83], 1.000, 0.500, NOT_D83);
      $setuphold(posedge CLK &&& D_flag, posedge D[82], 1.000, 0.500, NOT_D82);
      $setuphold(posedge CLK &&& D_flag, negedge D[82], 1.000, 0.500, NOT_D82);
      $setuphold(posedge CLK &&& D_flag, posedge D[81], 1.000, 0.500, NOT_D81);
      $setuphold(posedge CLK &&& D_flag, negedge D[81], 1.000, 0.500, NOT_D81);
      $setuphold(posedge CLK &&& D_flag, posedge D[80], 1.000, 0.500, NOT_D80);
      $setuphold(posedge CLK &&& D_flag, negedge D[80], 1.000, 0.500, NOT_D80);
      $setuphold(posedge CLK &&& D_flag, posedge D[79], 1.000, 0.500, NOT_D79);
      $setuphold(posedge CLK &&& D_flag, negedge D[79], 1.000, 0.500, NOT_D79);
      $setuphold(posedge CLK &&& D_flag, posedge D[78], 1.000, 0.500, NOT_D78);
      $setuphold(posedge CLK &&& D_flag, negedge D[78], 1.000, 0.500, NOT_D78);
      $setuphold(posedge CLK &&& D_flag, posedge D[77], 1.000, 0.500, NOT_D77);
      $setuphold(posedge CLK &&& D_flag, negedge D[77], 1.000, 0.500, NOT_D77);
      $setuphold(posedge CLK &&& D_flag, posedge D[76], 1.000, 0.500, NOT_D76);
      $setuphold(posedge CLK &&& D_flag, negedge D[76], 1.000, 0.500, NOT_D76);
      $setuphold(posedge CLK &&& D_flag, posedge D[75], 1.000, 0.500, NOT_D75);
      $setuphold(posedge CLK &&& D_flag, negedge D[75], 1.000, 0.500, NOT_D75);
      $setuphold(posedge CLK &&& D_flag, posedge D[74], 1.000, 0.500, NOT_D74);
      $setuphold(posedge CLK &&& D_flag, negedge D[74], 1.000, 0.500, NOT_D74);
      $setuphold(posedge CLK &&& D_flag, posedge D[73], 1.000, 0.500, NOT_D73);
      $setuphold(posedge CLK &&& D_flag, negedge D[73], 1.000, 0.500, NOT_D73);
      $setuphold(posedge CLK &&& D_flag, posedge D[72], 1.000, 0.500, NOT_D72);
      $setuphold(posedge CLK &&& D_flag, negedge D[72], 1.000, 0.500, NOT_D72);
      $setuphold(posedge CLK &&& D_flag, posedge D[71], 1.000, 0.500, NOT_D71);
      $setuphold(posedge CLK &&& D_flag, negedge D[71], 1.000, 0.500, NOT_D71);
      $setuphold(posedge CLK &&& D_flag, posedge D[70], 1.000, 0.500, NOT_D70);
      $setuphold(posedge CLK &&& D_flag, negedge D[70], 1.000, 0.500, NOT_D70);
      $setuphold(posedge CLK &&& D_flag, posedge D[69], 1.000, 0.500, NOT_D69);
      $setuphold(posedge CLK &&& D_flag, negedge D[69], 1.000, 0.500, NOT_D69);
      $setuphold(posedge CLK &&& D_flag, posedge D[68], 1.000, 0.500, NOT_D68);
      $setuphold(posedge CLK &&& D_flag, negedge D[68], 1.000, 0.500, NOT_D68);
      $setuphold(posedge CLK &&& D_flag, posedge D[67], 1.000, 0.500, NOT_D67);
      $setuphold(posedge CLK &&& D_flag, negedge D[67], 1.000, 0.500, NOT_D67);
      $setuphold(posedge CLK &&& D_flag, posedge D[66], 1.000, 0.500, NOT_D66);
      $setuphold(posedge CLK &&& D_flag, negedge D[66], 1.000, 0.500, NOT_D66);
      $setuphold(posedge CLK &&& D_flag, posedge D[65], 1.000, 0.500, NOT_D65);
      $setuphold(posedge CLK &&& D_flag, negedge D[65], 1.000, 0.500, NOT_D65);
      $setuphold(posedge CLK &&& D_flag, posedge D[64], 1.000, 0.500, NOT_D64);
      $setuphold(posedge CLK &&& D_flag, negedge D[64], 1.000, 0.500, NOT_D64);
      $setuphold(posedge CLK &&& D_flag, posedge D[63], 1.000, 0.500, NOT_D63);
      $setuphold(posedge CLK &&& D_flag, negedge D[63], 1.000, 0.500, NOT_D63);
      $setuphold(posedge CLK &&& D_flag, posedge D[62], 1.000, 0.500, NOT_D62);
      $setuphold(posedge CLK &&& D_flag, negedge D[62], 1.000, 0.500, NOT_D62);
      $setuphold(posedge CLK &&& D_flag, posedge D[61], 1.000, 0.500, NOT_D61);
      $setuphold(posedge CLK &&& D_flag, negedge D[61], 1.000, 0.500, NOT_D61);
      $setuphold(posedge CLK &&& D_flag, posedge D[60], 1.000, 0.500, NOT_D60);
      $setuphold(posedge CLK &&& D_flag, negedge D[60], 1.000, 0.500, NOT_D60);
      $setuphold(posedge CLK &&& D_flag, posedge D[59], 1.000, 0.500, NOT_D59);
      $setuphold(posedge CLK &&& D_flag, negedge D[59], 1.000, 0.500, NOT_D59);
      $setuphold(posedge CLK &&& D_flag, posedge D[58], 1.000, 0.500, NOT_D58);
      $setuphold(posedge CLK &&& D_flag, negedge D[58], 1.000, 0.500, NOT_D58);
      $setuphold(posedge CLK &&& D_flag, posedge D[57], 1.000, 0.500, NOT_D57);
      $setuphold(posedge CLK &&& D_flag, negedge D[57], 1.000, 0.500, NOT_D57);
      $setuphold(posedge CLK &&& D_flag, posedge D[56], 1.000, 0.500, NOT_D56);
      $setuphold(posedge CLK &&& D_flag, negedge D[56], 1.000, 0.500, NOT_D56);
      $setuphold(posedge CLK &&& D_flag, posedge D[55], 1.000, 0.500, NOT_D55);
      $setuphold(posedge CLK &&& D_flag, negedge D[55], 1.000, 0.500, NOT_D55);
      $setuphold(posedge CLK &&& D_flag, posedge D[54], 1.000, 0.500, NOT_D54);
      $setuphold(posedge CLK &&& D_flag, negedge D[54], 1.000, 0.500, NOT_D54);
      $setuphold(posedge CLK &&& D_flag, posedge D[53], 1.000, 0.500, NOT_D53);
      $setuphold(posedge CLK &&& D_flag, negedge D[53], 1.000, 0.500, NOT_D53);
      $setuphold(posedge CLK &&& D_flag, posedge D[52], 1.000, 0.500, NOT_D52);
      $setuphold(posedge CLK &&& D_flag, negedge D[52], 1.000, 0.500, NOT_D52);
      $setuphold(posedge CLK &&& D_flag, posedge D[51], 1.000, 0.500, NOT_D51);
      $setuphold(posedge CLK &&& D_flag, negedge D[51], 1.000, 0.500, NOT_D51);
      $setuphold(posedge CLK &&& D_flag, posedge D[50], 1.000, 0.500, NOT_D50);
      $setuphold(posedge CLK &&& D_flag, negedge D[50], 1.000, 0.500, NOT_D50);
      $setuphold(posedge CLK &&& D_flag, posedge D[49], 1.000, 0.500, NOT_D49);
      $setuphold(posedge CLK &&& D_flag, negedge D[49], 1.000, 0.500, NOT_D49);
      $setuphold(posedge CLK &&& D_flag, posedge D[48], 1.000, 0.500, NOT_D48);
      $setuphold(posedge CLK &&& D_flag, negedge D[48], 1.000, 0.500, NOT_D48);
      $setuphold(posedge CLK &&& D_flag, posedge D[47], 1.000, 0.500, NOT_D47);
      $setuphold(posedge CLK &&& D_flag, negedge D[47], 1.000, 0.500, NOT_D47);
      $setuphold(posedge CLK &&& D_flag, posedge D[46], 1.000, 0.500, NOT_D46);
      $setuphold(posedge CLK &&& D_flag, negedge D[46], 1.000, 0.500, NOT_D46);
      $setuphold(posedge CLK &&& D_flag, posedge D[45], 1.000, 0.500, NOT_D45);
      $setuphold(posedge CLK &&& D_flag, negedge D[45], 1.000, 0.500, NOT_D45);
      $setuphold(posedge CLK &&& D_flag, posedge D[44], 1.000, 0.500, NOT_D44);
      $setuphold(posedge CLK &&& D_flag, negedge D[44], 1.000, 0.500, NOT_D44);
      $setuphold(posedge CLK &&& D_flag, posedge D[43], 1.000, 0.500, NOT_D43);
      $setuphold(posedge CLK &&& D_flag, negedge D[43], 1.000, 0.500, NOT_D43);
      $setuphold(posedge CLK &&& D_flag, posedge D[42], 1.000, 0.500, NOT_D42);
      $setuphold(posedge CLK &&& D_flag, negedge D[42], 1.000, 0.500, NOT_D42);
      $setuphold(posedge CLK &&& D_flag, posedge D[41], 1.000, 0.500, NOT_D41);
      $setuphold(posedge CLK &&& D_flag, negedge D[41], 1.000, 0.500, NOT_D41);
      $setuphold(posedge CLK &&& D_flag, posedge D[40], 1.000, 0.500, NOT_D40);
      $setuphold(posedge CLK &&& D_flag, negedge D[40], 1.000, 0.500, NOT_D40);
      $setuphold(posedge CLK &&& D_flag, posedge D[39], 1.000, 0.500, NOT_D39);
      $setuphold(posedge CLK &&& D_flag, negedge D[39], 1.000, 0.500, NOT_D39);
      $setuphold(posedge CLK &&& D_flag, posedge D[38], 1.000, 0.500, NOT_D38);
      $setuphold(posedge CLK &&& D_flag, negedge D[38], 1.000, 0.500, NOT_D38);
      $setuphold(posedge CLK &&& D_flag, posedge D[37], 1.000, 0.500, NOT_D37);
      $setuphold(posedge CLK &&& D_flag, negedge D[37], 1.000, 0.500, NOT_D37);
      $setuphold(posedge CLK &&& D_flag, posedge D[36], 1.000, 0.500, NOT_D36);
      $setuphold(posedge CLK &&& D_flag, negedge D[36], 1.000, 0.500, NOT_D36);
      $setuphold(posedge CLK &&& D_flag, posedge D[35], 1.000, 0.500, NOT_D35);
      $setuphold(posedge CLK &&& D_flag, negedge D[35], 1.000, 0.500, NOT_D35);
      $setuphold(posedge CLK &&& D_flag, posedge D[34], 1.000, 0.500, NOT_D34);
      $setuphold(posedge CLK &&& D_flag, negedge D[34], 1.000, 0.500, NOT_D34);
      $setuphold(posedge CLK &&& D_flag, posedge D[33], 1.000, 0.500, NOT_D33);
      $setuphold(posedge CLK &&& D_flag, negedge D[33], 1.000, 0.500, NOT_D33);
      $setuphold(posedge CLK &&& D_flag, posedge D[32], 1.000, 0.500, NOT_D32);
      $setuphold(posedge CLK &&& D_flag, negedge D[32], 1.000, 0.500, NOT_D32);
      $setuphold(posedge CLK &&& D_flag, posedge D[31], 1.000, 0.500, NOT_D31);
      $setuphold(posedge CLK &&& D_flag, negedge D[31], 1.000, 0.500, NOT_D31);
      $setuphold(posedge CLK &&& D_flag, posedge D[30], 1.000, 0.500, NOT_D30);
      $setuphold(posedge CLK &&& D_flag, negedge D[30], 1.000, 0.500, NOT_D30);
      $setuphold(posedge CLK &&& D_flag, posedge D[29], 1.000, 0.500, NOT_D29);
      $setuphold(posedge CLK &&& D_flag, negedge D[29], 1.000, 0.500, NOT_D29);
      $setuphold(posedge CLK &&& D_flag, posedge D[28], 1.000, 0.500, NOT_D28);
      $setuphold(posedge CLK &&& D_flag, negedge D[28], 1.000, 0.500, NOT_D28);
      $setuphold(posedge CLK &&& D_flag, posedge D[27], 1.000, 0.500, NOT_D27);
      $setuphold(posedge CLK &&& D_flag, negedge D[27], 1.000, 0.500, NOT_D27);
      $setuphold(posedge CLK &&& D_flag, posedge D[26], 1.000, 0.500, NOT_D26);
      $setuphold(posedge CLK &&& D_flag, negedge D[26], 1.000, 0.500, NOT_D26);
      $setuphold(posedge CLK &&& D_flag, posedge D[25], 1.000, 0.500, NOT_D25);
      $setuphold(posedge CLK &&& D_flag, negedge D[25], 1.000, 0.500, NOT_D25);
      $setuphold(posedge CLK &&& D_flag, posedge D[24], 1.000, 0.500, NOT_D24);
      $setuphold(posedge CLK &&& D_flag, negedge D[24], 1.000, 0.500, NOT_D24);
      $setuphold(posedge CLK &&& D_flag, posedge D[23], 1.000, 0.500, NOT_D23);
      $setuphold(posedge CLK &&& D_flag, negedge D[23], 1.000, 0.500, NOT_D23);
      $setuphold(posedge CLK &&& D_flag, posedge D[22], 1.000, 0.500, NOT_D22);
      $setuphold(posedge CLK &&& D_flag, negedge D[22], 1.000, 0.500, NOT_D22);
      $setuphold(posedge CLK &&& D_flag, posedge D[21], 1.000, 0.500, NOT_D21);
      $setuphold(posedge CLK &&& D_flag, negedge D[21], 1.000, 0.500, NOT_D21);
      $setuphold(posedge CLK &&& D_flag, posedge D[20], 1.000, 0.500, NOT_D20);
      $setuphold(posedge CLK &&& D_flag, negedge D[20], 1.000, 0.500, NOT_D20);
      $setuphold(posedge CLK &&& D_flag, posedge D[19], 1.000, 0.500, NOT_D19);
      $setuphold(posedge CLK &&& D_flag, negedge D[19], 1.000, 0.500, NOT_D19);
      $setuphold(posedge CLK &&& D_flag, posedge D[18], 1.000, 0.500, NOT_D18);
      $setuphold(posedge CLK &&& D_flag, negedge D[18], 1.000, 0.500, NOT_D18);
      $setuphold(posedge CLK &&& D_flag, posedge D[17], 1.000, 0.500, NOT_D17);
      $setuphold(posedge CLK &&& D_flag, negedge D[17], 1.000, 0.500, NOT_D17);
      $setuphold(posedge CLK &&& D_flag, posedge D[16], 1.000, 0.500, NOT_D16);
      $setuphold(posedge CLK &&& D_flag, negedge D[16], 1.000, 0.500, NOT_D16);
      $setuphold(posedge CLK &&& D_flag, posedge D[15], 1.000, 0.500, NOT_D15);
      $setuphold(posedge CLK &&& D_flag, negedge D[15], 1.000, 0.500, NOT_D15);
      $setuphold(posedge CLK &&& D_flag, posedge D[14], 1.000, 0.500, NOT_D14);
      $setuphold(posedge CLK &&& D_flag, negedge D[14], 1.000, 0.500, NOT_D14);
      $setuphold(posedge CLK &&& D_flag, posedge D[13], 1.000, 0.500, NOT_D13);
      $setuphold(posedge CLK &&& D_flag, negedge D[13], 1.000, 0.500, NOT_D13);
      $setuphold(posedge CLK &&& D_flag, posedge D[12], 1.000, 0.500, NOT_D12);
      $setuphold(posedge CLK &&& D_flag, negedge D[12], 1.000, 0.500, NOT_D12);
      $setuphold(posedge CLK &&& D_flag, posedge D[11], 1.000, 0.500, NOT_D11);
      $setuphold(posedge CLK &&& D_flag, negedge D[11], 1.000, 0.500, NOT_D11);
      $setuphold(posedge CLK &&& D_flag, posedge D[10], 1.000, 0.500, NOT_D10);
      $setuphold(posedge CLK &&& D_flag, negedge D[10], 1.000, 0.500, NOT_D10);
      $setuphold(posedge CLK &&& D_flag, posedge D[9], 1.000, 0.500, NOT_D9);
      $setuphold(posedge CLK &&& D_flag, negedge D[9], 1.000, 0.500, NOT_D9);
      $setuphold(posedge CLK &&& D_flag, posedge D[8], 1.000, 0.500, NOT_D8);
      $setuphold(posedge CLK &&& D_flag, negedge D[8], 1.000, 0.500, NOT_D8);
      $setuphold(posedge CLK &&& D_flag, posedge D[7], 1.000, 0.500, NOT_D7);
      $setuphold(posedge CLK &&& D_flag, negedge D[7], 1.000, 0.500, NOT_D7);
      $setuphold(posedge CLK &&& D_flag, posedge D[6], 1.000, 0.500, NOT_D6);
      $setuphold(posedge CLK &&& D_flag, negedge D[6], 1.000, 0.500, NOT_D6);
      $setuphold(posedge CLK &&& D_flag, posedge D[5], 1.000, 0.500, NOT_D5);
      $setuphold(posedge CLK &&& D_flag, negedge D[5], 1.000, 0.500, NOT_D5);
      $setuphold(posedge CLK &&& D_flag, posedge D[4], 1.000, 0.500, NOT_D4);
      $setuphold(posedge CLK &&& D_flag, negedge D[4], 1.000, 0.500, NOT_D4);
      $setuphold(posedge CLK &&& D_flag, posedge D[3], 1.000, 0.500, NOT_D3);
      $setuphold(posedge CLK &&& D_flag, negedge D[3], 1.000, 0.500, NOT_D3);
      $setuphold(posedge CLK &&& D_flag, posedge D[2], 1.000, 0.500, NOT_D2);
      $setuphold(posedge CLK &&& D_flag, negedge D[2], 1.000, 0.500, NOT_D2);
      $setuphold(posedge CLK &&& D_flag, posedge D[1], 1.000, 0.500, NOT_D1);
      $setuphold(posedge CLK &&& D_flag, negedge D[1], 1.000, 0.500, NOT_D1);
      $setuphold(posedge CLK &&& D_flag, posedge D[0], 1.000, 0.500, NOT_D0);
      $setuphold(posedge CLK &&& D_flag, negedge D[0], 1.000, 0.500, NOT_D0);
      $setuphold(posedge CLK &&& cyc_flag, posedge EMA[2], 1.000, 0.500, NOT_EMA2);
      $setuphold(posedge CLK &&& cyc_flag, negedge EMA[2], 1.000, 0.500, NOT_EMA2);
      $setuphold(posedge CLK &&& cyc_flag, posedge EMA[1], 1.000, 0.500, NOT_EMA1);
      $setuphold(posedge CLK &&& cyc_flag, negedge EMA[1], 1.000, 0.500, NOT_EMA1);
      $setuphold(posedge CLK &&& cyc_flag, posedge EMA[0], 1.000, 0.500, NOT_EMA0);
      $setuphold(posedge CLK &&& cyc_flag, negedge EMA[0], 1.000, 0.500, NOT_EMA0);
      $setuphold(posedge CLK, posedge RETN, 1.000, 0.500, NOT_RETN);
      $setuphold(posedge CLK, negedge RETN, 1.000, 0.500, NOT_RETN);
      $hold(posedge RETN, negedge CEN, 1.000, NOT_RETN);

      $width(posedge CLK &&& cyc_flag, 1.000, 0, NOT_CLK_MINH);
      $width(negedge CLK &&& cyc_flag, 1.000, 0, NOT_CLK_MINL);
`ifdef NO_SDTC
      $period(posedge CLK  &&& cyc_flag, 3.000, NOT_CLK_PER);
`else
      $period(posedge CLK &&& EMA2eq0andEMA1eq0andEMA0eq0, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq0andEMA1eq0andEMA0eq1, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq0andEMA1eq1andEMA0eq0, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq0andEMA1eq1andEMA0eq1, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq1andEMA1eq0andEMA0eq0, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq1andEMA1eq0andEMA0eq1, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq1andEMA1eq1andEMA0eq0, 3.000, NOT_CLK_PER);
      $period(posedge CLK &&& EMA2eq1andEMA1eq1andEMA0eq1, 3.000, NOT_CLK_PER);
`endif

      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[127]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[127]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[127]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[127]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[127]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[127]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[127]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[127]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[126]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[126]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[126]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[126]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[126]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[126]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[126]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[126]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[125]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[125]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[125]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[125]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[125]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[125]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[125]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[125]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[124]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[124]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[124]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[124]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[124]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[124]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[124]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[124]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[123]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[123]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[123]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[123]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[123]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[123]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[123]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[123]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[122]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[122]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[122]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[122]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[122]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[122]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[122]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[122]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[121]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[121]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[121]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[121]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[121]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[121]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[121]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[121]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[120]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[120]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[120]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[120]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[120]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[120]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[120]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[120]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[119]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[119]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[119]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[119]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[119]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[119]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[119]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[119]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[118]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[118]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[118]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[118]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[118]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[118]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[118]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[118]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[117]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[117]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[117]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[117]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[117]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[117]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[117]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[117]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[116]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[116]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[116]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[116]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[116]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[116]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[116]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[116]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[115]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[115]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[115]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[115]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[115]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[115]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[115]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[115]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[114]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[114]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[114]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[114]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[114]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[114]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[114]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[114]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[113]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[113]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[113]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[113]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[113]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[113]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[113]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[113]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[112]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[112]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[112]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[112]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[112]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[112]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[112]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[112]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[111]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[111]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[111]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[111]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[111]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[111]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[111]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[111]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[110]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[110]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[110]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[110]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[110]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[110]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[110]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[110]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[109]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[109]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[109]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[109]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[109]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[109]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[109]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[109]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[108]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[108]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[108]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[108]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[108]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[108]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[108]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[108]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[107]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[107]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[107]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[107]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[107]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[107]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[107]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[107]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[106]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[106]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[106]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[106]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[106]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[106]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[106]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[106]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[105]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[105]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[105]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[105]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[105]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[105]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[105]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[105]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[104]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[104]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[104]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[104]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[104]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[104]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[104]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[104]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[103]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[103]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[103]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[103]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[103]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[103]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[103]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[103]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[102]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[102]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[102]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[102]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[102]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[102]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[102]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[102]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[101]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[101]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[101]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[101]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[101]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[101]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[101]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[101]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[100]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[100]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[100]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[100]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[100]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[100]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[100]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[100]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[99]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[99]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[99]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[99]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[99]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[99]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[99]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[99]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[98]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[98]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[98]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[98]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[98]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[98]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[98]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[98]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[97]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[97]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[97]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[97]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[97]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[97]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[97]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[97]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[96]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[96]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[96]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[96]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[96]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[96]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[96]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[96]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[95]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[95]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[95]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[95]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[95]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[95]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[95]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[95]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[94]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[94]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[94]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[94]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[94]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[94]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[94]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[94]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[93]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[93]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[93]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[93]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[93]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[93]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[93]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[93]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[92]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[92]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[92]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[92]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[92]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[92]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[92]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[92]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[91]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[91]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[91]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[91]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[91]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[91]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[91]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[91]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[90]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[90]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[90]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[90]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[90]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[90]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[90]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[90]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[89]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[89]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[89]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[89]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[89]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[89]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[89]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[89]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[88]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[88]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[88]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[88]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[88]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[88]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[88]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[88]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[87]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[87]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[87]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[87]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[87]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[87]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[87]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[87]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[86]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[86]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[86]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[86]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[86]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[86]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[86]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[86]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[85]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[85]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[85]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[85]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[85]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[85]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[85]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[85]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[84]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[84]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[84]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[84]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[84]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[84]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[84]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[84]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[83]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[83]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[83]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[83]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[83]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[83]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[83]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[83]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[82]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[82]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[82]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[82]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[82]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[82]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[82]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[82]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[81]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[81]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[81]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[81]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[81]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[81]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[81]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[81]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[80]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[80]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[80]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[80]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[80]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[80]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[80]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[80]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[79]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[79]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[79]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[79]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[79]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[79]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[79]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[79]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[78]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[78]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[78]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[78]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[78]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[78]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[78]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[78]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[77]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[77]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[77]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[77]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[77]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[77]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[77]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[77]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[76]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[76]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[76]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[76]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[76]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[76]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[76]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[76]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[75]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[75]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[75]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[75]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[75]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[75]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[75]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[75]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[74]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[74]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[74]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[74]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[74]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[74]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[74]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[74]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[73]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[73]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[73]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[73]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[73]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[73]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[73]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[73]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[72]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[72]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[72]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[72]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[72]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[72]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[72]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[72]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[71]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[71]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[71]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[71]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[71]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[71]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[71]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[71]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[70]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[70]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[70]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[70]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[70]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[70]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[70]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[70]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[69]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[69]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[69]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[69]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[69]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[69]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[69]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[69]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[68]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[68]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[68]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[68]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[68]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[68]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[68]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[68]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[67]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[67]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[67]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[67]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[67]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[67]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[67]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[67]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[66]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[66]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[66]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[66]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[66]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[66]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[66]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[66]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[65]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[65]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[65]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[65]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[65]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[65]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[65]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[65]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[64]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[64]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[64]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[64]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[64]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[64]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[64]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[64]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[63]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[63]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[63]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[63]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[63]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[63]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[63]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[63]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[62]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[62]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[62]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[62]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[62]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[62]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[62]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[62]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[61]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[61]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[61]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[61]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[61]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[61]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[61]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[61]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[60]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[60]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[60]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[60]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[60]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[60]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[60]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[60]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[59]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[59]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[59]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[59]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[59]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[59]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[59]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[59]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[58]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[58]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[58]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[58]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[58]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[58]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[58]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[58]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[57]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[57]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[57]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[57]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[57]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[57]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[57]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[57]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[56]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[56]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[56]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[56]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[56]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[56]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[56]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[56]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[55]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[55]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[55]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[55]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[55]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[55]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[55]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[55]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[54]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[54]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[54]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[54]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[54]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[54]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[54]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[54]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[53]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[53]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[53]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[53]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[53]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[53]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[53]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[53]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[52]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[52]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[52]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[52]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[52]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[52]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[52]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[52]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[51]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[51]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[51]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[51]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[51]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[51]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[51]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[51]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[50]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[50]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[50]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[50]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[50]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[50]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[50]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[50]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[49]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[49]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[49]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[49]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[49]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[49]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[49]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[49]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[48]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[48]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[48]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[48]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[48]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[48]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[48]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[48]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[47]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[47]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[47]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[47]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[47]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[47]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[47]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[47]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[46]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[46]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[46]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[46]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[46]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[46]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[46]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[46]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[45]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[45]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[45]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[45]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[45]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[45]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[45]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[45]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[44]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[44]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[44]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[44]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[44]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[44]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[44]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[44]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[43]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[43]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[43]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[43]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[43]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[43]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[43]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[43]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[42]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[42]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[42]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[42]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[42]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[42]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[42]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[42]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[41]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[41]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[41]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[41]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[41]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[41]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[41]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[41]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[40]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[40]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[40]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[40]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[40]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[40]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[40]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[40]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[39]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[39]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[39]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[39]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[39]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[39]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[39]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[39]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[38]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[38]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[38]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[38]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[38]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[38]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[38]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[38]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[37]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[37]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[37]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[37]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[37]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[37]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[37]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[37]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[36]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[36]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[36]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[36]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[36]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[36]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[36]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[36]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[35]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[35]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[35]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[35]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[35]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[35]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[35]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[35]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[34]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[34]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[34]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[34]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[34]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[34]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[34]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[34]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[33]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[33]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[33]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[33]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[33]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[33]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[33]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[33]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[32]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[32]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[32]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[32]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[32]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[32]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[32]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[32]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[31]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[30]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[29]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[28]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[27]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[26]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[25]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[24]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[23]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[22]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[21]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[20]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[19]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[18]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[17]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[16]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[15]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[14]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[13]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[12]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[11]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[10]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[9]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[8]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[7]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[6]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[5]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[4]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[3]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[2]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[1]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b0) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b0) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b0))
        (posedge CLK => (Q[0]:1'b0))=(1.000, 1.000);
      if ((EMA[2] == 1'b1) && (EMA[1] == 1'b1) && (EMA[0] == 1'b1))
        (posedge CLK => (Q[0]:1'b0))=(1.000, 1.000);

      (RETN => (Q[127] +: 1'b0)) = (1.000);
      (RETN => (Q[126] +: 1'b0)) = (1.000);
      (RETN => (Q[125] +: 1'b0)) = (1.000);
      (RETN => (Q[124] +: 1'b0)) = (1.000);
      (RETN => (Q[123] +: 1'b0)) = (1.000);
      (RETN => (Q[122] +: 1'b0)) = (1.000);
      (RETN => (Q[121] +: 1'b0)) = (1.000);
      (RETN => (Q[120] +: 1'b0)) = (1.000);
      (RETN => (Q[119] +: 1'b0)) = (1.000);
      (RETN => (Q[118] +: 1'b0)) = (1.000);
      (RETN => (Q[117] +: 1'b0)) = (1.000);
      (RETN => (Q[116] +: 1'b0)) = (1.000);
      (RETN => (Q[115] +: 1'b0)) = (1.000);
      (RETN => (Q[114] +: 1'b0)) = (1.000);
      (RETN => (Q[113] +: 1'b0)) = (1.000);
      (RETN => (Q[112] +: 1'b0)) = (1.000);
      (RETN => (Q[111] +: 1'b0)) = (1.000);
      (RETN => (Q[110] +: 1'b0)) = (1.000);
      (RETN => (Q[109] +: 1'b0)) = (1.000);
      (RETN => (Q[108] +: 1'b0)) = (1.000);
      (RETN => (Q[107] +: 1'b0)) = (1.000);
      (RETN => (Q[106] +: 1'b0)) = (1.000);
      (RETN => (Q[105] +: 1'b0)) = (1.000);
      (RETN => (Q[104] +: 1'b0)) = (1.000);
      (RETN => (Q[103] +: 1'b0)) = (1.000);
      (RETN => (Q[102] +: 1'b0)) = (1.000);
      (RETN => (Q[101] +: 1'b0)) = (1.000);
      (RETN => (Q[100] +: 1'b0)) = (1.000);
      (RETN => (Q[99] +: 1'b0)) = (1.000);
      (RETN => (Q[98] +: 1'b0)) = (1.000);
      (RETN => (Q[97] +: 1'b0)) = (1.000);
      (RETN => (Q[96] +: 1'b0)) = (1.000);
      (RETN => (Q[95] +: 1'b0)) = (1.000);
      (RETN => (Q[94] +: 1'b0)) = (1.000);
      (RETN => (Q[93] +: 1'b0)) = (1.000);
      (RETN => (Q[92] +: 1'b0)) = (1.000);
      (RETN => (Q[91] +: 1'b0)) = (1.000);
      (RETN => (Q[90] +: 1'b0)) = (1.000);
      (RETN => (Q[89] +: 1'b0)) = (1.000);
      (RETN => (Q[88] +: 1'b0)) = (1.000);
      (RETN => (Q[87] +: 1'b0)) = (1.000);
      (RETN => (Q[86] +: 1'b0)) = (1.000);
      (RETN => (Q[85] +: 1'b0)) = (1.000);
      (RETN => (Q[84] +: 1'b0)) = (1.000);
      (RETN => (Q[83] +: 1'b0)) = (1.000);
      (RETN => (Q[82] +: 1'b0)) = (1.000);
      (RETN => (Q[81] +: 1'b0)) = (1.000);
      (RETN => (Q[80] +: 1'b0)) = (1.000);
      (RETN => (Q[79] +: 1'b0)) = (1.000);
      (RETN => (Q[78] +: 1'b0)) = (1.000);
      (RETN => (Q[77] +: 1'b0)) = (1.000);
      (RETN => (Q[76] +: 1'b0)) = (1.000);
      (RETN => (Q[75] +: 1'b0)) = (1.000);
      (RETN => (Q[74] +: 1'b0)) = (1.000);
      (RETN => (Q[73] +: 1'b0)) = (1.000);
      (RETN => (Q[72] +: 1'b0)) = (1.000);
      (RETN => (Q[71] +: 1'b0)) = (1.000);
      (RETN => (Q[70] +: 1'b0)) = (1.000);
      (RETN => (Q[69] +: 1'b0)) = (1.000);
      (RETN => (Q[68] +: 1'b0)) = (1.000);
      (RETN => (Q[67] +: 1'b0)) = (1.000);
      (RETN => (Q[66] +: 1'b0)) = (1.000);
      (RETN => (Q[65] +: 1'b0)) = (1.000);
      (RETN => (Q[64] +: 1'b0)) = (1.000);
      (RETN => (Q[63] +: 1'b0)) = (1.000);
      (RETN => (Q[62] +: 1'b0)) = (1.000);
      (RETN => (Q[61] +: 1'b0)) = (1.000);
      (RETN => (Q[60] +: 1'b0)) = (1.000);
      (RETN => (Q[59] +: 1'b0)) = (1.000);
      (RETN => (Q[58] +: 1'b0)) = (1.000);
      (RETN => (Q[57] +: 1'b0)) = (1.000);
      (RETN => (Q[56] +: 1'b0)) = (1.000);
      (RETN => (Q[55] +: 1'b0)) = (1.000);
      (RETN => (Q[54] +: 1'b0)) = (1.000);
      (RETN => (Q[53] +: 1'b0)) = (1.000);
      (RETN => (Q[52] +: 1'b0)) = (1.000);
      (RETN => (Q[51] +: 1'b0)) = (1.000);
      (RETN => (Q[50] +: 1'b0)) = (1.000);
      (RETN => (Q[49] +: 1'b0)) = (1.000);
      (RETN => (Q[48] +: 1'b0)) = (1.000);
      (RETN => (Q[47] +: 1'b0)) = (1.000);
      (RETN => (Q[46] +: 1'b0)) = (1.000);
      (RETN => (Q[45] +: 1'b0)) = (1.000);
      (RETN => (Q[44] +: 1'b0)) = (1.000);
      (RETN => (Q[43] +: 1'b0)) = (1.000);
      (RETN => (Q[42] +: 1'b0)) = (1.000);
      (RETN => (Q[41] +: 1'b0)) = (1.000);
      (RETN => (Q[40] +: 1'b0)) = (1.000);
      (RETN => (Q[39] +: 1'b0)) = (1.000);
      (RETN => (Q[38] +: 1'b0)) = (1.000);
      (RETN => (Q[37] +: 1'b0)) = (1.000);
      (RETN => (Q[36] +: 1'b0)) = (1.000);
      (RETN => (Q[35] +: 1'b0)) = (1.000);
      (RETN => (Q[34] +: 1'b0)) = (1.000);
      (RETN => (Q[33] +: 1'b0)) = (1.000);
      (RETN => (Q[32] +: 1'b0)) = (1.000);
      (RETN => (Q[31] +: 1'b0)) = (1.000);
      (RETN => (Q[30] +: 1'b0)) = (1.000);
      (RETN => (Q[29] +: 1'b0)) = (1.000);
      (RETN => (Q[28] +: 1'b0)) = (1.000);
      (RETN => (Q[27] +: 1'b0)) = (1.000);
      (RETN => (Q[26] +: 1'b0)) = (1.000);
      (RETN => (Q[25] +: 1'b0)) = (1.000);
      (RETN => (Q[24] +: 1'b0)) = (1.000);
      (RETN => (Q[23] +: 1'b0)) = (1.000);
      (RETN => (Q[22] +: 1'b0)) = (1.000);
      (RETN => (Q[21] +: 1'b0)) = (1.000);
      (RETN => (Q[20] +: 1'b0)) = (1.000);
      (RETN => (Q[19] +: 1'b0)) = (1.000);
      (RETN => (Q[18] +: 1'b0)) = (1.000);
      (RETN => (Q[17] +: 1'b0)) = (1.000);
      (RETN => (Q[16] +: 1'b0)) = (1.000);
      (RETN => (Q[15] +: 1'b0)) = (1.000);
      (RETN => (Q[14] +: 1'b0)) = (1.000);
      (RETN => (Q[13] +: 1'b0)) = (1.000);
      (RETN => (Q[12] +: 1'b0)) = (1.000);
      (RETN => (Q[11] +: 1'b0)) = (1.000);
      (RETN => (Q[10] +: 1'b0)) = (1.000);
      (RETN => (Q[9] +: 1'b0)) = (1.000);
      (RETN => (Q[8] +: 1'b0)) = (1.000);
      (RETN => (Q[7] +: 1'b0)) = (1.000);
      (RETN => (Q[6] +: 1'b0)) = (1.000);
      (RETN => (Q[5] +: 1'b0)) = (1.000);
      (RETN => (Q[4] +: 1'b0)) = (1.000);
      (RETN => (Q[3] +: 1'b0)) = (1.000);
      (RETN => (Q[2] +: 1'b0)) = (1.000);
      (RETN => (Q[1] +: 1'b0)) = (1.000);
      (RETN => (Q[0] +: 1'b0)) = (1.000);
  endspecify

endmodule
`endcelldefine
`endif
