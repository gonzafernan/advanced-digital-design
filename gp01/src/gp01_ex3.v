//! @title GP01 Exercise 3 example code
//! @date 20-09-2026
//! @version Advance Digital Design - GP01

module gp01_ex3 (

    input [31:0] x0,
    input [1:0] sel,
    input clk,
    input rst_n,
    output reg [31:0] y0
);

  reg [31:0] x1, x2, x3;
  reg  [31:0] y1;
  wire [31:0] out;

  assign out = (x0 + x1 + x2 + x3 + +y1) >>> 2;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      x1 <= 0;
      x2 <= 0;
      x3 <= 0;
    end else if (sel == 2'b00) begin
      x3 <= x2;
      x2 <= x1;
      x1 <= x0;
    end else if (sel == 2'b01) begin
      x3 <= x1;
      x2 <= x0;
      x1 <= x2;
    end else begin
      x3 <= x3;
      x2 <= x2;
      x1 <= x0;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      y1 <= 0;
      y0 <= 0;
    end else begin
      y1 <= y0;
      y0 <= out;
    end
  end

endmodule
