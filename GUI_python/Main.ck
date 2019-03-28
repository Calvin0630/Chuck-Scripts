/*
This is an explanation of the classes in this ChucK file.

Main: a general class for miscelaneous functions. eg. exit on escape, print6 keyboard nums

MidiOscillator: A virtual note synthesizer

EffectsChain: An instance variable in MidiOscillator that manages the connecting and disconnecting of effects.

Effect: EffectsChain contains an arrays of Effect elements that are mostly referenced using a string of the effects name. eg.
    "reverb"
    "delay"
    "phasor"

SettingsReader: This class reads variables from settings.txt. Unity-GameManager.cs writes the variables and this script reads them
and communicates with the relevant chuck classes (MidiOscillator, Sampler)

Sampler: A chuck class that plays samples (drums, recording, etc.)

IntArray: an array class that I wrote that has some helpful functions that are not available with sdefault chuck arrays

Note: Loops are mostly done through calling chuck scripts from C#
*/

private class Main {
    //prints key.which
    fun void debug_printKeyNum() {

        // which keyboard
        0 => int device;
        // HID
        Hid hi;
        HidMsg msg;
        // open keyboard (get device number from command line)
        if( !hi.openKeyboard( device ) ) me.exit();
        // infinite event loop
        while( true ){
            // wait for event
            hi => now;

            // get message
            while( hi.recv( msg ) ) {
                if (msg.isButtonDown()) {
                    <<<msg.which,"">>>;
                }

                    80::ms => now;
            }
        }
    }
    fun void exitOnEsc() {
        // which keyboard
        0 => int device;
        // HID
        Hid hi;
        HidMsg msg;
        // open keyboard (get device number from command line)
        if( !hi.openKeyboard( device ) ) me.exit();
        // infinite event loop
        while( true ){
            // wait for event
            hi => now;

            // get message
            while( hi.recv( msg ) ) {
                if (msg.isButtonDown()) {
                    if(msg.which==1)Machine.remove(1);
                }

                    80::ms => now;
            }
        }
    }
}
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
    <<<"Using default arguments","">>>;
    70=>bpm;
    60/(bpm $ float)=>beat;
    0.5=>volume;
    55=>rootNote;
}
else {
    <<<"Fix your args","">>>;
    <<<"","Expected: bpm:volume:rootNote">>>;
    me.exit();
}

fun void wait(float duration) {
    duration::second=>now;
}

<<<"BPM: "+bpm+", Volume: " +volume+", rootNote: "+rootNote,"">>>;


// patch
Gain input=>Gain finalVolume=>dac;
1=>input.gain;
volume=>finalVolume.gain;
MidiOscillator mOsc;
Sampler sam;
//initialize settingReader first so settings get read first
SettingsReader reader;
reader.init(mOsc, sam);


mOsc.init(input, bpm, volume, rootNote);
sam.init(input, bpm, volume, rootNote);
Main main;
spork~main.exitOnEsc();

