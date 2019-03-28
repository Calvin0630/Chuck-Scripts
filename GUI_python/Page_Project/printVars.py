import OwO_support
import threading
import time

def printVars() :
    i=0
    while(i<10) :
        print(str(i))
        print(vars)
        i+=1
        time.sleep(1)
    settingsThread.join()


vars = {}
settingsThread = threading.Thread(target=printVars, args=[])
def init() :
    settingsThread.start()






def callback(name,var) :
    vars[name] = var
