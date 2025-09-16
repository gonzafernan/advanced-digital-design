
//! @title IIR Filter
//! @file iir_top.v
//! @author Advance Digital Design - Ariel Pola
//! @date 21-09-2021
//! @version Unit02 - Modelo de Implementacion

//! - Cascade IIR filter with 3 coefficients  
//! - **i_reset** is the system reset.
//! - **i_sample** Input samples
//! - **o_sample** Output of filter

module iir_top
    #(
        parameter NB_SAMPLE     = 9,  //! NB of Samples
        parameter NBF_SAMPLE    = 7,  //! NBF of Samples
        parameter NB_COEFF      = 15, //! NB of Coefficients
        parameter NBF_COEFF     = 13, //! NBF of Coefficients
        parameter N_COEFFS      = 3   //! Number of Coefficients
    )
    (
        output signed [NB_SAMPLE - 1 : 0] o_sample, //! Output samples
        input signed  [NB_SAMPLE - 1 : 0] i_sample, //! Input Smaples
        input                             i_reset,  //! Reset **active high**
        input                             clock     //! System clock
    );
    

   wire signed [NB_SAMPLE - 1 : 0] 	  w_sec1_to_sec2; //! Connect Sec1 with Sec2
   wire signed [NB_SAMPLE - 1 : 0] 	  w_sec2_to_sec3; //! Connect Sec2 with Sce3
   wire [NB_COEFF*N_COEFFS - 1 : 0] 	  coeffSec1B; //! Coeffs B Sec1
   wire [NB_COEFF*(N_COEFFS-1) - 1 : 0]   coeffSec1A; //! Coeffs A Sec1
   wire [NB_COEFF*N_COEFFS - 1 : 0] 	  coeffSec2B; //! Coeffs B Sec2
   wire [NB_COEFF*(N_COEFFS-1) - 1 : 0]   coeffSec2A; //! Coeffs A Sec2
   wire [NB_COEFF*N_COEFFS - 1 : 0] 	  coeffSec3B; //! Coeffs B Sec3
   wire [NB_COEFF*(N_COEFFS-1) - 1 : 0]   coeffSec3A; //! Coeffs A Sec3

`include "coeffSec1.v"
`include "coeffSec2.v"
`include "coeffSec3.v"
					
    //! Instance Section 1
    iir_filter
        #(
            .NB_SAMPLE     (NB_SAMPLE),
            .NBF_SAMPLE    (NBF_SAMPLE),
            .NB_COEFF      (NB_COEFF),
            .NBF_COEFF     (NBF_COEFF),
            .N_COEFFS      (N_COEFFS)
        )
        u_iir_filter_sec1
        ( 
            .o_sample (w_sec1_to_sec2),
            .i_sample (i_sample),
            .i_coeffsB(coeffSec1B),
            .i_coeffsA(coeffSec1A),
            .i_reset  (i_reset),
            .clock    (clock)
        );

    //! Instance Section 2
    iir_filter
        #(
            .NB_SAMPLE     (NB_SAMPLE),
            .NBF_SAMPLE    (NBF_SAMPLE),
            .NB_COEFF      (NB_COEFF),
            .NBF_COEFF     (NBF_COEFF),
            .N_COEFFS      (N_COEFFS)
        )
        u_iir_filter_sec2
        ( 
            .o_sample (w_sec2_to_sec3),
            .i_sample (w_sec1_to_sec2),
	        .i_coeffsB(coeffSec2B),
	        .i_coeffsA(coeffSec2A),
            .i_reset  (i_reset),
            .clock    (clock)
        );

    //! Instance Section 3
    iir_filter
        #(
            .NB_SAMPLE     (NB_SAMPLE),
            .NBF_SAMPLE    (NBF_SAMPLE),
            .NB_COEFF      (NB_COEFF),
            .NBF_COEFF     (NBF_COEFF),
            .N_COEFFS      (N_COEFFS)
        )
        u_iir_filter_sec3
        ( 
            .o_sample (o_sample),
            .i_sample (w_sec2_to_sec3),
            .i_coeffsB(coeffSec3B),
            .i_coeffsA(coeffSec3A),
            .i_reset  (i_reset),
            .clock    (clock)
        );


endmodule
