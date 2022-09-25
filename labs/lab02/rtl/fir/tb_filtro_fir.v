
//! @title FIR Filter - Testbench
//! @file filtro_fir.v
//! @author Advance Digital Design - Ariel Pola
//! @date 29-08-2021
//! @version Unit02 - Modelo de Implementacion

//! - Fir filter with 4 coefficients 
//! - **i_srst** is the system reset.
//! - **i_en** controls the enable (1) of the FIR. The value (0) stops the systems without change of the current state of the FIR.
//! - Coefficients [-1, 1/2, -1/4, 1/8]

`timescale 1ns/1ps

module tb_filtro_fir ();

  parameter NB_INPUT   = 8; //! NB of input
  parameter NBF_INPUT  = 7; //! NBF of input
  parameter NB_OUTPUT  = 8; //! NB of output
  parameter NBF_OUTPUT = 7; //! NBF of output
  parameter NB_COEFF   = 8; //! NB of Coefficients
  parameter NBF_COEFF  = 7; //! NBF of Coefficients
 
  reg             tb_clk = 1'b1;
  reg             tb_en;
  reg             tb_srst;
  reg  [NB_INPUT-1:0] tb_is_data;

  wire [NB_OUTPUT-1:0] tb_os_data;

  reg             aux_tb_en;
  reg             aux_tb_srst;
  reg  [NB_INPUT-1:0] aux_tb_is_data;

  //! Instance of FIR
  filtro_fir
    #(
      .NB_INPUT   (NB_INPUT), //! NB of input
      .NBF_INPUT  (NBF_INPUT), //! NBF of input
      .NB_OUTPUT  (NB_OUTPUT), //! NB of output
      .NBF_OUTPUT (NBF_OUTPUT), //! NBF of output
      .NB_COEFF   (NB_COEFF), //! NB of Coefficients
      .NBF_COEFF  (NBF_COEFF)  //! NBF of Coefficients
    )
    u_filtro_fir 
      (
        .o_os_data  (tb_os_data),
        .i_is_data  (tb_is_data),
        .i_srst     (tb_srst),
        .i_en       (tb_en),
        .clk        (tb_clk)
      );

  // Clock
  always #20 tb_clk = ~tb_clk;

  always @(posedge tb_clk) begin
    tb_en      <= aux_tb_en;
    tb_srst    <= aux_tb_srst;
    tb_is_data <= aux_tb_is_data;
  end

  // Stimulus
  real i;
  real aux;
  initial begin
    $display("");
    $display("Simulation Started");
    //$dumpfile("./verification/tb_filtro_fir/waves.vcd");
    //$dumpvars(0, tb_filtro_fir);
    #5
    aux_tb_en         = 1'b1;
    aux_tb_srst       = 1'b1;
    #40;
    aux_tb_en         = 1'b1;
    aux_tb_srst       = 1'b0;
    #1000
    for (i=0;i<4000;i=i+1) begin
      aux = $sin(2.0*3.1415926*i/25000.0*1000.0)*(2**NBF_INPUT);
       if(aux > 127.0)
	        aux_tb_is_data = 8'h7F;
       else
	        aux_tb_is_data = aux;
      #40;
    end
    $display("Simulation Finished");
    $display("");
    $finish;
  end

endmodule
