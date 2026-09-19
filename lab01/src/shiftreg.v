//! @title Shift register module
//! @author Gonzalo G. Fernandez
//! @date 19-09-2026
//! @version Advance Digital Design - Lab01

//! @brief Shift register

module shiftreg #(
    // Parameters
    parameter integer NB_SHIFTREG = 4  //! Number of bits
) (
    // Ports
    output [NB_SHIFTREG-1:0] o_shift,  //! output register

    input i_valid,  //! Valid signal to produce shift
    input i_reset,  //! Reset **active high**
    input clock     //! System clock
);

  // var
  reg [NB_SHIFTREG-1:0] shiftreg;  //! Shift register

  //! Describes the behavior of the shift register
  always @(posedge clock) begin : shift_register
    if (i_reset) begin
      shiftreg <= {{NB_SHIFTREG - 1{1'b0}}, 1'b1};
    end else if (i_valid) begin
      shiftreg <= {shiftreg[NB_SHIFTREG-2:0], shiftreg[NB_SHIFTREG-1]};
    end else begin
      shiftreg <= shiftreg;
    end
  end

  assign o_shift = shiftreg;

endmodule  // shiftreg
