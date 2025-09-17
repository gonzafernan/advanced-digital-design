//! @title GP01 Exercise 1 module implementation.
//! @author Gonzalo G. Fernandez
//! @date 16-09-2025
//! @version Advance Digital Design - GP01

module gp01_ex1 (
    output [5:0] o_data,     //! Data output
    output       o_overflow, //! Sum overflow flag

    input [2:0] i_data1,  //! Input data 1
    input [2:0] i_data2,  //! Input data 2
    input [1:0] i_sel,    //! Sum input selection
    input       i_rst_n,  //! Reset **active low**
    input       clk       //! System clock
);

  reg  [3:0] data_sel;  //! Data selection for sum input
  wire [3:0] data1_w_zero;
  wire [3:0] data2_w_zero;

  reg  [6:0] sum_result;

  assign data1_w_zero = {1'b0, i_data1};
  assign data2_w_zero = {1'b0, i_data2};

  always @(*) begin : data_selection
    case (i_sel)
      2'b00:   data_sel = data2_w_zero;
      2'b01:   data_sel = data1_w_zero + data2_w_zero;
      2'b10:   data_sel = data1_w_zero;
      2'b11:   data_sel = {4{1'b0}};
      default: data_sel = {4{1'b0}};
    endcase
  end

  always @(posedge clk) begin : data_valid
    if (~i_rst_n) begin
      sum_result <= {7{1'b0}};
    end else begin
      sum_result <= {1'b0, sum_result[5:0]} + {{3'b000}, data_sel};
    end
  end

  assign o_data = sum_result[5:0];
  assign o_overflow = sum_result[6];

endmodule
