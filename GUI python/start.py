import tkinter as tk
import subprocess
#subprocess.check_output(['ls','-l']) #all that is technically needed...
#str = subprocess.check_output(['ls','-l'])
#str = subprocess.check_output(["echo", "Hello World!"])
output =subprocess.Popen('chuck C:\\Users\\Calvin\\Documents\\Chuck-Scripts\\Tools\\virtual_keyboard.ck:70:1:63', shell=True, stdout=subprocess.PIPE, bufsize=2, universal_newlines=True)

print('out: ' +output.stdout.read())
""""
output =subprocess.Popen('cd C:\\Users\\Calvin\\Documents\\Chuck-Scripts\\Tools', shell=True, stdout=subprocess.PIPE)
print(output.stdout.read())

output = subprocess.Popen('cd',shell=True, stdout=subprocess.PIPE)
print(output.stdout.read())
"""
def write_slogan():
    print("Tkinter is easy to use!")

root = tk.Tk()
frame = tk.Frame(root)
frame.pack()

button = tk.Button(frame,
                   text="QUIT",
                   fg="red",
                   command=quit)
button.pack(side=tk.LEFT)
slogan = tk.Button(frame,
                   text="Hello",
                   command=write_slogan)
slogan.pack(side=tk.LEFT)

root.mainloop()
