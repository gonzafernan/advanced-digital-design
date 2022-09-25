# -*- coding: utf-8 -*-
"""
Created on Mon May 02 10:36:09 2016

@author: batura
"""
#
## <codecell>
#"""El siguiente ejemplo muestra resumidamente como vamos a usar la clase con las nuevas modificaciones realizadas
#   Esten atentos a los detalles que se han cambiado y a las nuevas funciones
#"""
import math
import numpy as np
from tool._fixedInt import *

# <codecell>
"""Definicion de los objetos de la clase DeFixedInt. Atentos a la nueva definicion
Ejemplo: DeFix_object=DeFixedInt(intWidth=15, fractWidth=15, signedMode = 'S', roundMode='trunc', saturateMode='saturate')

-->intWidth=Numero Entero Positivo. Cantidad de bits totales de la palabra. Por defecto 0
-->fractWidth=Numero Entero Positivo. Cantidad de bits fraccionales de la palabra. Por defecto 15
-->signedMode= 'S' (signado) o 'U' (no signado). Por defecto 'S'
-->roundMode= 'trunc' (truncado) o 'round' (redondeo). Ajuste de resolucion. Por defecto 'trunc'
-->satureMode= 'saturate' (saturado) o 'wrap' (overflow). Ajuste de rango. Por defecto 'saturate'

Nota: Noten que ya no se define mas value=0 o como se ponia antes DeFix_object=DeFixedInt(4,2,0,'trunc','saturate)  
"""

b=DeFixedInt(4,2) # Definicion objeto DeFixedInt con signedMode, roundMode y saturateMode por defecto

a=DeFixedInt(roundMode='trunc',signedMode = 'S',intWidth=4,fractWidth=2,saturateMode='saturate') # Definicion completa de un objeto de la clase con la posicion de los parametros cambiada

c_static=DeFixedInt(4,2,'S','round','saturate') # Definicion completa de un objeto de la clase respetando posicion de los parametros

# <codecell>
"""
Modo de Uso de las funciones y atributos principales de la clase.

Habiendo definido los objetos de la clase (a, b y c_static) se le otorgan a estos los mismos atributos y metodos (en cuanto funcionalidad).

ATRIBUTOS PRINCIPALES: forma de llamar--> DeFix_object.atributo
--> .value= Flotante. Atributo. 
            Al escribirlo se carga el valor flotante que se quiere fixear. Si se quiere cargar un entero castearlo con float.
            Al leerlo devuelve el entero signado representativo del flotante. Como debe ser un flotante, si queremos 
            asignarle, por ejemplo, un 75, deberá ingresarse como 75.0
--> .fValue: Atributo. 
             Devuelve el valor fixeado del flotante que se pasa a .value, respetando los parametros del objeto 
             de la clase (intWidth=0, fractWidth=15,signedMode = 'S', roundMode='trunc', saturateMode='saturate').
--> .intvalue: Atributo. 
               Devuelve el entero no signado representativo del flotante. Este es el que se usa en Verilog.
--> .intWidth: Atributo. 
               Devuelve la cantidad de bits de parte ENTERA+SIGNO definidos para el objeto
--> .fractWidth: Atributo. 
                 Devuelve la cantidad de bits de FRACCIONALES definidos para el objeto
--> .width: Atributo. 
            Devuelve la cantidad de bits TOTALES definidos para el objeto = .intWidth+.fractWidth

Nota: todos los antributos anteriores, a excepcion de .value, son privados. Solo pueden ser llamadas, no modificados.

FUNCIONES PRICIPALES: forma de llamar--> DeFix_object.funcion(parametros)
--> .showRange(): muestra los limites de la representacion de un posible flotante asignado al objeto 
--> .showValueRange(): muestra los valores que puede representar el objeto segun sus caracteristicas de resolucion dada. A su vez indica
                       el entero no signado para cada valor (el que se usa en Verilog)  
--> .assign(parametro). Parametro = objeto DefixedInt. Asigna el atributo .fValue del objeto-parametro al objeto de la clase
                        que llama a la funcion, mateniendo las caracteristicas de este último.

PARA DESTACAR:
Con las nuevas modificaciones es posible realizar la SUMA (a+b), RESTA (a-b) y MULTIPLICACION (a*b) entre dos objetos de la clase, generando un
nuevo objeto de la clase con caracteristicas que lo conviertan SIEMPRE en la version FULL RESOLUTION del resultado 
de las operaciones anteriores.
También pueden realizarse operaciones lógicas entre objetos de la clase, es decir, siendo a y b objetos de la
clase DeFixedInt devuleven un objeto c tal que:
1) c=a|b: OR  
2) c=a&b: AND 
3) c=a^b: XOR
Por último exiten comparadores entre objetos que devulven True o False:
1) c= a==b
2) c= a!=b
3) c= a<=b
4) c= a>=b
5) c= a>b
6) c= a<b

"""
"""
EJEMPLO

"""

