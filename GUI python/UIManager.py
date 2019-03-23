'''
UIManager.py manages the user interface. The window iss running inn its own thread
'''

import tkinter as tk
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
        self.chuck = chuck
        for varName in self.chuck.chuckVars :
            UIManager.tkVars[varName] = tk.DoubleVar()
        chuck.settingsThread.start()
        self.UILoop()
    def write_slogan(self):
        print("Tkinter is easy to use!")
    # start is ran in its own thread
    def UILoop(self) :
        self.frame = tk.Frame(self.root)     
        print('UI')
        print(os.getcwd())
        self.synthVolume_slider = tk.Scale(self.root, variable =  self.tkVars["SynthVolume"], label = "SynthVolume", from_ = 1,to = 0, resolution = 0.01) 
        self.synthVolume_slider.pack(side=tk.RIGHT)

        self.synthAttack_slider = tk.Scale(self.root, variable =  self.tkVars["attack"], label = "Attack", from_ = 1,to = 0, resolution = 0.01) 
        self.synthAttack_slider.pack(side=tk.RIGHT)

        self.synthDelay_slider = tk.Scale(self.root, variable =  self.tkVars["delay"], label = "Delay", from_ = 1,to = 0, resolution = 0.01) 
        self.synthDelay_slider.pack(side=tk.RIGHT)

        self.synthSustain_slider = tk.Scale(self.root, variable =  self.tkVars["sustain"], label = "Sustain", from_ = 1,to = 0, resolution = 0.01) 
        self.synthSustain_slider.pack(side=tk.RIGHT)

        self.synthRelease_slider = tk.Scale(self.root, variable =  self.tkVars["release"], label = "Release", from_ = 1,to = 0, resolution = 0.01) 
        self.synthRelease_slider.pack(side=tk.RIGHT)
        self.frame.pack()
        
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

    @staticmethod
    def HelloWorld(cls) :
        print('Hello World!!')
    

    def close(self) :
        #nothing necasary yet
        self.chuck.settingsThreadExitCondition = True

    
    
