//! @title GP01 Exercise 2 testbench implementation.
//! @author Gonzalo G. Fernandez
//! @date 20-09-2025
//! @version Advance Digital Design - GP01

`timescale 1ns / 100ps

module tb_gp01_ex2 ();

  wire signed [15:0] o_dataC;
  reg signed [15:0] i_dataA;
  reg signed [15:0] i_dataB;
  reg [1:0] i_sel;
  reg clock;

  //! Clock generator
  always #5 clock = ~clock;

  initial begin : stimulus
    clock = 1'b0;
    i_sel = 2'b00;

  end

  always @(posedge clock) begin
    i_sel = i_sel + 2'b01;
  end

  gp01_ex2 u_gp01_ex2 (
      .o_dataC(o_dataC),
      .i_dataA(i_dataA),
      .i_dataB(i_dataB),
      .i_sel(i_sel),
      .clk(clock)
  );

endmodule  // tb_gp01_ex2
