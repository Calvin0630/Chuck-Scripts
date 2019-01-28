

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
    70 =>bpm;
    60/70 $ float => beat;
    0.3 => volume;
    69 => rootNote;
}
else {
    <<<"Fix your args","">>>;
    me.exit();
}

fun void wait(float duration) {
    duration::second=>now;
}

Didgeridoo dig;
dig.init(dac, bpm, volume, rootNote);

int duration;
while (true) {
    [0,4,5,0,4,7] @=> int notes[];
    for (0=>int i;i<notes.cap();i++) {
        <<<i>>>;
        2=>duration;
        if(i==2||i==5) {
            4=>duration;
        }
        dig.playNote(notes[i], duration*beat/2);
    }
}


private class Didgeridoo{
    int bpm, rootNote;
    float volume, beat;
    IntArray activeNotes;
    Impulse impulse[128];
    Echo echo[128];
    Gain gain [128];
    ADSR adsr[128];
    Gain volumeGain;
    UGen output;
    //decay 0-1: how fast the note goes quiet
    0.4=>float decay;
    fun void init(UGen output_, int bpm_, float volume_, int rootNote_) {
        output => output_;
        //impulse => echo => gain => adsr =>volumeGain => output;
        //gain=>echo;
        volumeGain => output;
        bpm_=>bpm;
        (60/(bpm$float))=>beat;
        volume_=>volume;
        volume=>volumeGain.gain;
        rootNote_=>rootNote;
        //an array of adsr settings: AttackTime, DelayTime, Sustain, Release
        [0.1, 0.1, 0.5, 0.1] @=> float adsrSettings[];
        //set up each of the notes
        for (0=>int i;i<128;i++) {
            impulse[i]=>echo[i]=> gain[i]=>adsr[i]=>volumeGain;
            gain[i]=>echo[i];
            adsr[i].set(adsrSettings[0]::second, adsrSettings[1]::second, adsrSettings[2], adsrSettings[3]::second);
            decay=>echo[i].mix;
            Std.mtof(i) => float freq;
            (1/freq)::second => echo[i].max;
            (1/freq)::second => echo[i].delay;

        }
        spork~listenForEvents();
    }

    //waits for duration(seconds)
    fun void wait(float duration) {
        duration::second=>now;
    }
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
                            dig.notesOn([note]);
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
                            dig.notesOff([note]);
                        }
                        //<<<"up "+ notes.get(index),"">>>;
                    }
                }
                //(1/(mOsc.activeNotes.size() $ float))=>mOsc.gain.gain;
            }
        }

    }
    /*
    fun void playNote(int midiNote, float duration, float decay) {
        //decay 0-1: how fast the note goes quiet
        decay=>echo.mix;
        Std.mtof(rootNote + midiNote) => float freq;


        (1/freq)::second => echo.max;
        (1/freq)::second => echo.delay;
        1 =>impulse.next;
        adsr.keyOn();
        wait(duration);
        adsr.keyOff();
        0::second => echo.delay;
        0::second => echo.max;
    }
    */

    fun void playNote(int midiNote, float duration) {
        notesOn([midiNote]);
        wait(duration);
        notesOff([midiNote]);
    }
    fun void notesOn(int notes[]) {
        for(0=>int i;i<notes.cap();i++) {
            activeNotes.add(notes[i]);
            1=>impulse[i].next;
            adsr[rootNote+notes[i]].keyOn();
        }
        activeNotes.print();
        if (activeNotes.size()>1)  (volume/(activeNotes.size()$float))=>volumeGain.gain;
        else 1=>volumeGain.gain;
    }

    fun void notesOff(int notes[]) {
        for(0=>int i;i<notes.cap();i++) {
            activeNotes.remove(notes[i]);
            adsr[rootNote+notes[i]].keyOff();
        }
        activeNotes.print();
        if (activeNotes.size()>1)  (1/(activeNotes.size()$float))=>volumeGain.gain;
        else 1=>volumeGain.gain;
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
