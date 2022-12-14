//! @title Shift register module
//! @author Gonzalo G. Fernandez
//! @date 09-02-2022
//! @version Advance Digital Design - Lab01

//! @brief Shift register related to LEDs state

module shiftreg 
#(
    // Parameters
    parameter NB_LEDS = 4       //! Number of LEDs
)
(
    // Ports
    output [NB_LEDS-1:0] o_led, //! LEDs

    input i_valid,              //! Valid signal to produce shift
    input i_reset,              //! Reset **active high**
    input clock                 //! System clock
);

// var
reg [NB_LEDS-1:0] shiftreg;     //! Shift register

//! Describes the behavior of the shift register
always @(posedge clock) begin: shift_register
    if (i_reset) begin
        shiftreg <= {{NB_LEDS-1{1'b0}}, 1'b1};
    end
    else if (i_valid) begin
        shiftreg <= {shiftreg[NB_LEDS-2:0], shiftreg[NB_LEDS-1]};
    end
    else begin
        shiftreg <= shiftreg;
    end
end

//! Output to LEDs
assign o_led = shiftreg;
    
endmodule // shiftreg