import numpy.fft  
import numpy

def fft_abs(data) :
    return numpy.abs(numpy.fft.fft(data))