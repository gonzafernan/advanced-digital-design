//! @title Switch-controlled shift register - Testbench
//! @file tb_shiftleds.v
//! @author Advance Digital Design - Ariel Pola
//! @date 14-09-2021
//! @version Advance Digital Design - Lab01

//! @brief Shift Register controlled by Switchs
//! @details 
//! - **ck_rst** is the system reset, which resets the counter and initializes the shiftregister (SR).
//! - **i_sw[0]** controls the enable (1) of the counter. The value (0) stops the systems without change of the current state of the counter and the SR.
//! - The SR is moved only when the counter reached some limit **R0-R3**. 
//! - The choice of the limit can be made at any time during operation with **i_sw[2:1]**.
//! - **i_sw[3]** chooses the color of the RGB LEDs.

// Definitions
`define NB_LEDS 4
`define NB_COUNT 14

`timescale 1ns / 100ps

module tb_shiftleds ();

  // Parameters
  parameter NB_LEDS = `NB_LEDS;  //! Number of LEDs
  parameter NB_COUNT = `NB_COUNT;  //! Number of bits of the counter

  wire [ NB_LEDS-1:0] o_led;  //! LEDs
  wire [ NB_LEDS-1:0] o_led_b;  //! RGB LEDs color blue
  wire [ NB_LEDS-1:0] o_led_g;  //! RGB LEDs color green
  reg  [         3:0] i_sw;  //! Switchs
  reg                 i_reset;  //! Reset
  reg                 clock;  //! System clock

  wire [NB_COUNT-1:0] tb_count;  //! Read internal counter

  //! Read the counter from module
  assign tb_count = tb_shiftleds.u_shiftleds.u_count.counter;

  //! Stimulus by initial
  initial begin : stimulus
    i_sw[0]   = 1'b0;
    clock     = 1'b0;
    i_reset   = 1'b0;
    i_sw[2:1] = 2'b00;
    i_sw[3]   = 1'b0;
    #100 i_reset = 1'b1;

    #100 i_sw[0] = 1'b1;  // Enable counter

    wait (i_sw[2:1] == 2'b10);  // Wait change in reference
    i_sw[3] = 1'b1;

    wait (i_sw[2:1] == 2'b11);  // Wait change in reference
    $finish;
  end

  //! Clock generator
  always #5 clock = ~clock;

  //! Reference switchs stimulus
  always @(negedge o_led[3]) begin
    i_sw[2:1] = i_sw[2:1] + 1'b1;
  end

  //! Instance of shiftleds module
  shiftleds #(
      .NB_LEDS (NB_LEDS),
      .NB_COUNT(NB_COUNT)
  ) u_shiftleds (
      .o_led(o_led),
      .o_led_b(o_led_b),
      .o_led_g(o_led_g),
      .i_sw(i_sw),
      .i_reset(i_reset),
      .clock(clock)
  );

endmodule  // tb_shiftleds
