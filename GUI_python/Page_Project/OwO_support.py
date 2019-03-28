#! /usr/bin/env python
#  -*- coding: utf-8 -*-
#
# Support module generated by PAGE version 4.21
#  in conjunction with Tcl version 8.6
#    Mar 28, 2019 03:18:12 PM EDT  platform: Windows NT

import sys
import printVars

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
    printVars.init()
    '''
    set up trace functions
    '''

    synth_Volume.trace('w',printVars.trace('SynthVolume', synth_Volume.get()))
    synth_Attack.trace('w',printVars.trace('attack', synth_Attack.get()))
    synth_Delay.trace('w',printVars.trace('delay', synth_Delay.get()))
    synth_Sustain.trace('w',printVars.trace('sustain', synth_Sustain.get()))
    synth_Release.trace('w',printVars.trace('release', synth_Release.get()))



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




