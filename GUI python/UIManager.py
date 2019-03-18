'''
UIManager.py manages the user interface. The window is running in its own thread
'''

import tkinter as tk
import ChuckManager 
import threading

class UIManager :

    def __init__(self, chuck) :
        self.UILoop()
        self.chuck = chuck
    def write_slogan(self):
        print("Tkinter is easy to use!")
    # start is ran in its own thread
    def UILoop(self) :
        self.root = tk.Tk()

        slider = tk.Scale(self.root, variable = self.setChuckVariable("SynthVolume",get())) 
        slider.pack()
        self.frame = tk.Frame(self.root)
        self.frame.pack()
        
        self.slogan_button = tk.Button(self.frame,
                        text="Hello",
                        command=self.write_slogan)
        self.slogan_button.pack(side=tk.LEFT)


        tk.mainloop()
    
    def setChuckVariable(self, name, value) :
        print('setting '+name+' to '+value)
        self.chuck.chuckVars[name]= value

    def close(self) :
        #nothing necasary yet
        pass

    
    
