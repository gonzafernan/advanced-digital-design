//! @title FIR Filter
//! @file filtro_fir.v
//! @author Advance Digital Design - Ariel Pola
//! @date 29-08-2021
//! @version Unit02 - Modelo de Implementacion

//! - Fir filter with 4 coefficients 
//! - **i_srst** is the system reset.
//! - **i_en** controls the enable (1) of the FIR. The value (0) stops the systems without change of the current state of the FIR.
//! - Coefficients [-1, 1/2, -1/4, 1/8]

module filtro_fir
  #(
    parameter NB_INPUT   = 8, //! NB of input
    parameter NBF_INPUT  = 7, //! NBF of input
    parameter NB_OUTPUT  = 8, //! NB of output
    parameter NBF_OUTPUT = 7, //! NBF of output
    parameter NB_COEFF   = 8, //! NB of Coefficients
    parameter NBF_COEFF  = 7  //! NBF of Coefficients
  ) 
  (
    output signed [NB_OUTPUT-1:0] o_os_data, //! Output Sample
    input  signed [NB_INPUT -1:0] i_is_data, //! Input Sample
    input                         i_en     , //! Enable
    input                         i_srst   , //! Reset
    input                         clk        //! Clock
  );

  localparam NB_ADD     = NB_COEFF  + NB_INPUT + 2;
  localparam NBF_ADD    = NBF_COEFF + NBF_INPUT;
  localparam NBI_ADD    = NB_ADD    - NBF_ADD;
  localparam NBI_OUTPUT = NB_OUTPUT - NBF_OUTPUT;
  localparam NB_SAT     = (NBI_ADD) - (NBI_OUTPUT);

  //! Internal Signals
  reg  signed [NB_INPUT         -1:0] register [3:1]; //! Matrix for registers
  wire signed [         NB_COEFF-1:0] coeff    [3:0]; //! Matrir for Coefficients
  wire signed [NB_INPUT+NB_COEFF-1:0] prod     [3:0]; //! Partial Products

  //! Coeff = [-1 1/2 -1/4 1/8]
  assign coeff[0] = 8'b1000_0000;
  assign coeff[1] = 8'b0100_0000;
  assign coeff[2] = 8'b1110_0000;
  assign coeff[3] = 8'b0001_0000;

  //! ShiftRegister model
  always @(posedge clk) begin:shiftRegister
    if (i_srst == 1'b1) begin
      register[1] <= {NB_INPUT{1'b0}};
      register[2] <= {NB_INPUT{1'b0}};
      register[3] <= {NB_INPUT{1'b0}};
    end else begin
      if (i_en == 1'b1) begin
        register[1] <= i_is_data;
        register[2] <= register[1];
        register[3] <= register[2];
      end
    end
  end

  //! ShiftRegister model
//   integer ptr1;
//   integer ptr2;
//   always @(posedge clk) begin:shiftRegister
//     if (i_srst == 1'b1) begin
//       for(ptr1=1;ptr1<4;ptr1=ptr1+1) begin:init
//         register[ptr1] <= {NB_INPUT{1'b0}};
//       end
//     end else begin
//       if (i_en == 1'b1) begin
//         for(ptr2=1;ptr2<4;ptr2=ptr2+1) begin:srmove
//           if(ptr2==1)
//             register[ptr2] <= i_is_data;
//           else
//             register[ptr2] <= register[ptr2-1];
//          end   
//       end
//     end
//   end

  //! Products
  assign prod[0] = coeff[0] * i_is_data;
  assign prod[1] = coeff[1] * register[1];
  assign prod[2] = coeff[2] * register[2];
  assign prod[3] = coeff[3] * register[3];

//   generate
//     genvar ptr;
//     for(ptr=0;ptr<4;ptr=ptr+1) begin:mult
//       if (ptr==0) 
//         assign prod[ptr] = coeff[ptr] * i_is_data;
//       else
//         assign prod[ptr] = coeff[ptr] * register[ptr];
//     end
//   endgenerate

  //! Declaration
 wire signed [NB_ADD-1:0] sum      [3:1]; //! Add samples
 //! Adders
 assign sum[1] = prod[0] + prod[1];
 assign sum[2] = sum[1]  + prod[2];
 assign sum[3] = sum[2]  + prod[3];
 // Output
 assign o_os_data = ( ~|sum[3][NB_ADD-1 -: NB_SAT+1] || &sum[3][NB_ADD-1 -: NB_SAT+1]) ? sum[3][NB_ADD-(NBI_ADD-NBI_OUTPUT) - 1 -: NB_OUTPUT] :
                    (sum[3][NB_ADD-1]) ? {{1'b1},{NB_OUTPUT-1{1'b0}}} : {{1'b0},{NB_OUTPUT-1{1'b1}}};

  
//   integer ptr3;
//   reg signed [NB_ADD-1:0] sum;
//   always @(*) begin:accum
//     sum = {NB_ADD{1'b0}};
//     for(ptr3=0;ptr3<4;ptr3=ptr3+1) begin:adder 
//       sum = sum + prod[ptr3];
//     end
//   end
//  // Output
//  assign o_os_data = ( ~|sum[NB_ADD-1 -: NB_SAT+1] || &sum[NB_ADD-1 -: NB_SAT+1]) ? sum[NB_ADD-(NBI_ADD-NBI_OUTPUT) - 1 -: NB_OUTPUT] :
//                     (sum[NB_ADD-1]) ? {{1'b1},{NB_OUTPUT-1{1'b0}}} : {{1'b0},{NB_OUTPUT-1{1'b1}}};


endmodule
