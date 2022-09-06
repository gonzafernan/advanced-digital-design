//! @title Counter module
//! @author Gonzalo G. Fernandez
//! @date 09-02-2022
//! @version Advance Digital Design - Lab01

//! @brief Counter that generates a valid signal when it matches a reference value
//! @details The reference value is chosen between R0-R3 with the **i_sel** signals.

module count 
#(
    // Parameters
    parameter NB_COUNT = 32 //! Number of bits of the counter
)
(
    // Ports
    output  o_valid,        //! Valid signal when counter match reference

    input       i_enable,   //! Counter enable 
    input [1:0] i_sel,      //! Reference selection
    input       i_reset,    //! Reset **active high**
    input       clock       //! System clock
);

// localparam
localparam R0 = (2**(NB_COUNT-10))-1;   //! Limit ref. 23.84Hz @ 100MHz, 32 bit       	
localparam R1 = (2**(NB_COUNT-9))-1;    //! Limit ref. 11.92Hz @ 100MHz, 32 bit
localparam R2 = (2**(NB_COUNT-8))-1;    //! Limit ref. 5.96Hz @ 100MHz, 32 bit
localparam R3 = (2**(NB_COUNT-7))-1;    //! Limit ref. 2.98Hz @ 100MHz, 32 bit

// var
wire    [NB_COUNT-1:0] w_limit_ref;
reg     [NB_COUNT-1:0] counter;
reg                    valid;

assign w_limit_ref =    (i_sel == 2'b00) ? R0 :
                        (i_sel == 2'b01) ? R1 :
                        (i_sel == 2'b10) ? R2 : R3;

//! Descibes the behavior of the counter
always @(posedge clock) begin: counter_ref
    if (i_reset) begin
        counter <= {NB_COUNT{1'b0}};    // on reset count to 0
    end
    else if (i_enable) begin             // TODO: Change i_sw[0] to name enable with assign
        if (counter >= w_limit_ref) begin
            counter <= {NB_COUNT{1'b0}};
            valid   <= 1'b1;
        end
        else begin
            counter <= counter + {{NB_COUNT-1{1'b0}}, {1'b1}};
            valid   <= 1'b0;
        end
    end
    else begin
        counter <= counter;
        valid <= 1'b0;
    end
end

// Output to shift register
assign o_valid = valid;
    
endmodule // count