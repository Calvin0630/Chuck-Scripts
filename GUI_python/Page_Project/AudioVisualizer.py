'''
this script listens to and plots audio
'''
import tkinter as tk
import time
import random
import math
import numpy as np
import sounddevice as sd


def init(frame) :
    #the coordinates of the frame are from (-10,0) to (600.200)
    global canvas
    canvas = frame
    frame.create_line(-10,0,600,200)
    data = [x for x in range(600)]
    global threadExitCondition
    threadExitCondition = False
    listenToSpeakers()

def draw(data) :
    canvas.delete(tk.ALL)
    start = time.time()
    '''
    for i in range(len(data)) :
        canvas.create_line(i,100,i,100+int(10*data[i]))
    '''
    canvas.create_line(data)
    end = time.time()
    print('exec took: '+str(start-end)+' seconds')

def listenToSpeakers() :
    sampleRate = 44100
    global blockSize
    blockSize = 512
    with sd.InputStream(device=2, channels=1, callback=callback,
                        blocksize=blockSize,
                        samplerate=sampleRate):
        while not threadExitCondition:
            pass

#a function that is called when the program gets new info from speakers
def callback(indata, frames, time, status):
        if status:
            print('status: '+str(status))
        if any(indata) and len(indata)==blockSize:
            #in data is an array of floats in the range(-1,1)
            #with length 512
            print('indata: max = '+str(max(indata))+' min = '+ str(min(indata)))
            print('length: ' +str(len(indata)))
            #draw(indata)
        else:
            print('no input')