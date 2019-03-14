import os
import sys

rootdir = '.'

for folder, subs, files in os.walk(rootdir):
    with open(os.path.join(folder, 'python-outfile.txt'), 'w') as dest:
        for filename in files:
            with open(os.path.join(folder, filename), 'r') as src:
                dest.write(src.read())

'''
import os
recursive = True
if recursive :
    itemNames = os.listdir('.')
    for i in itemNames :
        if os.path.isfile(i) :
            print('"'+f+'"')
    print('not recursive (yeet)')
else :
    files = [f for f in os.listdir('.') if os.path.isfile(f)]
    for f in files:
        print('"'+f+'"')
    
'''