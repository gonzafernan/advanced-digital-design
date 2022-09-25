# -*- coding: utf-8 -*-

from pyqtgraph.Qt import QtCore, QtGui
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QApplication, QHBoxLayout, QLabel, QSizePolicy,  \
QSlider, QSpacerItem, QVBoxLayout, QWidget, QGridLayout
from pyqtgraph.dockarea import *

import pyqtgraph as pg
#import pyqtgraph.opengl as gl

import subprocess

import sys

class Slider(QWidget):
    def __init__(self, name, init, minimum, maximum, parent=None):
        super(Slider, self).__init__(parent=parent)

        self.minimum = minimum
        self.maximum = maximum

        self.verticalLayout = QVBoxLayout(self)

        self.label = QLabel(self)
        self.verticalLayout.addWidget(self.label)
        

        self.slider = QSlider(Qt.Vertical)
        self.slider.setMinimum(self.minimum)
        self.slider.setMaximum(self.maximum)
        self.slider.setValue(init)
        # self.sl.setTickPosition(QSlider.TicksBelow)
        # self.sl.setTickInterval(5)
        
        self.verticalLayout.addWidget(self.slider)

        self.lblName = QLabel(self)
        self.verticalLayout.addWidget(self.lblName)
        self.lblName.setText(name)

        self.slider.valueChanged.connect(self.setLabelValue)
        # self.x = None
        self.setLabelValue(self.slider.value())

    def setLabelValue(self, value):
        # self.x = self.minimum + (float(value) / (self.slider.maximum() - self.slider.minimum())) * (
        # self.maximum - self.minimum)
        self.label.setText(str(value))

class gui():
    def __init__(self):
        
        self.app = QtGui.QApplication([])
        self.win = QtGui.QMainWindow()
        self.area = DockArea()
        self.win.setCentralWidget(self.area)
        self.win.resize(1000,500)
        # win.setWindowTitle('pyqtgraph example: dockarea')




        self.d1 = Dock("Coeff")
        self.d2 = Dock("Signals")
        self.d3 = Dock("FFT")
        self.d4 = Dock("Response Filter")
        self.d5 = Dock("Config")


        self.area.addDock(self.d1, 'bottom')
        self.area.addDock(self.d2, 'bottom', self.d1)
        self.area.addDock(self.d3, 'left', self.d2)
        self.area.addDock(self.d4, 'left', self.d1)
        self.area.addDock(self.d5)

        
        self.plot = pg.PlotWidget(title="Coeff")
        self.plot.plotItem.showGrid(True,True)
        self.plot.addLegend()        
        pen1 = pg.mkPen(color=(255, 0, 0), width=2)
        pen2 = pg.mkPen(color=(0, 0, 255), width=2)
        self.figure_coeff1 = self.plot.plot([1,1,1,1,1,1],pen=pen1, symbol='o', symbolSize=5, symbolBrush=('r'),name='float')
        self.figure_coeff2 = self.plot.plot([1,1,1,1,1,1],pen=pen2, symbol='o', symbolSize=5, symbolBrush=('b'),name='fixed')
        self.d1.addWidget(self.plot)


        self.plot = pg.PlotWidget(title="signals")
        self.plot.addLegend()
        self.plot.plotItem.showGrid(True,True)
        pen1 = pg.mkPen(color=(255, 0, 0), width=3, style=QtCore.Qt.DashLine)
        pen2 = pg.mkPen(color=(0, 0, 255), width=3, style=QtCore.Qt.DashLine)
