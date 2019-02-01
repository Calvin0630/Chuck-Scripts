

//recommended args: (bpm, gain, rootNote)
//arguements separated by a colon
int bpm;
//the time(seconds) of one beat
float beat;
//a number between 0 and 1 that sets the volume
float volume;
//the midi int of the root note
int rootNote;

if(me.args() == 3) {
    Std.atoi(me.arg(0)) =>bpm;
    60/Std.atof(me.arg(0)) => beat;
    Std.atof(me.arg(1)) => volume;
    Std.atoi(me.arg(2)) => rootNote;
}
else if (me.args()==0) {
    //set the default arguements
    70 =>bpm;
    60/70 $ float => beat;
    1 => volume;
    69 => rootNote;
}
else {
    <<<"Fix your args","">>>;
    <<<"","Expected: bpm:volume:rootNote">>>;
    me.exit();
}

fun void wait(float duration) {
    duration::second=>now;
}

<<<bpm+", " +volume+", "+rootNote>>>;


// patch
//Gain chordsIn=>PRCRev reverb=>Gain finalVolume=>dac;
Gain chordsIn=>Chorus chorus=>PRCRev reverb=>PitShift pitShift=>Gain finalVolume=>dac;
chorus=>Gain bypass=>finalVolume;
0.5=>bypass.gain;
0.8=>pitShift.mix;
0=>pitShift.shift;
spork~varyPitShift();
fun void varyPitShift() {
    SinOsc a=>blackhole;
    1.2=>a.gain;
    (1/(beat/8))=>a.freq;
    while (true) {
        a.last()=>pitShift.shift;
        wait(beat/128);
    }

}
beat=>chorus.modFreq;
1=>chorus.modDepth;
0.7=>chorus.mix;
/*
(beat/3)::second=>echo.delay;
1=>echo.mix;
(beat/8)::second=>echo.max;
*/
.3=>reverb.mix;
0.7=>chordsIn.gain;
volume=>finalVolume.gain;
MidiOscillator mOsc;
mOsc.init(chordsIn, bpm, 0.5, rootNote);
//spork~mainVoice();
spork~chords();
while (true) {
    wait(beat*2);
}
fun void mainVoice() {
    //if a note is -1 that represents a break
    [0,-2,-5,-1, 0,3,5,-1,5,10,12,-1,12,10,5,-1]@=>int notes[];
    while(true) {
        for(0=> int i;i<notes.cap();i++) {
            if (notes[i] != -1)     spork~mOsc.playNotes([notes[i]],beat/4);
            wait(beat);
        }
    }
}
//this sequence goes for 8 beats
fun void chords() {
    while (true) {
        spork~mOsc.playNotes([0,4,7], beat*3/2);
        wait(beat*2);
        spork~mOsc.playNotes([5,9,12], beat*3/2);
        wait(beat*2);
        spork~mOsc.playNotes([7,10,14], beat*3/2);
        wait(beat*2);
        spork~mOsc.playNotes([5,8,12], beat*3/2);
        wait(beat*2);
    }
}



