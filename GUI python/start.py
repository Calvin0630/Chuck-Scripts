import UIManager
#from UIManager import *
import ChuckManager
#from ChuckManager import *
'''
import atexit

#an onClose function
def exit_handler():
   
atexit.register(exit_handler)
'''
#start the various managers
print("starting ChucK Manager")
chuck = ChuckManager.ChuckManager()
print("Done\n...\nstarting UI Loop")
ui = UIManager.UIManager(chuck)
print("Done!!")
print('cleaning up...')
chuck.close()
ui.close()
print('bye')


