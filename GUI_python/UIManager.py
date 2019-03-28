'''
UIManager.py manages the user interface. The window iss running inn its own thread
'''

import tkinter as tk
from tkinter import ttk
import ChuckManager 
#from ChuckManager import *
import threading
import os

class UIManager :
    #a dict of UI variables
    #varName (see ChuckMAnager) -> UIvariable of type tk.DoubleVar()
    tkVars = {}
    def __init__(self, chuck) :
        self.root = tk.Tk()
        self.root.title('UwU')
        self.root.geometry('500x500')
        self.chuck = chuck
        for varName in self.chuck.chuckVars :
            UIManager.tkVars[varName] = tk.DoubleVar()
        chuck.settingsThread.start()
        #set up the visualizer
        self.initVisualizer()
        
        #set up the various Main tabs
        self.nb = ttk.Notebook(self.root)
        self.nb.grid(row=1, column=0, columnspan=50, rowspan=49, sticky='NESW')
        self.synth_tab = ttk.Frame(self.nb)
        self.nb.add(self.synth_tab, text='Synthesizer')
        self.sampler_tab = ttk.Frame(self.nb)
        self.nb.add(self.sampler_tab, text='Samples')
        
        self.UILoop()
    def write_slogan(self):
        print("Tkinter is easy to use!")
    # start is ran in its own thread
    def UILoop(self) :
        self.frame = tk.Frame(self.root)     
        print('UILoop')
        print(os.getcwd())
        self.initSynthTab(self.synth_tab)

        #self.frame.pack()
        
        self.slogan_button = tk.Button(self.frame,
                        text="Hello",
                        command=self.write_slogan)
        self.slogan_button.pack(side=tk.LEFT)
        tk.mainloop()
    
    
    def getChuckVariables(cls) :
        newVars = {}
        for varName in cls.UIManager.tkVars :
            newVars[varName] = cls.UIManager.tkVars[varName].get()
        return newVars

    def initSynthTab(self, frame) :
        frame.synthVolume_slider = tk.Scale(frame, variable =  self.tkVars["SynthVolume"], label = "SynthVolume", from_ = 1,to = 0, resolution = 0.01, troughcolor = '#f00') 
        frame.synthVolume_slider.set(self.chuck.chuckVars["SynthVolume"])
        #frame.synthVolume_slider.pack(side=tk.RIGHT)
        frame.synthVolume_slider.grid(row=0,column=0)

        frame.synthAttack_slider = tk.Scale(frame, variable =  self.tkVars["attack"], label = "Attack", from_ = 1,to = 0, resolution = 0.01, troughcolor = '#f80') 
        frame.synthAttack_slider.set(self.chuck.chuckVars["attack"])
        #frame.synthAttack_slider.pack(side=tk.RIGHT)
        frame.synthAttack_slider.grid(row=1,column=0)

        frame.synthDelay_slider = tk.Scale(frame, variable =  self.tkVars["delay"], label = "Delay", from_ = 1,to = 0, resolution = 0.01, troughcolor = '#ff0') 
        frame.synthDelay_slider.set(self.chuck.chuckVars["delay"])
        #frame.synthDelay_slider.pack(side=tk.RIGHT)
        frame.synthDelay_slider.grid(row=1,column=1)

        frame.synthSustain_slider = tk.Scale(frame, variable =  self.tkVars["sustain"], label = "Sustain", from_ = 1,to = 0, resolution = 0.01, troughcolor = '#0f0') 
        frame.synthSustain_slider.set(self.chuck.chuckVars["sustain"])
        #frame.synthSustain_slider.pack(side=tk.RIGHT)
        frame.synthSustain_slider.grid(row=1,column=2)

        frame.synthRelease_slider = tk.Scale(frame, variable =  self.tkVars['release'], label = "Release", from_ = 1,to = 0, resolution = 0.01, troughcolor = '#00f') 
        frame.synthRelease_slider.set(self.chuck.chuckVars["release"])
        #frame.synthRelease_slider.pack(side=tk.RIGHT)
        frame.synthRelease_slider.grid(row=1,column=3)

        #create windows for effects
        frame.effectsWindow = tk.PanedWindow(frame)
        frame.effectsWindow.mainLabel = tk.Label(frame.effectsWindow, text='Effects:')
        frame.effectsWindow.add(frame.effectsWindow.mainLabel)
        frame.effectsWindow.grid(row=2, column=0)
        #a Dict of effects: string to PanedWindow (panels)
        #panels contain the sliders and button for their effect
        frame.effectsWindow.effectsPanels = {'LFO': tk.PanedWindow(frame.effectsWindow), 
            'delay': tk.PanedWindow(frame.effectsWindow), 
            'PAN OSC': tk.PanedWindow(frame.effectsWindow),
            'gain': tk.PanedWindow(frame.effectsWindow), 
            'reverb': tk.PanedWindow(frame.effectsWindow)
            }
        #add a Slider to change the Mix
        frame.synthReverbSlider = tk.Scale(frame.effectsWindow.effectsPanels['reverb'], variable = self.tkVars['reverbMix'], label = "Mix", from_ = 1,to = 0, resolution = 0.01, troughcolor = '#000')
        frame.synthReverbSlider.set(self.chuck.chuckVars["reverbMix"])
        frame.synthReverbSlider.grid(row=5,column=0)
        
        for key in frame.effectsWindow.effectsPanels :
            #value.grid(row=3,column=0)
            value = frame.effectsWindow.effectsPanels[key]
            effectLabel = tk.Label(value, text = key)
            frame.effectsWindow.effectsPanels[key].add(effectLabel)
            effectLabel.grid(row=3,column=0)
        
        self.activeEffectPanel = tk.StringVar(self.root)
        self.activeEffectPanel.set('LFO')
        self.effectsMenu = tk.OptionMenu(frame.effectsWindow, self.activeEffectPanel, *frame.effectsWindow.effectsPanels)
        self.effectsMenu.grid(row=1,column=0)
        def change_dropdown(*args):
            #frame.effectsWindow.add(frame.effectsWindow.effectsPanels[self.activeEffectPanel.get()])
            print( self.activeEffectPanel.get() )

        self.activeEffectPanel.trace('w',change_dropdown)
    
    def initVisualizer(self) :
        print('init Visualizer')
        self.visualizerCanvas = tk.Canvas(self.root)
        self.visualizerCanvas.create_polygon(0,0,0,10,2,5,3,5,4,70,2,0,9,921,92,830)



    def close(self) :
        #nothing necasary yet except this
        self.chuck.settingsThreadExitCondition = True

    
    
