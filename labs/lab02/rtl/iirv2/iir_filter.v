
//! @title IIR Filter
//! @file iir_filter.v
//! @author Advance Digital Design - Ariel Pola
//! @date 21-09-2021
//! @version Unit02 - Modelo de Implementacion

//! - Cascade IIR filter with 3 coefficients  
//! - **i_reset** is the system reset.
//! - **i_sample** Input samples
//! - **o_sample** Output of filter

module iir_filter
    #(
        parameter NB_SAMPLE     = 9,  //! NB of Samples
        parameter NBF_SAMPLE    = 7,  //! NBF of Samples
        parameter NB_COEFF      = 15, //! NB of Coefficients
        parameter NBF_COEFF     = 13, //! NBF of Coefficients
        parameter N_COEFFS      = 3   //! Number of Coefficients
    )
    ( 
      output signed [NB_SAMPLE - 1 : 0]     o_sample,  //! Output samples
      input signed [NB_SAMPLE - 1 : 0] 	    i_sample,  //! Input Smaples
      input [NB_COEFF*N_COEFFS - 1 : 0]     i_coeffsB, //! Input Coeffs B
      input [NB_COEFF*(N_COEFFS-1) - 1 : 0] i_coeffsA, //! Input Coeffs A
      input 				                i_reset,   //! Reset **active high**
      input 				                clock      //! System clock
    );

    localparam NB_DOTB  = NB_SAMPLE  + NB_COEFF;   //! NB of product (B)
    localparam NBF_DOTB = NBF_SAMPLE + NBF_COEFF;  //! NBF of product (B)
    localparam NB_ADDB  = NB_DOTB   + 2;           //! NB of adders (B)
    localparam NBF_ADDB = NBF_DOTB;                //! NBF of adders (B)

    localparam NB_DOTA  = NB_ADDB  + NB_COEFF;     //! NB of product (A)
    localparam NBF_DOTA = NBF_ADDB + NBF_COEFF;    //! NBF of product (A)
    localparam NB_ADDA  = NB_DOTA  + 2;            //! NB of adders (A)
    localparam NBF_ADDA = NBF_DOTA;                //! NBF of adders (A)
    localparam NBI_ADDA = NB_ADDA - NBF_ADDA;      //! NBI of adders (A)

    localparam NB_SAMPLEA  = NB_ADDB;              //! NB of registers (A)
    localparam NBF_SAMPLEA = NBF_ADDB;             //! NBF of registers (A)
    localparam NBI_SAMPLEA = NB_SAMPLEA - NBF_SAMPLEA; //! NBI of registers (A)

    localparam NB_SAT     = NBI_ADDA-NBI_SAMPLEA;   //! NB of Saturation
    localparam NBI_SAMPLE = NB_SAMPLE - NBF_SAMPLE; //! NBF of Saturation
    localparam NB_SAT_OUT = NBI_ADDA-NBI_SAMPLE;    //! NB to check in saturation

    wire signed [NB_COEFF   - 1 : 0] coeffa [N_COEFFS - 1 : 1];    //! Coeffs A 
    wire signed [NB_COEFF   - 1 : 0] coeffb [N_COEFFS - 1 : 0];    //! Coeffs B
    wire signed [NB_DOTB    - 1 : 0] dotb   [N_COEFFS - 1 : 0];    //! Products B
    wire signed [NB_DOTA    - 1 : 0] dota   [N_COEFFS - 1 : 1];    //! Products A
    wire signed [NB_ADDB    - 1 : 0] addb;                         //! Adders B
    wire signed [NB_ADDA    - 1 : 0] adda;                         //! Adders A
    wire signed [NB_SAMPLEA - 1 : 0] adda_trunc;                   //! Adders A Trunc
    wire signed [NB_DOTA    - 1 : 0] addbExpand;                   //! Expand adder A

    reg signed [NB_SAMPLE  - 1 : 0] r_sampleb [N_COEFFS - 1 : 1];  //! Registers B
    reg signed [NB_SAMPLEA - 1 : 0] r_samplea [N_COEFFS - 1 : 1];  //! Registers A


    //! Convert input bus to matrix
    generate
        genvar 			    ptrCoeffa;
        genvar 			    ptrCoeffb;

        for(ptrCoeffb=0;ptrCoeffb<N_COEFFS;ptrCoeffb=ptrCoeffb+1)begin:cb
	        assign coeffb[ptrCoeffb] = i_coeffsB[(ptrCoeffb+1)*NB_COEFF -1 -: NB_COEFF];
        end
        for(ptrCoeffa=0;ptrCoeffa<N_COEFFS-1;ptrCoeffa=ptrCoeffa+1)begin:ca
	        assign coeffa[ptrCoeffa+1] = i_coeffsA[(ptrCoeffa+1)*NB_COEFF -1 -: NB_COEFF];
        end
    endgenerate
	
    //! Products B
    assign dotb[0] = coeffb[0] * i_sample;
    assign dotb[1] = coeffb[1] * r_sampleb[1];
    assign dotb[2] = coeffb[2] * r_sampleb[2];

    //! Adders B
    assign addb = dotb[0] + dotb[1] + dotb[2];

    //! Registers B
    always @(posedge clock) begin: regB
        if(i_reset) begin
            r_sampleb[1] <= {NB_SAMPLE{1'b0}};
            r_sampleb[2] <= {NB_SAMPLE{1'b0}};
        end
        else begin
            r_sampleb[1] <= i_sample;
            r_sampleb[2] <= r_sampleb[1];
        end       
    end

    //! Products A
    assign dota[1] = coeffa[1] * r_samplea[1];
    assign dota[2] = coeffa[2] * r_samplea[2];

    //! Expand adder B
    assign addbExpand = $signed({{NBI_ADDA-NBI_SAMPLEA{addb[NB_ADDB-1]}},addb,{NBF_ADDA-NBF_SAMPLEA{1'b0}}});
   
    //! Adders A
    assign adda       = addbExpand - dota[1] - dota[2];

    //! Trunc A to save value in registers A
    assign adda_trunc = ( ~|adda[NB_ADDA-1 -: NB_SAT+1] || &adda[NB_ADDA-1 -: NB_SAT+1]) ? adda[NB_ADDA-(NBI_ADDA-NBI_SAMPLEA) - 1 -: NB_SAMPLEA] :
                        (adda[NB_ADDA-1]) ? {{1'b1},{NB_SAMPLEA-1{1'b0}}} : {{1'b0},{NB_SAMPLEA-1{1'b1}}};

    //! Registers A
    always @(posedge clock) begin: regA
        if(i_reset) begin
            r_samplea[1] <= {NB_SAMPLEA{1'b0}};
            r_samplea[2] <= {NB_SAMPLEA{1'b0}};
        end
        else begin
            r_samplea[1] <= adda_trunc;
            r_samplea[2] <= r_samplea[1];
        end       
    end

    //! Sat and Trunc - Output
    assign o_sample   = ( ~|adda[NB_ADDA-1 -: NB_SAT_OUT+1] || &adda[NB_ADDA-1 -: NB_SAT+1]) ? adda[NB_ADDA-(NBI_ADDA-NBI_SAMPLE) - 1 -: NB_SAMPLE] :
                        (adda[NB_ADDA-1]) ? {{1'b1},{NB_SAMPLE-1{1'b0}}} : {{1'b0},{NB_SAMPLE-1{1'b1}}};


endmodule
