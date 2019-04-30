'''
ChuckManager is responsible for running chuck and writing ChucK setting to setting.txt in ..\Tools
Chuck Manager sets setting in a thread that it creates
this script also grabs values directly from the main window
'''
import os
import subprocess
import time
import atexit
import threading
from functools import partial


class ChuckManager :
    def __init__(self, parentWidget) :
        self.parentWidget = parentWidget
        self.number = 0
        #stores the name of the effects and a boolean that determines if chuck should bypass
        self.effectsDict = {
            'lfo': False,
            'delay': False,
            'reverb': False, 
            'chorus': False, 
            'eq': False
        }
        self.parentWidget.lfo_active_Button.clicked.connect(partial(self.toggleEffectBypass,'lfo'))
        self.parentWidget.delay_active_button.clicked.connect(partial(self.toggleEffectBypass,'delay'))
        self.parentWidget.reverb_active_Button.clicked.connect(partial(self.toggleEffectBypass,'reverb'))
        self.parentWidget.chorus_active_Button.clicked.connect(partial(self.toggleEffectBypass,'chorus'))
        self.parentWidget.eq_active_Button.clicked.connect(partial(self.toggleEffectBypass,'eq'))
        self.settingsThread = threading.Thread(target=self.writeToSettings, args=[],daemon=True)
        self.chuckVars = {
            'SynthVolume':  0.1,
            'attack':  0.1,
            'delay':  0.1,
            'sustain':  0.1,
            'release':  0.1,
            'lfoActive':  False,
            'lfoShape':  "",
            'lfoRate':  0.1,
            'lfoDepth':  0.1,
            'delayActive':  False,
            'delayBufSize':  0.1,
            'delayTime':  0.1,
            'reverbActive':  False,
            'reverbMix':  0.1,
            'chorusActive':  False,
            'chorusModFreq':  0.1,
            'chorusModDepth':  0.1,
            'chorusMix':  0.1,
            'eqActive':  False,
            'eqLow':  0.1,
            'eqMidLow':  0.1,
            'eqMid':  0.1,
            'eqHighMid':  0.1,
            'eqHigh':  0.1
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
        self.parentWidget.lfo_rate_dial.setValue(self.chuckVars['lfoRate']*100)
        self.parentWidget.lfo_depth_dial.setValue(self.chuckVars['lfoDepth']*100)
        self.parentWidget.delay_max_dial.setValue(self.chuckVars['delayBufSize']*100)
        self.parentWidget.delay_delay_dial.setValue(self.chuckVars['delayTime']*100)
        self.parentWidget.reverb_mix_dial.setValue(self.chuckVars['reverbMix']*100)
        self.parentWidget.chorus_modFreq_dial.setValue(self.chuckVars['chorusModFreq']*100)
        self.parentWidget.chorus_modDepth_dial.setValue(self.chuckVars['chorusModDepth']*100)
        self.parentWidget.chorus_mix_dial.setValue(self.chuckVars['chorusMix']*100)
        self.parentWidget.eq_low_dial.setValue(self.chuckVars['eqLow']*100)
        self.parentWidget.eq_mid_low_dial.setValue(self.chuckVars['eqMidLow']*100)
        self.parentWidget.eq_mid_dial.setValue(self.chuckVars['eqMid']*100)
        self.parentWidget.eq_high_mid_dial.setValue(self.chuckVars['eqHighMid']*100)
        self.parentWidget.eq_high_dial.setValue(self.chuckVars['eqHigh']*100)

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
        value = float(self.parentWidget.lfo_rate_dial.value())
        self.chuckVars['lfoRate'] = value/100
        value = float(self.parentWidget.lfo_depth_dial.value())
        self.chuckVars['lfoDepth'] = value/100
        value = float(self.parentWidget.delay_max_dial.value())
        self.chuckVars['delayBufSize'] = value/100
        value = float(self.parentWidget.delay_delay_dial.value())
        self.chuckVars['delayTime'] = value/100
        value = float(self.parentWidget.reverb_mix_dial.value())
        self.chuckVars['reverbMix'] = value/100
        value = float(self.parentWidget.chorus_modFreq_dial.value())
        self.chuckVars['chorusModFreq'] = value/100
        value = float(self.parentWidget.chorus_modDepth_dial.value())
        self.chuckVars['chorusModDepth'] = value/100
        value = float(self.parentWidget.chorus_mix_dial.value())
        self.chuckVars['chorusMix'] = value/100
        value = float(self.parentWidget.eq_low_dial.value())
        self.chuckVars['eqLow'] = value/100
        value = float(self.parentWidget.eq_mid_low_dial.value())
        self.chuckVars['eqMidLow'] = value/100
        value = float(self.parentWidget.eq_mid_dial.value())
        self.chuckVars['epMid'] = value/100
        value = float(self.parentWidget.eq_high_mid_dial.value())
        self.chuckVars['eqHighMid'] = value/100
        value = float(self.parentWidget.eq_high_dial.value())
        self.chuckVars['eqHigh'] = value/100
        #get the lfo shape from the buttons
        name =''
        for x in self.parentWidget.lfo_shape_buttons :
            if x.isChecked():
                name = x.text()
        self.chuckVars['lfoShape'] = name
        #print(self.parentWidget.)

    def setChuckVars(self, name, value):
        self.chuckVars[name] = value
    def toggleEffectBypass(self,name) :
        self.effectsDict[name] = not self.effectsDict[name]
        #UPDATE THE CHUCKVARS LIST
        self.chuckVars[name+'Active'] = self.effectsDict[name]
        activeList = []
        for name, value in self.effectsDict.items() :
            if value :
                activeList.append(name)
        self.parentWidget.listView.clear()
        self.parentWidget.listView.addItems(activeList)
    def close(self) :
        self.settingsThreadExitCondition = True
        os.system('chuck --kill')