while (true) {
    <<<"Running_","">>>;
    2::second=>now;
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
    //finalEnvolope used to be an adsr and proceeds preADSR which is why it is named that way
    ADSR preAdsr[128];
    Envelope finalEnvelope;
    Gain audioSource;
    Gain phaseOne;
    NRev reverbEffect;
    Delay delayEffect;
    Gain gain;
    float attack, delay, sustain, release;
    int reverbActive, delayActive;
    //a list of all the active notes
    IntArray activeNotes;


    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {

        bpm_ =>bpm;
        60/(bpm_ $ float) => beat;
        volume_ => volume;
        rootNote_ => rootNote;
        //audioSource=>phaseOne=>finalEnvelope=>gain=>output;
        audioSource=>phaseOne;
        //phaseOne goes into effectsChain
        //initialize effectsChain
        EffectsChain effectsChain;
        phaseOne =>gain;
        //effectsChain.init(phaseOne,gain);
        //
        gain=>output;
        volume => gain.gain;
        if (volume==0)<<<"VOLUME IS ZERO","">>>;
        //an array of adsr settings: AttackTime, DelayTime, Sustain, Release
        [beat/2, beat, beat/8, beat/8] @=> float preAdsrSettings[];
        //adsr.set(adsrSettings[0]::second, adsrSettings[1]::second, adsrSettings[2], adsrSettings[3]::second);

        //instantiate the elements in the the array
        for (0=>int i;i<oscillators.cap();i++) {
            oscillators[i] =>preAdsr[i]=> audioSource;
            //apply setting to the adsr
            Std.mtof(i) => oscillators[i].freq;
            1 => oscillators[i].gain;

        }
        //listens for key presses to play notes
        spork~listenForEvents();
        //sets adsr values every 20 ms
        spork~setADSR();
    }
    //a function to set the volume
    fun void setVolume(float _volume) {
        _volume=>volume;
        volume=>gain.gain;
    }
    //uses public variables to change the value instead of passing the var in the func
    fun void setADSR() {
        if (sustain ==0)<<<"Sustain is zero!! you wont get any sound from the Osc","">>>;
        //<<<"ADSR: ",attack, " ", delay," ", sustain, " ", release>>>;
        for (0=>int i;i<preAdsr.cap();i++) {
            preAdsr[i].set(attack::second, delay::second, sustain, release::second);
        }

        .2::second=>now;
        setADSR();
    }
    //im using a float as a boolean cause im dumb
    fun void setReverbActive(int f) {
        if (f!=reverbActive) {
            if (f==0) {
                <<<"disconnecting"," reverb">>>;
            }
            else if (f==1) {
                <<<"connecting"," reverb">>>;
            }
        }
        f=>reverbActive;
    }
    fun void setReverbMix(float f) {
        //f=>reverb.mix;
    }
    fun void setRootNote(int rootNote_) {
        if (rootNote==rootNote_) return;
        else {
            rootNote_=>rootNote;
            <<<"rootNote is now: ",rootNote>>>;
            for (0=>int i;i<oscillators.cap();i++) {
                //apply setting to the adsr
                Std.mtof(i) => oscillators[i].freq;
                1 => oscillators[i].gain;

            }
        }
    }

    fun void setDelayActive(int active) {
        if (delayActive==1){

        }
        else if (delayActive==0) {

        }
    }
    fun void setDelayTime(float delayTime){}
    fun void setDelayMax(float delayMax){}
    //a function for debugging
    fun void listenForEvents() {
        // which keyboard
        0 => int device;
        // HID
        Hid hi;
        HidMsg msg;
        // open keyboard (get device number from command line)
        if( !hi.openKeyboard( device ) ) me.exit();
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
        //if (activeNotes.size()>0)finalEnvelope.keyOn();
        activeNotes.print();
        (1/(activeNotes.size()$float))=>audioSource.gain;
    }

    fun void notesOff(int notes[]) {
        for(0=>int i;i<notes.cap();i++) {
            activeNotes.remove(notes[i]);
            preAdsr[rootNote+notes[i]].keyOff();
        }
        if (activeNotes.size() == 0) {
            //finalEnvelope.keyOff();
        }
        activeNotes.print();
        if (activeNotes.size()>1) (1/(activeNotes.size()+1)$float)=>audioSource.gain;
        else 1=>audioSource.gain;
    }

    fun void wait(float duration) {
        duration::second=>now;
    }
}

private class EffectsChain {
    /*
    LIST OF EFFECT UGENS AND THEIR ATTRIBUTES
    */
    UGen effects[8];
    PRCRev reverb@=> effects["reverb"];
    Delay delay@=> effects["delay"];
    Gain gain@=> effects["gain"];
    Phasor phasor@=> effects["phasor"];
    Chorus chorus@=> effects["chorus"];
    PitShift pitShift@=> effects["pitShift"];
    LPF lowPass@=> effects["LPF"];
    HPF highPass@=> effects["HPF"];
    UGen input, output;
    //stores the indices of active EffectsChain
    //0: effect that is after input
    //last element: effect before to output
    IntArray activeEffects;
    fun void init(UGen input_, UGen output_) {
        input_@=>input;
        output_@=>output;
        input=>output;

        /*
        //reverb
        Effect e;
        e.init("reverb");
        //delay
        Effect e;
        e.init("delay");
        //phasor
        Effect e;
        e.init("phasor");
        //chorus
        Effect e;
        e.init("chorus");

        //pitShift
        Effect e;
        e.init("pitShift");

        //LPF
        Effect e;
        e.init("LPF");

        //HPF
        Effect e;
        e.init("HPF");
        */
    }
    fun void add(string effectName){
        /*
        //if the effect with that name is already in the effects chain return
        if (if (activeEffects.contains)) {
            <<<"the effects chain already contains an effect with that name. returning...","">>>;
            return;
        }
        //unhook the relevent effects
        if (effects.cap()==0) {
            input=<output;
        }
        else {
            effects@=>UGen tmp[];
        }
        */
    }

