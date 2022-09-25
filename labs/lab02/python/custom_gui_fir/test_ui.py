# -*- coding: utf-8 -*-
import sys
import gui
from PIL import Image

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
    # raw = fp.get_sensor_data()





    NBT_Xn = ui.get_NBT_Xn()
    NBF_Xn = ui.get_NBF_Xn()
    NBT_Coeff = ui.get_NBT_Coeff()
    NBF_Coeff = ui.get_NBF_Coeff()
    freq_cutoff = ui.get_cutoff()


    #------------------------------------------------
    # Create a FIR filter and apply it to signal.
    #------------------------------------------------
    # The Nyquist rate of the signal.
    nyq_rate = sample_rate / 2.
    
    # The cutoff frequency of the filter: 6KHz
    cutoff_hz = freq_cutoff
    
    # Length of the filter (number of coefficients, i.e. the filter order + 1)
    numtaps = ui.get_taps()
    
    # Use firwin to create a lowpass FIR filter
    fir_coeff = firwin(numtaps, cutoff_hz/nyq_rate)
    
    # Use lfilter to filter the signal with the FIR filter
    filtered_signal = lfilter(fir_coeff, 1.0, signal_gen)

    # FFT
    fft_filtered_signal = fft(filtered_signal,NFFT)
    fft_filtered_signal = 2.0/NFFT * np.abs(fft_filtered_signal[0:NFFT//2])



    float_w, float_h = freqz(fir_coeff)

    float_angles = 180/np.pi * np.unwrap(np.angle(float_h))
    float_h      = 20 * np.log10(abs(float_h))
    

    fft_signal     = fft(signal,NFFT)
    fft_signal     = 2.0/NFFT * np.abs(fft_signal[0:NFFT//2])
    fft_signal_gen = fft(signal_gen,NFFT)
    fft_signal_gen = 2.0/NFFT * np.abs(fft_signal_gen[0:NFFT//2])
    xfft           = np.linspace(0.0, 1.0/(2.0*t[1]), NFFT//2)

    
    taps= len(fir_coeff)
    init_coeff = np.ones(taps)

    coeff = arrayFixedInt(NBT_Coeff,NBF_Coeff,fir_coeff)
    xn =  arrayFixedInt(NBT_Xn,NBF_Xn,init_coeff)

    value_coeff = [a.fValue for a in coeff]

    fixed_w,fixed_h  = freqz(value_coeff)
    
    fixed_angles = 180/np.pi * np.unwrap(np.angle(fixed_h))
    fixed_h      = 20 * np.log10(abs(fixed_h))    

    ui.plot_freqz([float_w,fixed_w],[float_h,float_angles,fixed_h,fixed_angles])
    ui.plot_phase([float_w/np.pi,fixed_w/np.pi],[float_h,float_angles,fixed_h,fixed_angles])

    fp_filtered = []
    temp = [0.0]*taps

    for value in signal_gen:
        temp.insert(0,value)
        temp.pop()
        for j in range(taps):
            xn[j].value = temp[j]
        Yn = fir_filter(xn,coeff)
        fp_filtered.append(Yn.fValue)

    fft_fp_filtered = fft(fp_filtered,NFFT)
    fft_fp_filtered = 2.0/NFFT * np.abs(fft_fp_filtered[0:NFFT//2])



    ui.plot_coeff(fir_coeff,value_coeff)
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