a.value=1.75 #Cargo el valor flotante a fixear al objeto a
print("\nPara a: ")
print('Float: %f|'%a.fValue,'NBI: %d|'%a.intWidth,'NBF: %d|'%a.fractWidth,'NB: %d|'%a.width)
print("\nEntero Equivalente")
print('Int: %d|'%a.intvalue,'Bin: ',bin(a.intvalue))
print("\n----> Rango de a: ",a.showRange())

"""
PRINT DEL OBJETO a

Para a: 
Float: 1.750000| NBI: 2| NBF: 2| NB: 4|

Entero Equivalente
Int: 7| Bin:  0b111

----> Rango de a:  S(4, 2):  -2.0000000000 ... 1.7500000000
"""


b.value=0.25 #Cargo el valor flotante a fixear al objeto b
print("\nPara b: ")
print('Float: %f|'%b.fValue,'NBI: %d|'%b.intWidth,'NBF: %d|'%b.fractWidth,'NB: %d|'%b.width)
print('\nEntero Equivalente')
print('Int: %d|'%b.intvalue,'Bin: ',bin(b.intvalue))
print("\n----> Rango de b: ", b.showRange())

"""
PRINT DEL OBJETO a

Float: 0.250000| NBI: 2| NBF: 2| NB: 4|

Entero Equivalente
Int: 1| Bin:  0b1

----> Rango de b:  S(4, 2):  -2.0000000000 ... 1.7500000000
"""


c_var=a+b #Operacion matematica para FULL RESOLUTION.
print("\nPara c_var: ")
print('Float: %f|'%c_var.fValue,'NBI: %d|'%c_var.intWidth,'NBF: %d|'%c_var.fractWidth,'NB: %d|'%c_var.width)
print('\nEntero Equivalente')
print('Int: %d|'%c_var.intvalue,'Bin: ',bin(c_var.intvalue))
print("\n----> Rango de c_var: ", c_var.showRange())

"""
PRINT DEL OBJETO c_var FULL RESOLUTiON

Para c_var: 
Float: 2.000000| NBI: 3| NBF: 2| NB: 5|

Entero Equivalente
Int: 8| Bin:  0b1000

----> Rango de c_var:  S(5, 2):  -4.0000000000 ... 3.7500000000
"""

c_static.assign(a+b) #Operacion matematica mateniendo las caracteristicas del objeto c_static. Se aplica WRAP. Debido a que
                     #a+b supera el rango de c_static por una cierta cantidad de pasos (uno en este caso,0.25), 
                     #lo lleva a un valor dentro de su rango definido por la CANTIDAD de pasos que supera el limite inferior o superior
print("\nPara c_static: ")
print('Float: %f|'%c_static.fValue,'NBI: %d|'%c_static.intWidth,'NBF: %d|'%c_static.fractWidth,'NB: %d|'%c_static.width)
print('\nEntero Equivalente')
print('Int: %d|'%c_static.intvalue,'Bin: ',bin(c_static.intvalue))
print("\n----> Rango de c_static: ", c_static.showRange())
print("\n----> Rango de c_static: ",c_static.showValueRange())