#        self.figure_signals1 = self.plot.plot([1,1,1,1,1,1],pen=pen1, symbol='o', symbolSize=10, symbolBrush=('r'))
#        self.figure_signals2 = self.plot.plot([2,2,2,2,2,2],pen=pen2, symbol='o', symbolSize=10, symbolBrush=('b'))
        self.figure_signals1 = self.plot.plot([1,1,1,1,1,1],pen=pen1,name='float')
        self.figure_signals2 = self.plot.plot([2,2,2,2,2,2],pen=pen2,name='fixed')
        self.d2.addWidget(self.plot)
        
        # self.d3.hideTitleBar()
        self.plot = pg.PlotWidget(title="FFT")
        self.plot.plotItem.showGrid(True,True)
        self.plot.addLegend()
        pen1 = pg.mkPen(color=(255, 0, 0), width=2)
        pen2 = pg.mkPen(color=(0, 0, 255), width=2)        
        self.figure_fft1 = self.plot.plot([1,1,1,1,1,1],pen=pen1,name='float')
        self.figure_fft2 = self.plot.plot([1,1,1,1,1,1],pen=pen2,name='fixed')
        self.d3.addWidget(self.plot)

        self.plot = pg.PlotWidget(title="Frequency Response")
        self.plot.plotItem.showGrid(True,True)
        self.plot.addLegend()
        pen1 = pg.mkPen(color=(255, 0, 0), width=2)
        pen2 = pg.mkPen(color=(0, 0, 255), width=2)        
        self.figure_freqz1 = self.plot.plot([1,1,1,1,1,1],pen=pen1,name='float')
        self.figure_freqz2 = self.plot.plot([1,1,1,1,1,1],pen=pen2,name='fixed')
        self.d4.addWidget(self.plot)
        
        
        self.plot = pg.PlotWidget(title="Phase Response")
        self.plot.addLegend()        
        self.plot.plotItem.showGrid(True,True)
        pen1 = pg.mkPen(color=(255, 0, 0), width=2)
        pen2 = pg.mkPen(color=(0, 0, 255), width=2)        
        self.figure_phase1 = self.plot.plot([1,1,1,1,1,1],pen=pen1,name='float')        
        self.figure_phase2 = self.plot.plot([1,1,1,1,1,1],pen=pen2,name='fixed')
        self.d4.addWidget(self.plot)


        self.widget = QWidget()

        self.QGLRoot = QHBoxLayout()
        self.widget.setLayout(self.QGLRoot)

        self.w1 = Slider('NBT_Xn',4,1, 32)
        self.QGLRoot.addWidget(self.w1)
        self.w2 = Slider('NBF_Xn',2,1, 32)
        self.QGLRoot.addWidget(self.w2)
 
        self.w3 = Slider('NBT_Coeff',4,1, 32)
        self.QGLRoot.addWidget(self.w3)
        self.w4 = Slider('NBF_Coeff',2,1, 32)
        self.QGLRoot.addWidget(self.w4)

        self.w5 = Slider('tapsffset',29,1, 51)
        self.QGLRoot.addWidget(self.w5)

        self.w6 = Slider('cutoff',6000,1, 20000)
        self.QGLRoot.addWidget(self.w6)

        self.d5.addWidget(self.widget)


        self.win.show()

        # self.w1.slider.valueChanged.connect(self.update_plot)
        # self.w2.slider.valueChanged.connect(self.update_plot)
        # self.w3.slider.valueChanged.connect(self.update_plot)
        # self.w4.slider.valueChanged.connect(self.update_plot)

    def get_NBT_Xn(self):
        return (self.w1.slider.value())
    def get_NBF_Xn(self):
        return (self.w2.slider.value())
    def get_NBT_Coeff(self):
        return (self.w3.slider.value())
    def get_NBF_Coeff(self):
        return (self.w4.slider.value())
    def get_taps(self):
        return (self.w5.slider.value())
    def get_cutoff(self):
        return (self.w6.slider.value())

    def plot_coeff(self, data1,data2):
        self.figure_coeff1.setData(data1)
        self.figure_coeff2.setData(data2)

    def plot_signals(self, data1,data2):
        self.figure_signals1.setData(range(len(data1)),data1)
        self.figure_signals2.setData(range(len(data2)),data2)

    def plot_fft(self, data1,data2):
        self.figure_fft1.setData(data1)
        self.figure_fft2.setData(data2)

    def plot_freqz(self, data1,data2):
        
        self.figure_freqz1.setData(data1[0],data2[0])
        self.figure_freqz2.setData(data1[0],data2[2])

    def plot_phase(self, data1,data2):
        self.figure_phase1.setData(data1[0],data2[1])
        self.figure_phase2.setData(data1[0],data2[3])

