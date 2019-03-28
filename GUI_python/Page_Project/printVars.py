import OwO_support
import threading
import time

def printVars() :
    i=0
    while(i<10) :
        #print(vars)
        print(str(i))

        i+=1
        time.sleep(1)
    settingsThread.join()


vars = {}
settingsThread = threading.Thread(target=printVars, args=[])
def init() :
    settingsThread.start()






def trace(name,var) :
    vars[name] = var
