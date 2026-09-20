#set text(lang: "es")

_Diseño Digital Avanzado 2026_

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
  block(```verilog
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
  ```),
  caption: [Implementación en Verilog de ejercicio 1 GP01.],
) <lst:gp01-ex1-code>

== Ejercicio 2

- Realizar el esquemático o diagrama en bloque del datapath de un selector de operaciones que ejecuta las siguientes operaciones aritméticas en paralelo en dos entradas _i\_dataA_ e _i\_dataB_ de tipo signadas de 16 bits y asigne el valor del resultado a una salida _o\_dataC_ de 16 bits.
- La elección de la operación a realizar depende de una señal de control _i\_sel_ de 2 bits.
- Implementar el diseño en Verilog y el testbench para verificar el comportamiento.

Operaciones:
- _o\_dataC_ = _i\_dataA_ + _i\_dataB_
- _o\_dataC_ = _i\_dataA_ - _i\_dataB_
- _o\_dataC_ = _i\_dataA_ & _i\_dataB_
- _o\_dataC_ = _i\_dataA_ | _i\_dataB_

En la @fig:gp01-ex2-diagram se observa el diagrama en bloque realizado para el selector de operaciones.

#figure(
  image("../imgs/gp01-ex2-diagram.png", width: 60%),
  caption: [],
) <fig:gp01-ex2-diagram>

En el @lst:gp01-ex2-code se observa la implementación en Verilog del diagrama expuesto en la @fig:gp01-ex2-diagram.

#figure(
  block(```verilog
  module gp01_ex2 (
      output signed [15:0] o_dataC,  //! Output data C
      input  signed [15:0] i_dataA,  //! Input data A
      input  signed [15:0] i_dataB,  //! Input data B
      input         [ 1:0] i_sel,    //! Operation selection
      input                clk       //! System clock
  );

    reg signed [15:0] data_sel;

    always @(posedge clk) begin : operation_selection
      case (i_sel)
        2'b00:   data_sel <= i_dataA + i_dataB;
        2'b01:   data_sel <= i_dataA - i_dataB;
        2'b10:   data_sel <= i_dataA & i_dataB;
        2'b11:   data_sel <= i_dataA | i_dataB;
        default: data_sel <= {16{1'b0}};
      endcase
    end

    assign o_dataC = data_sel;

  endmodule
  ```),
  caption: [Implementación en Verilog de ejercicio 2 GP01.],
) <lst:gp01-ex2-code>

En la @fig:gp01-ex2-rtl-schematic se observa el esquemático RTL obtenido a partir de la implementación del @lst:gp01-ex2-code.

#figure(
  image("../imgs/gp01-ex2-rtl_schematic.png"),
  caption: [Esquemático obtenido de análisis RTL en Vivado.],
) <fig:gp01-ex2-rtl-schematic>

Se implementó el _testbench_ para la implementación del @lst:gp01-ex2-code en el archivo _tb_gp01_ex2.py_ utilizando _cocotb_.

== Ejercicio 3
Dibuje el esquemático para el siguiente código Verilog. Especifique de forma clara los tamaños de datos para todos los cables y muestre multiplexores, registros y señales de clock y reset.

#figure(
  block(```verilog
  module test_module (

      input [31:0] x0,
      input [1:0] sel,
      input clk,
      input rst_n,
      output reg [31:0] y0
  );

    reg [31:0] x1, x2, x3;
    reg  [31:0] y1;
    wire [31:0] out;

    assign out = (x0 + x1 + x2 + x3 + +y1) >>> 2;

    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        x1 <= 0;
        x2 <= 0;
        x3 <= 0;
      end else if (sel == 2'b00) begin
        x3 <= x2;
        x2 <= x1;
        x1 <= x0;
      end else if (sel == 2'b01) begin
        x3 <= x1;
        x2 <= x0;
        x1 <= x2;
      end else begin
        x3 <= x3;
        x2 <= x2;
        x1 <= x0;
      end
    end

    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        y1 <= 0;
        y0 <= 0;
      end else begin
        y1 <= y0;
        y0 <= out;
      end
    end

  endmodule
  ```),
  caption: [Implementación en Verilog de ejercicio 2 GP01.],
) <lst:gp01-ex3-code>


En la @fig:gp01-ex3-diagram se observa el diagrama en bloque realizado para el selector de operaciones.

#figure(
  image("../imgs/gp01-ex3-diagram.png", width: 90%),
  caption: [],
) <fig:gp01-ex3-diagram>