    fun void remove(string name) {

    }
    //since chuck has a wierd thing against booleans, this function returns 1 if the effect is found. Otherwise 0
    fun int contains(string name) {
        for (0=>int i;i<effects.cap();i++) {
            //if (effects[i].name == name) return 1;
        }
        //if it didnt find the loop w/ that name:
        return 0;
    }

    fun void SetEffectVariable(string effectName, string effectVariable, float effectValue) {

    }

}
private class Effect{
    string name;
    UGen generator;
    //before and after are the ugen that lead into and recieve output from the effect;
    UGen before, after;
    fun void init(string name_) {
        if (name =="reverb") {
            name_=>name;
            PRCRev r ;
            0.2=>r.mix;
            r@=> generator;
        }
        else if (name =="delay") {
            name_=>name;
            Delay d;
            d@=>generator;
        }
        else if (name =="phasor") {
            name_=>name;
            Phasor p;
            p@=>generator;
        }
        else if (name =="chorus") {
            name_=>name;
            Chorus c;
            c@=>generator;
        }
        else if (name =="pitShift") {
            name_=>name;
            PitShift p;
            p@=>generator;
        }
        else if (name =="LPF") {
            name_=>name;
            LPF f;
            f@=>generator;
        }
        else if (name =="HPF") {
            name_=>name;
            HPF h;
            h@=>generator;
        }
        else {
            <<<"Didnt recognize that effect name","">>>;
            return;
        }
        name_=>name;
    }
    fun void setEffectParam() {

    }
}
//a class to parse settings.txt to update volume, lfoDepth, etc.
private class SettingsReader {
    MidiOscillator synth;
    Sampler sam;

    ["SynthVolume",
    "attack",
    "delay",
    "sustain",
    "release",
    "reverbActive",
    "reverbMix",
    "delayActive",
    "delayTime",
    "delayMax",
    "synthRootNote"] @=> string varNames[];
    fun void init(MidiOscillator synth_, Sampler sam_) {
        synth_@=>synth;
        sam_@=>sam;
        spork~readData();
    }
    fun void readData() {
        while (true) {
            // default file
            me.sourceDir() + "/settings.txt" => string filename;
            // instantiate
            FileIO fio;
            // open a file
            fio.open( filename, FileIO.READ );
            // ensure it's ok
            if( !fio.good() ) {
                cherr <= "can't open file: " <= filename <= " for reading..." <= IO.newline();
                me.exit();
            }

            // loop until end
            while( fio.more() ) {
                //reads the line and separates it into a string for the variable name and value.
                fio.readLine()=>string line;
                if (line.length()==0) continue;
                line.trim();
                line.find(" ")=>int spaceIndex;
                line.substring(0,spaceIndex)=>string variableName;
                //takes a substring from the spaceIndex+1 to end
                line.substring(spaceIndex+1)=>string variableValue;
                if (variableName=="SynthVolume") {
                    synth.setVolume(Std.atof(variableValue));
                }
                else if (variableName=="attack") {
                    Std.atof(variableValue)=>synth.attack;
                }
                else if (variableName=="delay") {
                    Std.atof(variableValue)=>synth.delay;
                }
                else if (variableName=="sustain") {
                    Std.atof(variableValue)=>synth.sustain;
                }
                else if (variableName=="release") {
                    Std.atof(variableValue)=>synth.release;
                }
                else if (variableName=="reverbActive") {
                    synth.setReverbActive(Std.atoi(variableValue));
                }
                else if (variableName=="reverbMix") {
                    synth.setReverbMix(Std.atof(variableValue));
                }
                else if (variableName=="delayActive") {
                    synth.setDelayActive(Std.atoi(variableValue));
                }
                else if (variableName=="delayTime") {
                    synth.setDelayTime(Std.atof(variableValue));
                }
                else if (variableName=="delayMax") {
                    synth.setDelayMax(Std.atof(variableValue));
                }
                else if (variableName=="synthRootNote") {
                    synth.setRootNote(Std.atoi(variableValue));
                }
            }
            .1::second=>now;
        }
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
        spork~listenForEvents();
    }

    fun void listenForEvents() {
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
    hi hat open
    hi hat closed
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
        else {
            <<<"I didn't recognize that option","">>>;
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
