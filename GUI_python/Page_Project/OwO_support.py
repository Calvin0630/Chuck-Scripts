#! /usr/bin/env python
#  -*- coding: utf-8 -*-
#
# Support module generated by PAGE version 4.21
#  in conjunction with Tcl version 8.6
#    Mar 28, 2019 03:18:12 PM EDT  platform: Windows NT

import sys
import ChuckManager


try:
    import Tkinter as tk
except ImportError:
    import tkinter as tk

try:
    import ttk
    py3 = False
except ImportError:
    import tkinter.ttk as ttk
    py3 = True

#initializes tkVars
def set_Tk_var():
    global synth_Volume
    synth_Volume = tk.DoubleVar()
    global synth_Attack
    synth_Attack = tk.DoubleVar()
    global synth_Delay
    synth_Delay = tk.DoubleVar()
    global synth_Sustain
    synth_Sustain = tk.DoubleVar()
    global synth_Release
    synth_Release = tk.DoubleVar()
    global activeEffectPanel
    activeEffectPanel = tk.StringVar()
    activeEffectPanel.set(('Delay','Reverb','LFO','HPF/LPF','Gain','Pan Osc'))
    
    #initialize chuckManager
    global chuck
    chuck = ChuckManager.ChuckManager()

    #set up trace functions
    synth_Volume.trace('w',callback_synth_Volume)
    synth_Attack.trace('w',callback_synth_Attack)
    synth_Delay.trace('w',callback_synth_Delay)
    synth_Sustain.trace('w',callback_synth_Sustain)
    synth_Release.trace('w',callback_synth_Release)

# a function to track the selected value in the effects listbox
# it must be bound to the listbox in OwO.py with the following line of code
# self.effects_ListBox.bind('<<ListboxSelect>>',OwO_support.CurSelet)
def CurSelet(event):
    widget = event.widget
    selection=widget.curselection()
    picked = widget.get(selection)
    #prints the name of the selection
    print(picked)

def init(top, gui, *args, **kwargs):
    global w, top_level, root
    w = gui
    top_level = top
    root = top

def destroy_window():
    # Function which closes the window.
    global top_level
    top_level.destroy()
    top_level = None

if __name__ == '__main__':
    import OwO
    OwO.vp_start_gui()


#callbacks

def callback_synth_Volume(*args) :
    value = float(root.globalgetvar(args[0]))
    #name = root.globalgetvar(args[0]).name
    chuck.chuckVars['SynthVolume'] = value

def callback_synth_Attack(*args) :
    value = float(root.globalgetvar(args[0]))
    #name = root.globalgetvar(args[0]).name
    chuck.chuckVars['attack']=value

def callback_synth_Delay(*args) :
    value = float(root.globalgetvar(args[0]))
    #name = root.globalgetvar(args[0]).name
    chuck.chuckVars['delay']=value

def callback_synth_Sustain(*args) :
    value = float(root.globalgetvar(args[0]))
    #name = root.globalgetvar(args[0]).name
    chuck.chuckVars['sustain']=value

def callback_synth_Release(*args) :
    value = float(root.globalgetvar(args[0]))
    #name = root.globalgetvar(args[0]).name
    chuck.chuckVars['release']=value



