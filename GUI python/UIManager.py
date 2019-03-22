'''
UIManager.py manages the user interface. The window iss running inn its own thread
'''

import tkinter as tk
import ChuckManager 
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
            self.tkVars[varName] = tk.DoubleVar()
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
        self.synthVolume_slider.pack()
        self.frame.pack()
        
        self.slogan_button = tk.Button(self.frame,
                        text="Hello",
                        command=self.write_slogan)
        self.slogan_button.pack(side=tk.LEFT)


        tk.mainloop()
    
    
    def getChuckVariables(cls) :
        newVars = {}
        for varName in cls.tkVars :
            newVars[varName] = cls.tkVars[varName].get()
        return newVars

    @staticmethod
    def HelloWorld() :
        print('Hello World!!')

    def close(self) :
        #nothing necasary yet
        self.chuck.settingsThreadExitCondition = True

    
    
