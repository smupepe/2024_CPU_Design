module SMU_RV32I_System (
  input         CLOCK_50,
  input   [2:0] BUTTON,
  input   [9:0] SW,
  output  [6:0] HEX3,
  output  [6:0] HEX2,
  output  [6:0] HEX1,
  output  [6:0] HEX0,
  output  [9:0] LEDR,

  output        UART_TXD,
  input         UART_RXD
);

  parameter RESET_PC = 32'h1000_0000;
  parameter CLOCK_FREQ = 125_000_000;
  parameter BAUD_RATE = 115_200;
  parameter MIF_HEX = "";
  parameter MIF_BIOS_HEX = "";
  parameter DWIDTH = 32;
  parameter AWIDTH = 12;

  wire [31:0] PC, Instr;
  wire [31:0] WriteData, DataAdr;
  wire MemWrite;
  wire [31:0] ReadData;

  wire reset;
  wire reset_poweron;
  reg  reset_ff;

  wire [31:0] data_addr;
  wire [31:0] write_data;
  wire [3:0]  ByteEnable;
  wire  [31:0] read_data;
  wire        cs_mem_n;
  wire        cs_timer_n;
  wire        cs_gpio_n;
  wire        cs_uart_n;
  wire        data_we;
  wire [31:0] imem_inst;

  wire clk = CLOCK_50;
  wire clkb;

  wire data_re;

  wire cs_dmem_n;
  wire cs_tbman_n;
  
  // reset =  BUTTON[0]
  // if BUTTON[0] is pressed, the reset goes down to "0"
  // reset is a low-active signal
  assign  reset_poweron = BUTTON[0];
  assign  reset = reset_poweron;

  always @(posedge clk)
    reset_ff <= reset;

  assign clkb = ~clk;

  wire n_rst = reset_ff;

  wire [31:0] read_imem_data_mem;
  wire [31:0] read_data_tbman;

  assign data_re = ~data_we;
  assign read_data = read_imem_data_mem;
  assign Instr = imem_inst;

  riscvsingle #(
      .RESET_PC(RESET_PC)
    ) icpu (
    .clk(clk),
    .n_rst(n_rst),
    .PC(PC),
    .Instr(Instr),
    .MemWrite(MemWrite),
    .ALUResult(DataAdr),
    .WriteData(WriteData),
    .ReadData(ReadData),
    .byte_enable(ByteEnable)
  );

  // imem imem(
  // 	.a(PC), 
  // 	.rd(Instr)
  // );

  // dmem dmem(
  // 	.clk(clk),
  // 	.wen0(MemWrite),
  // 	.addr0(DataAdr),
  // 	.d0(WriteData),
  // 	.q0(ReadData)
  // );

    ASYNC_RAM_DP_WBE #(
        .DWIDTH (DWIDTH),
        .AWIDTH (AWIDTH),
        .MIF_HEX (MIF_HEX)
    ) imem (
      .clk      (clk),
      .addr0    (PC[AWIDTH+2-1:2]),
      .addr1    (DataAdr[AWIDTH+2-1:2]),
      .wbe0     (4'd0),
      .wbe1     (ByteEnable),
      //.wbe1     (4'hF),
      .d0       (32'd0),
      .d1       (WriteData),
      .wen0     (1'b0),
      //.wen1     (MemWrite & ~cs_dmem_n),//~cs_mem_n &
      .wen1     (MemWrite),
      .q0       (imem_inst),
      .q1       (read_imem_data_mem)
    );

    // Addr_Decoder u_Addr_Decoder(
    //   .Addr(DataAdr),
    //   .CS_DMEM_N(cs_dmem_n),
    //   .CS_TBMAN_N(cs_tbman_n)
    // );

    // data_mux u_data_mux(
    //   .cs_dmem_n(cs_dmem_n),
    //   .read_data_dmem(read_imem_data_mem),
    //   .cs_tbman_n(cs_tbman_n),
    //   .read_data_tbman(read_data_tbman),
    //   .read_data(ReadData)
    // );

    // tbman_wrap u_tbman_wrap(
    //   .clk(clk),
    //   .rst_n(n_rst),
    //   .tbman_sel(~cs_tbman_n), // CS_N
    //   .tbman_write(MemWrite), // WR_N
    //   .tbman_addr(DataAdr[15:0]), // Addr
    //   .tbman_wdata(WriteData), // Datain
    //   .tbman_rdata(read_data_tbman) // DataOut
    // );

endmodule