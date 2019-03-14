'''
UIManager.py manages the user interface. The window is running in its own thread
'''

import tkinter as tk
import ChuckManager 
import threading

class UIManager :

    def __init__(self) :
        self.UILoop()
    def write_slogan(self):
        print("Tkinter is easy to use!")
    # start is ran in its own thread
    def UILoop(self) :
        self.root = tk.Tk()
        self.frame = tk.Frame(self.root)
        self.frame.pack()
        
        self.slogan_button = tk.Button(self.frame,
                        text="Hello",
                        command=self.write_slogan)
        self.slogan_button.pack(side=tk.LEFT)


        tk.mainloop()
    
    def close(self) :
        #nothing necasary yet
        pass

    
    
