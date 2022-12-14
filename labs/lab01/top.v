//! @title Switch-controlled shift register with VIO and ILA interface
//! @author Gonzalo G. Fernandez
//! @date 09-03-2022
//! @version Unit01 - Verilog

//! @brief Shift register controlled by switchs and VIO ILA IP Cores interface to work with remote FPGAs server 

// Definitions
`define NB_LEDS     4
`define NB_COUNT    32

module top 
#(
    // Parameters
    parameter NB_LEDS = `NB_LEDS,   //! Number of LEDs
    parameter NB_COUNT = `NB_COUNT  //! Number of bits of the counter
)
(
    // Ports
    output  [NB_LEDS-1:0]   o_led,      //! LEDs
    output  [NB_LEDS-1:0]   o_led_b,    //! RGB LEDs color blue
    output  [NB_LEDS-1:0]   o_led_g,    //! RGB LEDs color green

    input   [3:0]           i_sw,       //! Switchs
    input                   i_reset,    //! Reset **active low**
    input                   clock       //! System clock
);

// var
wire        w_reset;        //! Reset to shiftleds module
wire [3:0]  w_sw;           //! Switchs to shiftleds module

wire        w_vio_sel;      //! Inputs from VIO or physical selector
wire        w_vio_reset;    //! Reset from VIO
wire [3:0]  w_vio_sw;       //! Switchs from VIO

//! Reset selection from VIO or physical
assign w_reset = (w_vio_sel) ? w_vio_reset : i_reset;

//! Switchs selection from VIO or physical
assign w_sw = (w_vio_sel) ? w_vio_sw : i_sw;

//! Shift Register controlled by Switchs
shiftleds
    #(
        .NB_COUNT(NB_COUNT),
        .NB_LEDS(NB_LEDS)
    )
    u_shiftleds (
        .o_led(o_led),
        .o_led_b(o_led_b),
        .o_led_g(o_led_g),
        .i_sw(w_sw),
        .i_reset(w_reset),
        .clock(clock)
    );

//! Virtual Input/Output (VIO) IP Core
vio
    u_vio (
        .clk_0(clock),
        .probe_in0_0(o_led),
        .probe_in1_0(o_led_b),
        .probe_in2_0(o_led_g),
        .probe_out0_0(w_vio_sel),
        .probe_out1_0(w_vio_reset),
        .probe_out2_0(w_vio_sw)
    );

//! Integrated Logic Analyzer (ILA) IP Core
ila
    u_ila (
        .clk_0(clock),
        .probe0_0(o_led)
    );


endmodule