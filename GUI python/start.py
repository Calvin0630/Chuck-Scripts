import UIManager
import ChuckManager
import atexit
'''
#an onClose function
def exit_handler():
   
atexit.register(exit_handler)
'''
#start the various managers
print("starting ChucK Manager")
chuck = ChuckManager.ChuckManager()
print("Done\n...\nstarting UI Manager")
ui = UIManager.UIManager(chuck)
print("Done!!")
print('cleaning up...')
chuck.close()
ui.close()
print('bye')


