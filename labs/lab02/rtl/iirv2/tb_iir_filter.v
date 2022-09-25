//! @title IIR Filter - Testbench
//! @file tb_iir_filter.v
//! @author Advance Digital Design - Ariel Pola
//! @date 21-09-2021
//! @version Unit02 - Modelo de Implementacion

//! - Cascade IIR filter with 3 coefficients 
//! - **i_reset** is the system reset.
//! - **i_sample** Input samples
//! - **o_sample** Output of filter


`timescale 1ns / 1ps

module tb_iir_filter();
   
   parameter NB_SAMPLE     = 9;  //! NB of Samples
   parameter NBF_SAMPLE    = 7;  //! NBF of Samples
   parameter NB_COEFF      = 15; //! NB of Coefficients
   parameter NBF_COEFF     = 13; //! NBF of Coefficients
   parameter N_COEFFS      = 3;  //! Number of Coefficients
   

   // Inputs
   wire signed [NB_SAMPLE - 1 : 0]  o_sample; //! Output Samples
   reg signed [NB_SAMPLE - 1 : 0]   i_sample; //! Input Samples
   reg 				                  i_reset;  //! Reset
   reg 				                  clock;    //! Clock
   
   reg 				                  reset;    //! Local Reset
   real 			                     i;        //! Pointer to FOR
   real 			                     sinValue; //! Real Value of Sin
   reg signed [NB_SAMPLE - 1 : 0]   dataFp;   //! Fixed Value of Sin
   
   //! Instantiate the Unit Under Test (UUT)
   iir_top
     #(
       .NB_SAMPLE     (NB_SAMPLE),
       .NBF_SAMPLE    (NBF_SAMPLE),
       .NB_COEFF      (NB_COEFF),
       .NBF_COEFF     (NBF_COEFF),
       .N_COEFFS      (N_COEFFS)
       )
   u_iir_top
     (
      .o_sample (o_sample),
      .i_sample (i_sample),
      .i_reset  (i_reset),
      .clock    (clock)
      );
     
   //! Clock Generator
   always #10 clock = ~clock;   

   //! Data register
   always@(posedge clock) begin: regData
      i_sample <= dataFp;
      i_reset  <= reset;
   end
      
   //! Sin generator
   initial 
      begin
         reset   = 1;
         clock   = 0;
         dataFp  = 0;
         #100;
         reset   = 0;
         #100;
         for (i=0;i<4000;i=i+1) begin  
            sinValue = (0.5*$sin(2.0*3.1415926*i*15000.0/48000.0)+$sin(2.0*3.1415926*i*1000.0/48000.0))*(2**NBF_SAMPLE);
            dataFp = sinValue;
            #20;
         end
         $display("Simulation Finished");
         $display("");
         $finish;
   end // initial begin
 

   //! Impulse response generator
   //! UNCOMMENT TO EXECUTE IMPULSE RESPONSE
   // initial 
   //    begin: impulseResponse
   //       reset   = 1;
   //       clock   = 0;
   //       dataFp  = 0;
   //       #100;
   //       reset   = 0;
   //       #100;
   //       for (i=0;i<4000;i=i+1) begin  
   //          if(i==100) begin
   //             sinValue = (1.0)*(2**NBF_SAMPLE);
   //             dataFp = sinValue;
   //          end
   //          else begin
   //             sinValue = (0.0)*(2**NBF_SAMPLE);
   //             dataFp = sinValue;
   //          end
   //          #20;
   //       end
   //       $display("Simulation Finished");
   //       $display("");
   //       $finish;
   // end // initial begin

   //! Step response generator
   //! UNCOMMENT TO EXECUTE STEP RESPONSE
   // initial 
   //    begin: impulseResponse
   //       reset   = 1;
   //       clock   = 0;
   //       dataFp  = 0;
   //       #100;
   //       reset   = 0;
   //       #100;
   //       for (i=0;i<4000;i=i+1) begin  
   //          if(i>=100) begin
   //             sinValue = (1.0)*(2**NBF_SAMPLE);
   //             dataFp = sinValue;
   //          end
   //          else begin
   //             sinValue = (0.0)*(2**NBF_SAMPLE);
   //             dataFp = sinValue;
   //          end
   //          #20;
   //       end
   //       $display("Simulation Finished");
   //       $display("");
   //       $finish;
   // end // initial begin
   
endmodule
