#set text(lang: "es")

_Diseño Digital Avanzado 2025_

= Guía Práctica 1

- Autor: Gonzalo G. Fernandez _\<fernandez.gfg\@gmail.com\>_
- Fecha: #datetime.today().display("[day]/[month]/[year]")

== Ejercicio 1

- Escribir el código Verilog para implementar el diseño de la @fig:gp01-ex1-diagram considerando reset asíncrono.
- Generar la señal de reset apropiada para el registro de realimentación utilizado en el diseño.
- Escribir un testbench que permita verificar el correcto funcionamiento del circuito propuesto. Los estímulos pueden ser generados con python o modelados en el testbench.
- Cuantos ciclos de reloj son necesarios para que el registro o data produzca overflow cuando _i\_sel_, _i\_data1_ e _i\_data2_ son iguales a 1?

#figure(
  image("../imgs/gp01-ex1-diagram.png", width: 65%),
  caption: [Diseño digital a nivel RTL con registro de realimentación.],
) <fig:gp01-ex1-diagram>

En el @lst:gp01-ex1-code se observa la implementación en Verilog del diagrama expuesto en la @fig:gp01-ex1-diagram.

En la @fig:gp01-ex1-rtl-schematic se observa el esquemático RTL obtenido a partir de la implementación del @lst:gp01-ex1-code.

#figure(
  image("../imgs/gp01-ex1-rtl_schematic.png"),
  caption: [Esquemático obtenido de análisis RTL en Vivado.],
) <fig:gp01-ex1-rtl-schematic>

Se implementó el _test bench_ para la evaluación del módulo implementado, que resulta en la simulación de comportamiento de la @fig:gp01-ex1-sim-behavior.

#figure(
  image("../imgs/gp01-ex1-behavioral_sim.png"),
  caption: [Resultado de la simulación de comportamiento con el _test bench_ desarrollado.],
) <fig:gp01-ex1-sim-behavior>

Como se observa en la @fig:gp01-ex1-sim-behavior, se necesitan *32 ciclos de reloj* para obtener un _overflow_ cuando _i\_data1_, _i\_data2_ y _i\_sel_ son iguales a 1.

#figure(
  block(
    ```verilog
    module gp01_ex1 (
        output [5:0] o_data,     //! Data output
        output       o_overflow, //! Sum overflow flag
        input [2:0] i_data1,  //! Input data 1
        input [2:0] i_data2,  //! Input data 2
        input [1:0] i_sel,    //! Sum input selection
        input       i_rst_n,  //! Reset **active low**
        input       clk       //! System clock
    );

      reg  [3:0] data_sel;  //! Data selection for sum input
      wire [3:0] data1_w_zero;
      wire [3:0] data2_w_zero;
      reg  [6:0] sum_result;

      assign data1_w_zero = {1'b0, i_data1};
      assign data2_w_zero = {1'b0, i_data2};

      always @(*) begin : data_selection
        case (i_sel)
          2'b00:   data_sel = data2_w_zero;
          2'b01:   data_sel = data1_w_zero + data2_w_zero;
          2'b10:   data_sel = data1_w_zero;
          2'b11:   data_sel = {4{1'b0}};
          default: data_sel = {4{1'b0}};
        endcase
      end

      always @(posedge clk) begin : data_valid
        if (~i_rst_n) begin
          sum_result <= {7{1'b0}};
        end else begin
          sum_result <= {1'b0, sum_result[5:0]} + {{3'b000}, data_sel};
        end
      end

      assign o_data = sum_result[5:0];
      assign o_overflow = sum_result[6];

    endmodule
    ```,
  ),
  caption: [Implementación en Verilog de ejercicio 1 GP01.],
) <lst:gp01-ex1-code>
