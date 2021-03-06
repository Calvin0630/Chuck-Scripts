
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
    //set the default arguements
    70 =>bpm;
    60/70 $ float => beat;
    0.3 => volume;
    //57 => rootNote;
    28 => rootNote;
}
else {
    <<<"Fix your args","">>>;
    <<<"","Expected: bpm:volume:rootNote">>>;
    me.exit();
}

fun void wait(float duration) {
    duration::second=>now;
}


PitShift shift=>Gain gain => dac;
1=> shift.shift;
1=>shift.mix;
volume=>gain.gain;
Sampler sam;
sam.init(shift, bpm, 0.2, rootNote);
//spork~hihat();
//spork~kickAndSnare();
//spork~guitarScale();
GuitarPitchBender pit;
pit.init(gain,bpm,0.7, rootNote);
while (true) {
    wait(beat);
 }


 fun void hihat () {
     while(true) {
         repeat(4) {
             spork~sam.playSample("hi hat open");
             wait(beat/2);
         }
         repeat(8) {
             spork~sam.playSample("hi hat open");
             wait(beat/8);
         }
         repeat(2){
             spork~sam.playSample("hi hat open");
             wait(beat/2);
         }
     }
 }
 fun void kickAndSnare() {
     while(true) {
         //ONE
         repeat(2) {
            spork~sam.playSample("kick");
            wait(beat/2);
         }
         //TWO
         spork~sam.playSample("kick");
         wait(beat/4);
         spork~sam.playSample("snare");
         wait(beat/4);
         spork~sam.playSample("kick");
         wait(beat/2);
         //THREE
         repeat(4) {
            spork~sam.playSample("kick");
            wait(beat/4);
         }
         //FOUR
         spork~sam.playSample("kick");
         wait(beat/4);
         spork~sam.playSample("snare");
         wait(beat/4);
         spork~sam.playSample("kick");
         wait(beat/2);
         /*
         spork~sam.playSample("kick");
         wait(beat/2);
         spork~sam.playSample("kick");
         wait(beat/2);
         repeat(3) {
             spork~sam.playSample("snare");
             wait(beat/3);
         }
         */
     }
 }
 
fun void guitarScale() {
    //[4.0,2.0,1.0,0.5,0.25,0.125,0.0625,-0.0625,-0.125,-0.25,-0.5,-1.0,-2.0,-4.0]@=> float scale[];
    [0,2,4,5,7,9,10,11,12]@=> int scale[];
    0=> int i;
    while (true) {
        if (i>=scale.cap()) 0 => i;
        <<<"scale[i] ", scale[i]>>>;
        //ratio is the ratio from the tone of the guitar sample (root) note 69 (rootNote)
        Std.mtof(rootNote+scale[i])/Std.mtof(rootNote) => float ratio;
        <<<"ratio: ",ratio>>>;
        ratio=>shift.shift;
        spork~sam.playSample("guitar e5");
        wait(beat);
        i++;
    }
}
private class GuitarPitchBender {
    Sampler samplers[128];
    PitShift shift[128];
    Gain source;
    IntArray activeNotes;
    //the note of the sample is A3 midi: 57 (rootNote)
    int rootNote;
    int bpm;
    float volume, beat;
    
    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {
        bpm_ =>bpm;
        60/(bpm_ $ float)=>beat;
        volume_ => volume;
        rootNote_ => rootNote;
        volume=>source.gain;
        source=> output;
        for (0=>int i;i<128;i++) {
            float ratio;
            if(i==rootNote) 1=>ratio;
            else Math.sgn(i-rootNote)*Std.mtof(Math.max(rootNote,i))/Std.mtof(Math.min(rootNote,i))=> ratio;
            <<<"i, ratio: ",i," , ",ratio>>>;
            ratio=>shift[i].shift;
            1=>shift[i].mix;
            shift[i] => source;
            samplers[i].init(shift[i],bpm,volume, rootNote);
        }
        spork~listenForEvents();
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
                        activeNotes.add(note);
                        spork~playNote(note);
                        activeNotes.print();
                        //<<<"down "+ notes.get(index),"">>>;

                    }
                    //<<< msg.which,"">>>;


                    80::ms => now;
                    
                }
                else //its been released
                {
                    
                }
                //(1/(mOsc.activeNotes.size() $ float))=>mOsc.gain.gain;
            }
        }

    }
    fun void playNote(int midiIndex) {
        <<<"midiIndex: ", midiIndex>>>;
        samplers[rootNote+midiIndex].playSample("guitar E5 chord");
        activeNotes.remove(midiIndex);

    }
}
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

    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {
        gain => output;
        "C:\\Users\\Calvin\\Documents\\Chuck-Scripts\\Samples\\" => samplesFolder;
        bpm_ =>bpm;
        60/(bpm_ $ float)=>beat;
        volume_ => volume;
        rootNote_ => rootNote;
        volume =>gain.gain;
    }

    fun void wait(float duration) {
        duration::second=>now;
    }


    /*
    Loads and plays a sample. The function returns once the sample is done playing

    Options:
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
    guitar E5 chord
   */
	fun void playSample(string sampleName) {

        //checks to make sure you initialized the sampler
         if(samplesFolder=="") {
            <<<"Did you initialize the sampler?","">>>;
        }
        SndBuf buf=>gain;
        string filePath;
        if (sampleName == "snare") {
            samplesFolder + "Snares\\Cymatics - Snare 1.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName == "kick") {
            samplesFolder + "Kicks\\Cymatics - Kick 1 - C.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="rant") {
            samplesFolder + "rant.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="pizza time") {
            samplesFolder + "pizza_time.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;

        }
        else if(sampleName=="death") {
            samplesFolder + "death.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="you will die") {
            samplesFolder + "you_will_die.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="there is none") {
            samplesFolder + "there_is_none.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="despacito song") {
            samplesFolder + "despacito_song.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="despacito") {
            samplesFolder + "despacito.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="riff 1") {
            samplesFolder + "riff_1(70bpm,16beats).wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="waterfall") {
            samplesFolder + "Allen_gardens_waterfall.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="woof") {
            samplesFolder + "woof.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="boop") {
            samplesFolder + "boop.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="hi hat open") {
            samplesFolder + "271_hi_hat_samples\\hihat_004a.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="hi hat closed") {
            samplesFolder + "271_hi_hat_samples\\hihat_004b.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="guitar e5") {
            samplesFolder + "Phone Recordings\\guitar e-5 (A) note.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="guitar E5 chord") {
            samplesFolder + "Phone Recordings\\guitar E5 chord.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else {
            <<<"I didn't recognize that option","">>>;
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
