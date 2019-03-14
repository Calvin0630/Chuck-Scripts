private class Sampler {

    //arguements separated by a colon
    int bpm;
    //the time(seconds) of one beat
    float beat;
    //a number between 0 and 1 athat sets the volume
    float volume;
    //the midi int of the root note
    int rootNote;
    string samplesFolder;
    Gain gain;
    //sample names
    ["snare", 
        "kick", 
        "kick 2",
        "rant: a religious rant with google translate", 
        "pizza time", 
        "death", 
        "you will die", 
        "there is none", 
        "despacito song", 
        "despacito", 
        "riff 1", 
        "waterfall", 
        "woof", 
        "boop", 
        "hi hat 0open", 
        "hi hat closed", 
        "guitar e5", 
        "Acoustic Chord 140 BPM D Maj", 
        "Acoustic Chord 160 BPM A Maj", 
        "Acoustic Chord 180 BPM D# Maj", 
        "Acoustic Chord 180 BPM E Min", 
        "Acoustic Chord 180 BPM F# Min", 
        "Acoustic Chord 180 BPM G Min", 
        "Acoustic Chord 140 BPM E Maj", 
        "Acoustic Chord 140 BPM E Maj", 
        "Acoustic Chord 140 BPM F# Min", 
        "Acoustic Chord 160 BPM E Maj", 
        "Acoustic Chord 160 BPM E Min", 
        "Acoustic Chord 160 BPM G Maj", 
        "Acoustic Chord 160 BPM G# Min", 
        "Acoustic Chord 160 BPM A Maj"] @=> string sampleNames[];
    //filNames that correspond to sampleNames (used as aliases)
    ["Snares\\Cymatics - Snare 1.wav",
        "Kicks\\Cymatics - Kick 1 - C.wav",
        "Kicks\\Cymatics - Kick 18 - G.wav",
        "rant.wav",
        "pizza_time.wav",
        "death.wav",
        "you_will_die.wav",
        "there_is_none.wav",
        "despacito_song.wav",
        "despacito.wav",
        "riff_1(70bpm,16beats).wav",
        "Allen_gardens_waterfall.wav",
        "woof.wav",
        "boop.wav",
        "271_hi_hat_samples\\hihat_004a.wav",
        "271_hi_hat_samples\\hihat_004b.wav",
        "Phone Recordings\\guitar e-5 (A) note.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 1 - 140 BPM D Maj.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 10 - 160 BPM A Maj.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 11 - 180 BPM D# Maj.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 12 - 180 BPM E Min.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 13 - 180 BPM F# Min.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 14 - 180 BPM G Min.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 2 - 140 BPM E Maj.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 3 - 140 BPM E Maj.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 4 - 140 BPM F# Min.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 5 - 160 BPM E Maj.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 6 - 160 BPM E Min.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 7 - 160 BPM G Maj.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 8 - 160 BPM G# Min.wav",
        "guitarloops\\Chord Loops\\Cymatics - Acoustic Chord Loop 9 - 160 BPM A Maj.wav"] @=> string fileNames[];
    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {
        gain => output;
        "C:\\Users\\Calvin\\Documents\\Chuck-Scripts\\Samples\\" => samplesFolder;
        bpm_ =>bpm;
        60/(bpm_ $ float)=>beat;
        volume_ => volume;
        rootNote_ => rootNote;
        volume =>gain.gain;
        //spork~listenToKeyboard();
    }

    fun void listenToKeyboard() {
        //numrow 0-9
        IntArray keys;
        keys.add([30, 31, 32, 33, 34, 35, 36, 37, 38 , 39]);
        // the names of the samples that correspond to their mutally indexed keys
        ["snare", "kick", "boop", "pizza time", "death", "you will die", "there is none", "despacito song", "hi hat closed", "hi hat open"]
            @=> string sampleStrings[];

        Hid hi;
        HidMsg msg;

        // which keyboard
        0 => int device;

        // open keyboard (get device number from command line)
        if( !hi.openKeyboard( device ) ) me.exit();
        <<< "keyboard '" + hi.name() + "' ready", "" >>>;

        // infinite event loop
        while( true )
        {
            // wait on event
            hi => now;

            // get one or more messages
            while( hi.recv( msg ) )
            {
                // check for action type
                if( msg.isButtonDown() )
                {
                    //<<< "down:", msg.which, "(code)", msg.key, "(usb key)", msg.ascii, "(ascii)" >>>;
                    //msg.key is unique for each buitton on a qwerty
                    //q1<<<  msg.key, ", " >>>;
                    keys.indexOf(msg.key)=>int sample;
                    <<<sample,"">>>;
                    //if the user pressed 0-9 on num row
                    if (sample != -1) {
                        spork~playSample(sampleStrings[sample]);
                    }
                }

                else
                {
                    //<<< "up:", msg.which, "(code)", msg.key, "(usb key)", msg.ascii, "(ascii)" >>>;
                }
            }
        }
    }
    fun void wait(float duration) {
        duration::second=>now;
    }
    
    /*
   Loads and plays a sample. The function returns once the sample is done playing

   Sample names:
   snare
   kick
   rant: a religious rant with google translate
   pizza time
   death
   you will die
    there is none
   despacito song
   despacito
    riff 1
    waterfall
    woof
    boop
    hi hat 0open
    hi hat closed
    guitar e5
    Acoustic Chord 140 BPM D Maj
    Acoustic Chord 160 BPM A Maj
    Acoustic Chord 180 BPM D# Maj
    Acoustic Chord 180 BPM E Min
    Acoustic Chord 180 BPM F# Min
    Acoustic Chord 180 BPM G Min
    Acoustic Chord 140 BPM E Maj
    Acoustic Chord 140 BPM E Maj
    Acoustic Chord 140 BPM F# Min
    Acoustic Chord 160 BPM E Maj
    Acoustic Chord 160 BPM E Min
    Acoustic Chord 160 BPM G Maj
    Acoustic Chord 160 BPM G# Min
    Acoustic Chord 160 BPM A Maj
   */
	fun void playSample(string sampleName) {
        //sampleNames have the same index in fileNames 
        //The purpose was to make the parameters easier instead of typing BleBleBleUdergroundSample.wav


        
        
        //find the index of sampleName in the list of sampleNames
        -1 =>int index;
        0=> int i;
        for(i;i<sampleNames.cap();i++) {
            if (sampleName == sampleNames[i]) {
                i=> index;
                break;
            }
        }
        
        <<<"Index: ",index>>>;
         if (index==-1) {
            <<<"I didn't recognize that option","">>>;
            return;
        }
        else {
            //the option was recognized
            //play the sound
            SndBuf buf=>gain;
            samplesFolder + fileNames[i]=> string filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        
       
    }

    fun void pattern1() {
        while(true) {
            for (0=>int x;x<4;x++) {
                for(0=>int i;i<4;i++) {
                    if (i==0) {
                        playSample("kick");
                        wait(beat);
                    }
                    else if(i==1) {
                        if (x==0) {
                            playSample("death");
                            wait(beat);
                        }
                        else if (x==1) {
                            spork~playSample("there is none");
                            wait(beat);
                        }
                        else if (x==2||x==3) {
                            spork~playSample("despacito");
                            wait(beat);
                        }
                    }
                    else if(i==2) {
                        repeat(2) {
                            playSample("kick");
                            wait(beat/2);
                        }
                    }
                    else if(i==3) {
                        if(x==0) {
                            playSample("snare");
                            wait(beat);
                        }
                        else if(x==1) {
                            repeat(8) {
                                playSample("snare");
                                wait(beat/8);
                            }
                        }
                    }
                }
            }
        }
    }

    fun void roll(float initialDuration) {
        initialDuration=>float duration;
        while(duration>.0001) {
            <<<duration,"">>>;
            playSample("snare");
            wait(duration);
            2/=>duration;
        }
    }

}

private class IntArray {
    /*
    functions:
    add: int[] or int
    remove: int[] or int
    get: int index
    indexOf:int element
    contains returns 0 if no, 1 if yes
    print: void, prints the array
    size return the size of the array

    */
    int elements[];
    //add an array of ints
    fun void add(int newElements[]) {
        for (0=>int i;i<newElements.cap();i++) {
            add(newElements[i]);
        }
    }
    //add a single int
    fun void add(int element) {
        //if its empty
        if (elements==null) {
            [element]@=> elements;
        }
        else { //creates a new array and appends the new element
            elements.cap()+1=>int newArraySize;
            int newElements[newArraySize];
            for (0=>int i;i<newArraySize;i++) {
                //if its at the end
                if (i==newArraySize-1) {
                    //append element
                    element=>newElements[i];
                }
                else {
                    elements[i]=>newElements[i];
                }
            }
            newElements@=>elements;
        }
    }
    //removes a list of numbers
    fun void remove(int removeThis[]) {
        for (0=>int i;i<removeThis.cap();i++) {
            remove(removeThis[i]);
        }
    }
    //removes the element parameter (not the index)
    fun void remove(int element) {
        indexOf(element)=> int index;
        //if the element isnt here
        if (index==-1) {
            <<<"the element you're trying to remove isn't here","">>>;
        }
        else {//the element is in the array
            int newElements[];
            if (elements.cap()>1) { //if the array is bigger than 1
                int newElements[elements.cap()-1];
                for (0=>int i;i<elements.cap();i++) {
                    if (i==index) {
                        continue;
                    }
                    if (i>index) {
                        elements[i]=>newElements[i-1];
                    }
                    else {
                        elements[i]=>newElements[i];
                    }
                }
                newElements@=>elements;
            }
            else if(elements.cap()==1){
                 null@=>elements;
            }
        }

    }
    //returns the element @ index
    fun int get(int index) {
        if (index >=elements.cap()) <<<"invalid index","">>>;
        else return elements[index];
    }
    //returns the index of the element
    //if not found returns -1
    fun int indexOf(int element) {
        //int
        -1=>int contains;
        if (elements!= null) {
            for (0=>int i;i<elements.cap();i++) {
                if (elements[i]==element) {
                    i=>contains;
                    return contains;
                }
            }
        }
        return contains;
    }

    fun int contains(int element) {
        indexOf(element)=>int result;
        if (result ==-1) return 0;
        else return 1;
    }
    fun void print() {
        ""=>string result;
        for (0=>int i;i<elements.cap();i++) {
            //if its the last element
            if(i==elements.cap()-1) {
                //dont put a comma
                elements[i]+"" +=>result;
            }
            else {
                //do
                elements[i] + "," +=>result;
            }
        }
        <<<("["+result+"]"),"">>>;
    }
    fun int size() {
        if(elements==null) return 0;

        else return elements.cap();
    }
}

// 100:.2:60
//recommended args: (bpm, gain, rootNote)
//arguements separated by a colon
int bpm;
//the time(seconds) of one beat
float beat;
//a number between 0 and 1 that sets the volume
float volume;
//the midi int of the root note
int rootNote;

//take in the command line args
if(me.args() == 3) {
    Std.atoi(me.arg(0)) =>bpm;
    60/Std.atof(me.arg(0)) => beat;
    Std.atof(me.arg(1)) => volume;
    Std.atoi(me.arg(2)) => rootNote;
}
else if (me.args()==0) {
    <<<"using default args","">>>;
    //set the default arguements
    80 =>bpm;
    60/70 $ float => beat;
    0.7 => volume;
    //6c9 -3 so the rootNote is on the 'v' key
    69-3 => rootNote;
}
else {
    <<<"Fix your args","">>>;
    <<<"","Expected: bpm:volume:rootNote">>>;
    me.exit();
}

fun void wait(float duration) {
    duration::second=>now;
}


Gain gain => dac;
volume=>gain.gain;
Sampler sam;
sam.init(gain, bpm, 1, rootNote);
Sampler sam2;
sam2.init(gain, bpm, 1, rootNote);
spork~drum();

while (true) {
    sam.playSample("Acoustic Chord 160 BPM E Min");
}

fun void drum() {
    while (true) {
        spork~sam2.playSample("kick");
        wait(beat);
        spork~sam2.playSample("snare");
        wait(beat);
        spork~sam2.playSample("kick");
        wait(beat);
        repeat(2) {
            spork~sam2.playSample("woof");
            wait(beat/2);
        }
        spork~sam2.playSample("kick");
        wait(beat);
        repeat(2){ 
            spork~sam2.playSample("snare");
            wait(beat/4);
        }
        repeat(4){ 
            spork~sam2.playSample("snare");
            wait(beat/8);
        }
        spork~sam2.playSample("kick");
        wait(beat);
        repeat(2) {
            spork~sam2.playSample("woof");
            wait(beat/2);
        }
    }
}