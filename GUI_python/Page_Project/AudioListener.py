'''
pyAudio bullshit
import pyaudio
import sys

chunk = 512
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 44100
RECORD_SECONDS = 5

p = pyaudio.PyAudio()

stream = p.open(format=FORMAT,
                channels=CHANNELS, 
                as_loopback = True,
                rate=RATE, 
                input=True,
                output=True,
                frames_per_buffer=chunk)


file = open('bytes.txt', 'w')
print("* recording")
for i in range(0, int(44100 / chunk * RECORD_SECONDS)):
    data = stream.read(chunk)
    print('length(data): '+str(len(data)))
    for b in data :
        file.write(str(b)+', ')
    # check for silence here by comparing the level with 0 (or some threshold) for 
    # the contents of data.
    # then write data or not to a file

file.close()
print ("* done")

stream.stop_stream()
stream.close()
p.terminate()
'''
import math
import numpy as np
import sounddevice as sd
sampleRate = 44100
blockSize = 512

#returns th max in an array
def max(data): 
    max = 0
    for x in data :
        if x>max :
            max = x
    return max

#prints the min value in an array
def min(data):
    min = data[0]
    for i in data :
        if i<min :
            min = i
    return min

def callback(indata, frames, time, status):
        if status:
            print('status: '+str(status))
        if any(indata):
            #in data is an array of floats in the range(-1,1)
            #with length 512
            print('indata: max = '+str(max(indata))+' min = '+ str(min(indata)))
            print('length: ' +str(len(indata)))
        else:
            print('no input')

with sd.InputStream(device=2, channels=1, callback=callback,
                        blocksize=blockSize,
                        samplerate=sampleRate):
    while True:
            response = input()
            if response in ('', 'q', 'Q'):
                exit()