# encoding: utf-8
import pyaudio
import sys
import numpy as np
import sys  


chunk = 1024
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 44100
RECORD_SECONDS = 5

p = pyaudio.PyAudio()

stream = p.open(format=FORMAT,
                channels=CHANNELS, 
                rate=RATE, 
                input=True,
                output=True,
                frames_per_buffer=chunk)


file = open('bytes.txt', 'w')
print("* recording")
for i in range(0, int(44100 / chunk * RECORD_SECONDS)):
    data = stream.read(chunk)
    print(str(type(data[0])))
    data = np.array(data, dtype=uint8)
    print(str(type(data)))
    data = np.fft.fft(data, n=chunk)
    for b in data :
        file.write(str(b)+', ')
    file.write('\n-----\n')
    # check for silence here by comparing the level with 0 (or some threshold) for 
    # the contents of data.
    # then write data or not to a file

file.close()
print ("* done")

stream.stop_stream()
stream.close()
p.terminate()