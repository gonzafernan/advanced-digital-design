//! @title FIR filter coefficients
//! @author Gonzalo G. Fernandez
//! @date 09-18-2022
//! @version Unit02 - Filters implementation

//! @brief FIR filter coefficients for 15 taps cutoff 8kHz
//! @details To use with filtro_fir.v - Generated with coeff.ipynb

assign coeff[ 0] = 8'h00;
assign coeff[ 1] = 8'hFF;
assign coeff[ 2] = 8'hFF;
assign coeff[ 3] = 8'hFE;
assign coeff[ 4] = 8'h00;
assign coeff[ 5] = 8'h07;
assign coeff[ 6] = 8'h10;
assign coeff[ 7] = 8'h15;
assign coeff[ 8] = 8'h10;
assign coeff[ 9] = 8'h07;
assign coeff[10] = 8'h00;
assign coeff[11] = 8'hFE;
assign coeff[12] = 8'hFF;
assign coeff[13] = 8'hFF;
assign coeff[14] = 8'h00;