'''
This is a scipt that prints the else if statements for Sampler.ck
'''
fileNames = ["Cymatics - Acoustic Chord Loop 1 - 140 BPM D Maj.wav", "Cymatics - Acoustic Chord Loop 10 - 160 BPM A Maj.wav", "Cymatics - Acoustic Chord Loop 11 - 180 BPM D# Maj.wav", "Cymatics - Acoustic Chord Loop 12 - 180 BPM E Min.wav", "Cymatics - Acoustic Chord Loop 13 - 180 BPM F# Min.wav", "Cymatics - Acoustic Chord Loop 14 - 180 BPM G Min.wav", "Cymatics - Acoustic Chord Loop 2 - 140 BPM E Maj.wav", "Cymatics - Acoustic Chord Loop 3 - 140 BPM E Maj.wav", "Cymatics - Acoustic Chord Loop 4 - 140 BPM F# Min.wav", "Cymatics - Acoustic Chord Loop 5 - 160 BPM E Maj.wav", "Cymatics - Acoustic Chord Loop 6 - 160 BPM E Min.wav", "Cymatics - Acoustic Chord Loop 7 - 160 BPM G Maj.wav", "Cymatics - Acoustic Chord Loop 8 - 160 BPM G# Min.wav", "Cymatics - Acoustic Chord Loop 9 - 160 BPM A Maj.wav"]
parameterNames = ["Acoustic Chord 140 BPM D Maj", "Acoustic Chord 160 BPM A Maj", "Acoustic Chord 180 BPM D# Maj", "Acoustic Chord 180 BPM E Min", "Acoustic Chord 180 BPM F# Min", "Acoustic Chord 180 BPM G Min", "Acoustic Chord 140 BPM E Maj", "Acoustic Chord 140 BPM E Maj", "Acoustic Chord 140 BPM F# Min", "Acoustic Chord 160 BPM E Maj", "Acoustic Chord 160 BPM E Min", "Acoustic Chord 160 BPM G Maj", "Acoustic Chord 160 BPM G# Min", "Acoustic Chord 160 BPM A Maj"]

if (len(fileNames) != len(parameterNames)) :
    print('The arrays must be the same size')
    print('FileName: ' + str(len(fileNames)))
    print('ParamName: ' + str(len(parameterNames)))
    exit()

for i in range(len(fileNames)) :
    '''
    else if(sampleName=="Acoustic Chord 140 BPM D Maj") {
            samplesFolder + "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 1 - 140 BPM D Maj.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
    '''
    s = ' else if(sampleName=="'
    s += parameterNames[i]
    s+= '") {\n\tsamplesFolder + "'
    s+= fileNames[i]
    s+='" =>filePath;\n\tfilePath =>buf.read;\n\t(buf.length()/buf.rate())=>now;\n}'
    print(s)