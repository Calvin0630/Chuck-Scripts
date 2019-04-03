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
    def __init__(self, parentWidget) :
        self.parentWidget = parentWidget
        self.number = 0
        self.settingsThread = threading.Thread(target=self.writeToSettings, args=[],daemon=True)
        self.chuckVars = {
            'SynthVolume' : 0.7,
            'attack' : 0.1,
            'delay' : 0.1,
            'sustain' : 1,
            'release' : 0.1,
            'reverbActive' : False,
            'reverbMix' : 0,
            'delayActive' : False,
            'delayTime' : 0,
            'delayMax' : 0
        }
        os.system('start chuck -l')
        os.system('chuck + Main.ck:70:.5:69')
        self.settingsFilePath = os.getcwd()+'\\settings.txt'
        self.initUISliders()
        #a boolean that tells the setting thread when it should exit
        self.settingsThreadExitCondition = False
        self.settingsThread.start()
        #must start the settings thread after the UI Manager has been set up

    def writeToSettings(self) :
        while (True) :
            if (self.settingsThreadExitCondition) :
                self.settingsFile.close()
                break
            #update the settings first
            self.updateChuckVars()
            #print('settings: '+str(self.number))
            self.number+=1
            self.settingsFile = open(self.settingsFilePath, 'w')
            
            for x in self.chuckVars : 
                self.settingsFile.write(x+' '+str(self.chuckVars[x])+'\n')

            self.settingsFile.close()
            
            time.sleep(1)
    def initUISliders(self) :
        self.parentWidget.volume_slider.setValue(self.chuckVars['SynthVolume']*100)
        self.parentWidget.attack_slider.setValue(self.chuckVars['attack']*100)
        self.parentWidget.delay_slider.setValue(self.chuckVars['delay']*100)
        self.parentWidget.sustain_slider.setValue(self.chuckVars['sustain']*100)
        self.parentWidget.release_slider.setValue(self.chuckVars['release']*100)

    def updateChuckVars(self) :
        #get the values from the UI sliders
        value = float(self.parentWidget.volume_slider.value())
        self.chuckVars['SynthVolume'] = value/100
        value = float(self.parentWidget.attack_slider.value())
        self.chuckVars['attack'] = value/100
        value = float(self.parentWidget.delay_slider.value())
        self.chuckVars['delay'] = value/100
        value = float(self.parentWidget.sustain_slider.value())
        self.chuckVars['sustain'] = value/100
        value = float(self.parentWidget.release_slider.value())
        self.chuckVars['release'] = value/100

    def close(self) :
        self.settingsThreadExitCondition = True
        os.system('chuck --kill')

