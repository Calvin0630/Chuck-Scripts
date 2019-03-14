'''
ChuckManager is responsible for running chuck and writing ChucK setting to setting.txt in ..\Tools
Chuck Manager sets setting in a thread that it creates
'''
import os
import subprocess
import time
import atexit
import threading


class ChuckManager :
    def __init__(self) :
        self.i = 0
        self.settingsThread = threading.Thread(target=self.writeToSettings, args=[])
        self.chuckVars = {
            "SynthVolume" : 0.7,
            "attack" : 0.1,
            "delay" : 0.1,
            "sustain" : 1,
            "release" : 0.1,
            "reverbActive" : 0,
            "reverbMix" : 0,
            "delayActive" : 0,
            "delayTime" : 0,
            "delayMax" : 0,
            "synthRootNote" : 69
        }
        self.settingsThread.start()
        os.chdir('..\\Tools\\')
        os.system('start chuck -l')
        os.system('chuck + Main.ck:70:.5:69')

    def writeToSettings(self) :
        while (True) :
            print(str(self.i)+": "+self.chuckVars)
            self.i+=1
            '''
            for x in self.chuckVars : 
            print(x)
            '''
            time.sleep(1)


    def close(self) :
        self.settingsThread.join()
        os.system('chuck --kill')

