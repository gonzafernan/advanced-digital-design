//! @title Switch-controlled shift register
//! @author Gonzalo G. Fernandez
//! @date 14-09-2025
//! @version Unit01 - Verilog

//! @brief Shift register controlled by switchs
//! @details
//! - **ck_rst** is the system reset, which resets the counter and initializes the shift register
//! - **i_sw[0]** controls the enable (1) of the counter. The value (0) stops the systems whithout change of the current state of the counter and the SR.
//! - The SR is moved only when the counter reached some limit **R0-R3**.
//! - The choice of the limit can be made at any time during operation with **i_sw[2:1]**.
//! - **i_sw[3]** chooses the color of the RGB LEDs.

// Definitions
`define NB_COUNT 32
`define NB_LEDS 4

module shiftleds #(
    parameter NB_COUNT = 32,  //! Number of bits of the counter
    parameter NB_LEDS  = 4    //! Number of LEDs
) (
    output [NB_LEDS-1:0] o_led,    //! LEDs
    output [NB_LEDS-1:0] o_led_b,  //! RGB LEDs color blue
    output [NB_LEDS-1:0] o_led_g,  //! RGB LEDs color green

    input [3:0] i_sw,     //! Switchs
    input       i_reset,  //! Reset **active low**
    input       clock     //! System clock
);

  // var
  wire               w_conn_count_sr;  //! Connection between counter and shift register
  wire [NB_LEDS-1:0] w_led;  //! Connection to LEDs

  // Counter module instantiation
  count #(
      .NB_COUNT(NB_COUNT)
  ) u_count (
      .o_valid(w_conn_count_sr),
      .i_enable(i_sw[0]),
      .i_sel(i_sw[2:1]),
      .i_reset(~i_reset),
      .clock(clock)
  );

  // Shift register module instantiation
  shiftreg #(
      .NB_SHIFTREG(NB_LEDS)
  ) u_shiftreg (
      .o_led  (w_led),
      .i_valid(w_conn_count_sr),
      .i_reset(~i_reset),
      .clock  (clock)
  );

  //! Output to LEDs
  assign o_led   = w_led;
  //! Output to RGB LEDs
  assign o_led_b = (i_sw[3] == 1'b0) ? w_led : {NB_LEDS{1'b0}};
  assign o_led_g = (i_sw[3] == 1'b0) ? {NB_LEDS{1'b0}} : w_led;

endmodule
