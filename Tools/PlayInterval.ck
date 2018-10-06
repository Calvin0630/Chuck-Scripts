// 100:.2:60
//args: bpm:volume:rootNote:note1:note2:....:noteN 
//notes are integers relative to Roote Note
//arguements separated by a colon
int bpm;
//the time(seconds) of one beat
float beat;
//a number between 0 and 1 that sets the volume
float volume;
//the midi int of the root note
int rootNote;

//take in the command line args

Std.atoi(me.arg(0)) =>bpm;
60/Std.atof(me.arg(0)) => beat;
Std.atof(me.arg(1)) => volume;
Std.atoi(me.arg(2)) => rootNote;



fun void wait(float duration) {
    duration::second=>now;
}
<<<me.args()>>>;
int arguments[me.args()-3];
for (0=>int i;i<arguments.cap();i++) {
    Std.atoi(me.arg(i+3)) =>arguments[i];
}
MidiOscillator mOsc;
mOsc.init(dac, bpm, volume, rootNote);
for (0=>int i;i<arguments.cap();i++) {
    mOsc.notesOn([arguments[i]]);
    wait(beat);
    mOsc.notesOff([arguments[i]]);
    wait(beat);
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
    ADSR adsr;
    ADSR preAdsr[128];
    Gain audioSource;
    Gain phaseOne;
    //lfoRate (hertz)
    float lfoRate;
    SinOsc lfo;
    Gain gain;
    //a list of all the active notes
    IntArray activeNotes;


    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {

        bpm_ =>bpm;
        60/(bpm_ $ float) => beat;
        volume_ => volume;
        rootNote_ => rootNote;

        audioSource=>phaseOne=>gain=>output;
        lfo=>phaseOne;
        phaseOne.op(3);
        lfo=>phaseOne;
        64=>lfoRate;
        .5=>lfo.gain;
        lfoRate=>lfo.freq;
        volume => gain.gain;
        //an array of adsr settings: AttackTime, DelayTime, Sustain, Release
        [beat/2, beat, beat/8, beat/8] @=> float adsrSettings[];
        adsr.set(adsrSettings[0]::second, adsrSettings[1]::second, adsrSettings[2], adsrSettings[3]::second);

        //instantiate the elements in the the array
        for (0=>int i;i<oscillators.cap();i++) {
            oscillators[i] =>preAdsr[i]=> audioSource;
            //apply setting to the adsr

            Std.mtof(i) => oscillators[i].freq;
            1 => oscillators[i].gain;

        }
    }
    //a function for debugging
    fun void debug() {
        0=>float max;
        while (true) {
            if (gain.last()>max) {
                gain.last() =>max;
            }
            <<<max,"">>>;
            50::ms=>now;
        }
    }

    //notes is an array of ints that are the offset from rootNote of the notes to play
    fun void notesOn(int notes[]) {
        for(0=>int i;i<notes.cap();i++) {
            activeNotes.add(notes[i]);
            preAdsr[rootNote+notes[i]].keyOn();
        }
        adsr.keyOn();
        activeNotes.print();
        (1/(activeNotes.size()$float))=>audioSource.gain;
    }

    fun void notesOff(int notes[]) {
        for(0=>int i;i<notes.cap();i++) {
            activeNotes.remove(notes[i]);
            preAdsr[rootNote+notes[i]].keyOff();
        }
        adsr.keyOff();
        activeNotes.print();
        (1/(activeNotes.size()$float))=>audioSource.gain;
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
