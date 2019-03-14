import UIManager
import ChuckManager
import atexit

#an onClose function
def exit_handler():
    print('My application is ending!')
    #chuck.close()
    ui.close()
atexit.register(exit_handler)

#start the various managers
print("starting UI Manager")
ui = UIManager.UIManager()
print("Done\n...\nstarting ChucK Manager")
chuck = ChuckManager.ChuckManager()
print("Done")


