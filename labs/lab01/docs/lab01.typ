= Laboratorio 1

== Descripción
El proyecto consiste en la implementación de la arquitectura de la @fig:scheme mediante el uso de Verilog.

#figure(
  image("../imgs/scheme.png", width: 80%),
  caption: [Esquema del diseño a implementar.],
) <fig:scheme>

Los nombres en rojo son puertos.

- _i_reset_ es el reset del sistema, el cual pone a cero el contador e inicializa el shift register (SR).
- _i_sw[0]_ controla el enable (1) del contador. En estado (0) todo se detiene sin alterar el estado actual del contador y del SR.
- El SR se desplaza únicamente cuando el contador llegó a algún límite R0-R3.
- La elección del límite se puede realizar en cualquier momento del funcionamiento mediante _i_sw[2:1]_.
- _i_sw[3]_ elige el color de los LEDs RGB.

== Diseño en Verilog

En la @fig:rtl-schematic se puede observar el esquemático resultante del análisis RTL del diseño realizado.

#figure(
  image("../imgs/rtl_schematic.png"),
  caption: [Forma de onda obtenida mediante simulación de comportamiento.],
) <fig:rtl-schematic>

== Simulación de comportamento

En la @fig:behavioral-sim se puede observar las formas de ondas resultantes de una simulación de comportamiento producida mediante el testbench diseñado.

#figure(
  image("../imgs/behavioral_sim.png"),
  caption: [Forma de onda obtenida mediante ILA ante un trigger al leer estado igual a 4 en LEDs.],
) <fig:behavioral-sim>

== Implementación de módulos VIO e ILA

Se implementan los IP cores _Virtual Input/Output_ (VIO) e _Integrated Logic Analyzer_ (ILA) para utilizarlos como interfaz y trabajar con el servidor remoto de FPGAs.

#figure(image("../imgs/ila_waveform.jpg"), caption: []) <fig:ila-waveform>,
