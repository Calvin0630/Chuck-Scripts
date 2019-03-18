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
        self.number = 0
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
        os.chdir('..\\Tools\\')
        os.system('start chuck -l')
        os.system('chuck + Main.ck:70:.5:69')
        self.settingsFilePath = os.getcwd()+'\\settings.txt'
        self.settingsFile = open(self.settingsFilePath, 'w+')
        #a boolean that tells the setting thread when it should exit
        self.settingsThreadExitCondition = False
        self.settingsThread.start()

    def writeToSettings(self) :
        while (True) :
            self.settingsFile = open(self.settingsFilePath, 'w').close()
            self.settingsFile = open(self.settingsFilePath, 'w+')
            print(str(self.number))
            self.number+=1
            print('writing to file')
            for x in self.chuckVars : 
                self.settingsFile.write(x+' '+str(self.chuckVars[x])+'\n')
            if (self.settingsThreadExitCondition) :
                self.settingsFile.close()
                exit()
            time.sleep(1)


    def close(self) :
        self.settingsThreadExitCondition = True
        os.system('chuck --kill')

