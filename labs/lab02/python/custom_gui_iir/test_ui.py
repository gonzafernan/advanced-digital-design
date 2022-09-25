# -*- coding: utf-8 -*-
import sys
import gui

from collections import deque


from pyqtgraph.Qt import QtCore, QtGui
import numpy as np
# from PyQt5.QtCore import Qt


from tool._fixedInt import *
from scipy.signal import *
from scipy.fftpack import fft,fftshift

def fir_filter(x,c):
    Xn_Coeff = x * c
    fp_acumulador = Xn_Coeff[0]
    for index in range(1,len(Xn_Coeff)):
        fp_acumulador =  fp_acumulador + Xn_Coeff[index]
    return fp_acumulador

def loop():

    NBT_a = ui.get_NBT_a()
    NBF_a = ui.get_NBF_a()
    NBT_b = ui.get_NBT_b()
    NBF_b = ui.get_NBF_b()

    #------------------------------------------------
    # Create a IIR filter and apply it to signal.
    #------------------------------------------------

    wp = 0.2
    ws = 0.3
    gpass = 1
    gstop = 40

    b,a = iirdesign(wp, ws, gpass, gstop)

    # Get the poles and zeros
    float_z, float_p, float_k = tf2zpk(b,a)

    # Use lfilter to filter the signal with the IIR filter
    filtered_signal = lfilter(b, a, signal_gen)

    # FFT
    fft_filtered_signal = fft(filtered_signal,NFFT)

    # Frequency response
    float_w, float_h = freqz(b, a)

    float_angles = 180/np.pi * np.unwrap(np.angle(float_h))
    float_h      = 20 * np.log10(abs(float_h))
    

    fft_signal     = fft(signal,NFFT)
    fft_signal     = 2.0/NFFT * np.abs(fft_signal[0:NFFT//2])
    fft_signal_gen = fft(signal_gen,NFFT)
    fft_signal_gen = 2.0/NFFT * np.abs(fft_signal_gen[0:NFFT//2])
    xfft           = np.linspace(0.0, 1.0/(2.0*t[1]), NFFT//2)

    
    

    fp_b = arrayFixedInt(NBT_b,NBF_b, b)
    value_b = [aux.fValue for aux in fp_b]
    fp_a = arrayFixedInt(NBT_a,NBF_a, a)
    value_a = [aux.fValue for aux in fp_a]


    # Get the poles and zeros
    fixed_z, fixed_p, fixed_k = tf2zpk(value_b,value_a)

    
    fixed_w,fixed_h  = freqz(value_b,value_a)
    
    fixed_angles = 180/np.pi * np.unwrap(np.angle(fixed_h))
    fixed_h      = 20 * np.log10(abs(fixed_h))    

    ui.plot_freqz([float_w,fixed_w],[float_h,float_angles,fixed_h,fixed_angles])
    ui.plot_phase([float_w/np.pi,fixed_w/np.pi],[float_h,float_angles,fixed_h,fixed_angles])

    fp_filtered = lfilter(value_b, value_a, signal_gen)

    fft_fp_filtered = fft(fp_filtered,NFFT)
    fft_fp_filtered = 2.0/NFFT * np.abs(fft_fp_filtered[0:NFFT//2])

    
    ui.plot_poleszeros(float_p,float_z,True)
    ui.plot_poleszeros(fixed_p,fixed_z,False)

    ui.plot_coeff(b,value_b,a,value_a)
    ui.plot_fft(fft_signal,fft_fp_filtered)
    ui.plot_signals(filtered_signal,fp_filtered)


ui  = gui.gui()


timer = QtCore.QTimer()
timer.timeout.connect(loop)
timer.start(300)


#------------------------------------------------
# Create a signal for demonstration.
#------------------------------------------------
# 320 samples of (1000Hz + 15000 Hz) at 48 kHz


sample_rate = 48000.
nsamples = 320

# FFT
NFFT = 1024
fs = sample_rate


F_1KHz = 1000.
A_1KHz = 1.0
 
F_15KHz = 15000.
A_15KHz = 0.5
 
t = np.arange(nsamples) / sample_rate

noise  = A_15KHz * np.sin(2*np.pi*F_15KHz*t)
signal = A_1KHz  * np.sin(2*np.pi*F_1KHz*t)
signal_gen = signal + noise


## Start Qt event loop unless running in interactive mode or using pyside.
if __name__ == '__main__':
    import sys
    if (sys.flags.interactive != 1) or not hasattr(QtCore, 'PYQT_VERSION'):
        QtGui.QApplication.instance().exec_()