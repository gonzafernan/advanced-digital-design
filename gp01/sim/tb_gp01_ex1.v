//! @title GP01 Exercise 1 testbench implementation.
//! @author Gonzalo G. Fernandez
//! @date 17-09-2025
//! @version Advance Digital Design - GP01

`timescale 1ns / 100ps

module tb_gp01_ex1 ();

  wire [5:0] o_data;
  wire o_overflow;
  reg [2:0] i_data1;
  reg [2:0] i_data2;
  reg [1:0] i_sel;
  reg i_rst_n;
  reg clock;

  // Internal state
  wire [6:0] tb_sum;
  assign tb_sum = tb_gp01_ex1.u_gp01_ex1.sum_result;

  // Counter to answer number of clock periods until overflow
  integer overflow_counter;

  //! Clock generator
  always #5 clock = ~clock;

  initial begin : stimulus
    overflow_counter = 0;
    i_rst_n = 1'b0;
    clock = 1'b0;
    i_data1 = 3'b001;
    i_data2 = 3'b001;
    i_sel = 2'b00;

    #100 i_rst_n = 1'b1;
    wait (i_sel == 2'b11);
    #100 $finish;
  end

  always @(posedge o_overflow) begin
    i_sel = i_sel + 2'b01;
  end

  always @(posedge clock) begin
    if (i_sel == 2'b01 & i_rst_n == 1'b1) begin
      overflow_counter = overflow_counter + 1;
    end else begin
      overflow_counter = 0;
    end
  end

  gp01_ex1 u_gp01_ex1 (
      .o_data(o_data),
      .o_overflow(o_overflow),
      .i_data1(i_data1),
      .i_data2(i_data2),
      .i_sel(i_sel),
      .i_rst_n(i_rst_n),
      .clk(clock)
  );

endmodule  // tb_gp01_ex1
