`timescale 1ns / 1ps

module testbench_500Hz;

   // Inputs
   reg                 clk, reset;
   reg signed [31:0]   x;
   wire signed [31:0]  y;
   real 	           i;
   real 	           aux;   
   real 	           iptr; 
   reg signed [31:0]   x1;
   real 	           aux1;
   
   // Instantiate the Unit Under Test (UUT)
   iir DUT(
	   .clk (clk),
	   .rst (reset),
	   .x   (x),
	   .y   (y)
	   );

 
   // Generate Clock
   //always #20833 clk = ~clk;   
   always #10 clk = ~clk;   
   
   initial 
     begin
	x1    = 32'd0;
	reset = 1;
	clk   = 0;
	#40;
	reset = 0;
	#40;
	reset = 1;
	#40;
    for (i=0;i<4000;i=i+1) begin  
       aux1 <= (0.5*$sin(2.0*3.1415926*i*15000.0/48000.0)+$sin(2.0*3.1415926*i*1000.0/48000.0))*(2**8);
       x1 <= aux1;
       #20;
	 end
	$display("Simulation Finished");
	$display("");
	$finish;
     end // initial begin

   always@(posedge clk)begin
      if(!reset) begin
         iptr <= 0;
	     aux  <= 0;
         x    <= 0;
      end 
      else begin
         iptr <= iptr + 1;
         aux  <= (0.5*$sin(2.0*3.1415926*iptr*15000.0/48000.0)+$sin(2.0*3.1415926*iptr*1000.0/48000.0))*(2**8);
    	 x    <= aux;
      end
   end
   
endmodule
