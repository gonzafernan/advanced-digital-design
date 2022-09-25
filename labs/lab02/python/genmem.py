import numpy as np
import matplotlib.pyplot as plt
from tool._fixedInt import *


N = 1024
temp  = DeFixedInt(8,6, signedMode='S', roundMode='trunc', saturateMode='saturate')

filename = 'mem.hex'

F_noise = 17000     ### <----------------
F_signal = 1500     ### <-----------------
sample_rate = 48000 ### <---------------

def fun_gen(t):
    noise  = 0.5 * np.sin(2*np.pi*F_noise*t)
    data = 1  * np.sin(2*np.pi*F_signal*t)
    signal_gen = data + noise
    return signal_gen 

mem = []

with open(filename, 'w') as f:
    for index in range(N):
        value = fun_gen(index/sample_rate)
        temp.value = value
        mem.append(value)
        f.write("{}\n".format(temp.__hex__()).replace('0x',''))

plt.plot(mem,'bo-')
plt.show()
