#set text(lang: "es")

_Diseño Digital Avanzado 2026_

= Laboratorio 1

- Autor: Gonzalo G. Fernandez _\<fernandez.gfg\@gmail.com\>_
- Fecha: #datetime.today().display("[day]/[month]/[year]")

== Descripción
El proyecto consiste en la implementación de la arquitectura de la @fig:scheme_vio_ila mediante el uso de Verilog.

#figure(
  image("../imgs/scheme_vio_ila.png", width: 80%),
  caption: [Esquema del diseño a implementar.],
) <fig:scheme_vio_ila>

Los nombres en rojo son puertos.

- _i_reset_ es el reset del sistema, el cual pone a cero el contador e inicializa el shift register (SR).
- _i_sw[0]_ controla el enable (1) del contador. En estado (0) todo se detiene sin alterar el estado actual del contador y del SR.
- El SR se desplaza únicamente cuando el contador llegó a algún límite R0-R3.
- La elección del límite se puede realizar en cualquier momento del funcionamiento mediante _i_sw[2:1]_.
- _i_sw[3]_ elige el color de los LEDs RGB.

En la @fig:scheme_top se observa en detalle la arquitectura de los bloques _count_ y _shiftreg_.

#figure(
  image("../imgs/scheme_top.png", width: 80%),
  caption: [Esquema del diseño a implementar.],
) <fig:scheme_top>

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

Se implementan los IP cores _Virtual Input/Output_ (VIO) e _Integrated Logic Analyzer_ (ILA) para utilizarlos como interfaz y trabajar con el servidor remoto de FPGAs. En la @fig:vio-state y la @fig:ila-waveform se observe el uso de las interfaces gráficas para interacción con los módulos VIO e ILA.

#figure(
  image("../imgs/vio_state.png"),
  caption: [Captura del estado de VIO para generar trigger en ILA.],
) <fig:vio-state>

#figure(
  image("../imgs/ila_waveform.png"),
  caption: [Forma de onda obtenida en ILA.],
) <fig:ila-waveform>