"""
PRINT DEL OBJETO c_static

Float: 1.750000| NBI: 2| NBF: 2| NB: 4|

Entero Equivalente
Int: 7| Bin:  0b111

----> Rango de c_static:  S(4, 2):  -2.0000000000 ... 1.7500000000


----> Rango de c_static:  

     FLOTANTE    ENTERO PARA VERILOG
i: -2.000000 --> 8
i: -1.750000 --> 9
i: -1.500000 --> 10
i: -1.250000 --> 11
i: -1.000000 --> 12
i: -0.750000 --> 13
i: -0.500000 --> 14
i: -0.250000 --> 15
i: 0.000000 --> 0
i: 0.250000 --> 1
i: 0.500000 --> 2
i: 0.750000 --> 3
i: 1.000000 --> 4
i: 1.250000 --> 5
i: 1.500000 --> 6
i: 1.750000 --> 7
"""

"""
DEFINICION DE UN ARRAY DE OBJETOS DE LA CLASE DEFIXEDINT

Una función muy útil es arrayFixedInt() definida a continuación:

arrayObjetos = arrayFixedInt(intWidth, fractWidth, N, signedMode='S', roundMode='trunc', saturateMode='saturate')

-->intWidth=Numero Entero Positivo. Cantidad de bits totales de la palabra. Por defecto 0
-->fractWidth=Numero Entero Positivo. Cantidad de bits fraccionales de la palabra. Por defecto 15
-->N= es el array de número que se desee fixear
-->signedMode= 'S' (signado) o 'U' (no signado). Por defecto 'S'
-->roundMode= 'trunc' (truncado) o 'round' (redondeo). Ajuste de resolucion. Por defecto 'trunc'
-->satureMode= 'saturate' (saturado) o 'wrap' (overflow). Ajuste de rango. Por defecto 'saturate'

De esta manera la función crea/devuelve un ARRAY de objetos de la clase DeFixedInt, cada uno con las mismas características definidas
en la función. A su vez cada objeto del array posee los atributos individuales de la clase  

"""
"""
EJEMPLO

"""
N = np.arange(1,50,0.25)
arrayObjetos = arrayFixedInt(3, 1, N, signedMode='S', roundMode='round', saturateMode='wrap')

for ptr in range(len(N)):
    print(N[ptr],'\t',arrayObjetos[ptr].fValue)
    
print("\nPara arrayObjetos[35]: ")
print('Float: %f|'%arrayObjetos[35].fValue,'NBI: %d|'%arrayObjetos[35].intWidth,'NBF: %d|'%arrayObjetos[35].fractWidth,'NB: %d|'%arrayObjetos[35].width)
print('\nEntero Equivalente')
print('Int: %d|'%arrayObjetos[35].intvalue,'Bin: ',bin(arrayObjetos[35].intvalue))
print("\n----> Rango de arrayObjetos[35]: ", arrayObjetos[35].showRange())
print("\n----> Rango de arrayObjetos[35]: ",arrayObjetos[35].showValueRange())


"""
PRINT DEL OBJETO arrayObketos[35]

Para arrayObjetos[35]: 
Float: -2.000000| NBI: 2| NBF: 1| NB: 3|

Entero Equivalente
Int: 4| Bin:  0b100

----> Rango de arrayObjetos[35]:  S(3, 1):  -2.0000000000 ... 1.5000000000

----> Rango de arrayObjetos[35]:
    FLOTANTE    ENTERO PARA VERILOG
i: -1.500000 --> 5
i: -1.000000 --> 6
i: -0.500000 --> 7
i: 0.000000 --> 0
i: 0.500000 --> 1
i: 1.000000 --> 2
i: 1.500000 --> 3

"""