private class MidiOscillator {
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
    //a sin osc for each midi note
    SinOsc oscillators[128];
    //an adsr filter for each note
    ADSR preAdsr[128];
    Gain audioSource;
    Gain phaseOne;
    //lfoRate (hertz)
    TriOsc lfo;
    //SinOsc lfoTwo;
    //SinOsc lfoThree;
    Gain gain;
    //a list of all the active notes
    IntArray activeNotes;


    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {

        bpm_ =>bpm;
        60/(bpm_ $ float) => beat;
        volume_ => volume;
        rootNote_ => rootNote;

        //with lfo
        audioSource=>phaseOne=>gain=>output;
        //removing lfo
        //audioSource=>gain=>output;
        lfo=>phaseOne;
        phaseOne.op(3);
        lfo=>phaseOne;
        1=>lfo.gain;
        1/(beat/4)=>lfo.freq;
        //1=>lfoTwo.gain;
        //3*lfoRate=>lfoTwo.freq;
        //1=>lfoThree.gain;
        //5*lfoRate=>lfoThree.freq;
        //lfoThree=>phaseOne;
        //lfoTwo=>phaseOne;
        volume => gain.gain;
        //an array of adsr settings: AttackTime, DelayTime, Sustain, Release
        [beat/2, beat, 0.25, beat] @=> float adsrSettings[];

        //instantiate the elements in the the array
        for (0=>int i;i<oscillators.cap();i++) {
            preAdsr[i].set(adsrSettings[0]::second, adsrSettings[1]::second, adsrSettings[2], adsrSettings[3]::second);
            oscillators[i] =>preAdsr[i]=> audioSource;

            //apply setting to the adsr

            Std.mtof(i) => oscillators[i].freq;
            1 => oscillators[i].gain;

        }
        spork~listenForEvents();
    }
    //a function to set the volume
    fun void SetVolume(float _volume) {
        _volume=>volume;
        volume=>gain.gain;
    }
    //a function for debugging
    fun void listenForEvents() {
        // which keyboard
        0 => int device;
        // HID
        Hid hi;
        HidMsg msg;
        // open keyboard (get device number from command line)
        if( !hi.openKeyboard( device ) ) me.exit();
        <<< "keyboard '" + hi.name() + "' ready", "" >>>;
        IntArray keys;
        //z,a,q go up by fifths. with 7 frets on each row
        keys.add([16,17,18,19,20,21,22,23,24,25,
            30,31,32,33,34,35,36,37,38,
            44,45,46,47,48,49,50]);
        IntArray notes;
        //the notes that's index corresponds to the index of keys
        notes.add([10,11,12,13,14,15,16,17,18,19,
            5,6,7,8,9,10,11,13,14,
            0,1,2,3,4,5,6]);
        IntArray activeNotes;
        // infinite event loop
        while( true )
        {
            //starts at z, a is 1 fifth up, q, a second fifth up.
            [1]
            @=>int keyboardLayout[];
            // wait for event
            hi => now;

            // get message
            while( hi.recv( msg ) )
            {
                // if the button is pressed down
                if( msg.isButtonDown() )
                {
                    keys.indexOf(msg.which)=> int index;
                    //if its a valid key
                    if (index!=-1) {
                        notes.get(index) => int note;
                        //if the note isnt active
                        if (activeNotes.contains(note)==0) {
                            activeNotes.add(note);
                            mOsc.notesOn([note]);
                        }
                        //<<<"down "+ notes.get(index),"">>>;

                    }
                    //<<< msg.which,"">>>;


                    80::ms => now;
                }
                else //its been released
                {
                    keys.indexOf(msg.which)=> int index;
                    //if its a valid key
                    if (index!=-1) {
                        notes.get(index) => int note;
                        //if the note is active
                        if (activeNotes.contains(note)!=-1) {
                            activeNotes.remove(note);
                            mOsc.notesOff([note]);
                        }
                        //<<<"up "+ notes.get(index),"">>>;
                    }
                }
                //(1/(mOsc.activeNotes.size() $ float))=>mOsc.gain.gain;
            }
        }

    }

    //notes is an array of ints that are the offset from rootNote of the notes to play
    fun void notesOn(int notes[]) {
        for(0=>int i;i<notes.cap();i++) {
            activeNotes.add(notes[i]);
            preAdsr[rootNote+notes[i]].keyOn();
        }
        activeNotes.print();
        if (activeNotes.size()>1)  (1/(activeNotes.size()$float))=>audioSource.gain;
        else 1=>audioSource.gain;
    }

    fun void notesOff(int notes[]) {
        for(0=>int i;i<notes.cap();i++) {
            activeNotes.remove(notes[i]);
            preAdsr[rootNote+notes[i]].keyOff();
        }
        activeNotes.print();
        if (activeNotes.size()>1)  (1/(activeNotes.size()$float))=>audioSource.gain;
        else 1=>audioSource.gain;
    }

    //a function that plays a set of notes for a duration
    fun void playNotes(int notes[], float duration){
        notesOn(notes);
        wait(duration);
        notesOff(notes);
    }
    fun void wait(float duration) {
        duration::second=>now;
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
        if(elements==null) {
            <<<"[]","">>>;
            return;
        }
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
