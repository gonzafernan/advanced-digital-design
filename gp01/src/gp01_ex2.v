//! @title GP01 Exercise 2 module implementation.
//! @author Gonzalo G. Fernandez
//! @date 19-09-2026
//! @version Advance Digital Design - GP01

module gp01_ex2 (
    output signed [15:0] o_dataC,  //! Output data C
    input  signed [15:0] i_dataA,  //! Input data A
    input  signed [15:0] i_dataB,  //! Input data B
    input         [ 1:0] i_sel     //! Operation selection
);

  reg signed [15:0] data_sel;

  always @(*) begin : operation_selection
    case (i_sel)
      2'b00:   data_sel <= i_dataA + i_dataB;
      2'b01:   data_sel <= i_dataA - i_dataB;
      2'b10:   data_sel <= i_dataA & i_dataB;
      2'b11:   data_sel <= i_dataA | i_dataB;
      default: data_sel <= {16{1'b0}};
    endcase
  end

  assign o_dataC = data_sel;

endmodule
