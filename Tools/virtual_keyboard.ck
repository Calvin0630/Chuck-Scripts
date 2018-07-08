
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
    Std.atoi(me.arg(2))=>rootNote;
}
else {
    <<<"Fix your args">>>;
    me.exit();
}
fun void wait(float duration) {
    duration::second=>now;
}


// HID
Hid hi;
HidMsg msg;

// which keyboard
0 => int device;

// open keyboard (get device number from command line)
if( !hi.openKeyboard( device ) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;

// patch
Gain finalVolume=>dac;
volume=>finalVolume.gain;
MidiOscillator mOsc;
mOsc.init(finalVolume, bpm, 1, rootNote);
IntArray keys;
//z,a,q go up by fifths. with 7 frets on each row
keys.add([16,17,18,19,20,21,29,
    30,31,32,33,34,35,36,
    44,45,46,47,48,49,50]);
IntArray notes;
//the notes that's index corresponds to the index of keys
notes.add([10,11,12,13,14,15,16,
    5,6,7,8,9,10,11,
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



private class MidiOscillator {
    // 100:.2:60
    //recommended args: (bpm, gain, rootNote)
    //arguements separated by a colon
    int bpm;
    //the time(seconds) of one beat
    float beat;
    //a number between 0 and 1 that sets the volume
    float volume;
    IntArray activeNotes;
    //the midi int of the root note
    int rootNote;
    //a sin osc for each midi note
    SinOsc oscillators[128];
    //an adsr filter for each note
    ADSR adsrs[128];
    SinOsc audioSource;
    SinOsc lfo;
    Gain gain;
    
    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {

        bpm_ =>bpm;
        60/(bpm_ $ float) => beat;
        volume_ => volume;
        rootNote_ => rootNote;
        
        audioSource => gain => output;
        audioSource.op(-1);
        volume => gain.gain;
        //an array of adsr settings: AttackTime, DelayTime, Sustain, Release
        [beat/4, beat, 1, beat/8] @=> float adsrSettings[];
        //instantiate the elements in the the array
        for (0=>int i;i<oscillators.cap();i++) {
            oscillators[i] => adsrs[i] => audioSource;
            //oscillators[i]  => audioSource;
            //apply setting to the adsr
            adsrs[i].set(adsrSettings[0]::second, adsrSettings[1]::second, adsrSettings[2], adsrSettings[3]::second);

            Std.mtof(i) => oscillators[i].freq;
            1 => oscillators[i].gain;
            
        }    
    }
    
    //notes is an array of ints that are the offset from rootNote of the notes to play
    fun void notesOn(int notes[]) {
        //volume =>audioSource.gain;
        for(0=>int i;i<notes.cap();i++) {
            if (activeNotes.contains(notes[i])==0) {
                activeNotes.add(notes[i]);
            }
            adsrs[rootNote+notes[i]].keyOn();
        }
        activeNotes.print();
        (1/(activeNotes.size() $ float))=>gain.gain;
    }

    fun void notesOff(int notes[]) {
        //volume =>audioSource.gain;
        for(0=>int i;i<notes.cap();i++) {
            if (activeNotes.contains(notes[i])==1) {
                activeNotes.remove(notes[i]);
            }
            adsrs[rootNote+notes[i]].keyOff();
            
        }
        activeNotes.print();
        (1/(activeNotes.size() $ float))=>gain.gain;
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