module top_design(
		  clock
		  );

   // Parameters
   parameter N_PROBE   = 8;

   // Ports
   input                   clock;

   // Vars
   wire                    reset;
   
   wire [8  - 1 : 0] w_signal;
   wire [8  - 1 : 0] w_filtered_signal;
   
   wire [N_PROBE - 1 : 0] w_probe0;
   wire [N_PROBE - 1 : 0] w_probe1;

   signal_generator
     u_signal_generator
       (
	.i_clock(clock),
	.i_reset(~reset),
	.o_signal(w_signal)
	);

  filtro_fir
    u_filtro_fir
      (
       .clk        (clock),
       .i_srst     (~reset),
       .i_en       (1'b1),
       .i_data     (w_signal),
       .o_data     (w_filtered_signal)
       );

   //////////////////////////////////////////
   // Crear los bloque VIO e ILA
   // Descomentar los siguientes modulos
   //////////////////////////////////////////
   
  ilaDDA u_ilaDDA (
    .clk_0   (clock),
    .probe0_0(w_signal),         // Bits: 8
    .probe1_0(w_filtered_signal) // Bits: 8
  );   

  vioDDA u_vioDDA (
    .clk_0       (clock),
    .probe_in0_0 (w_filtered_signal), // Bits: 8
    .probe_out0_0(reset)              // Bits: 1
  );

endmodule

