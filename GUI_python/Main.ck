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
Recorder recorder;
//initialize settingReader first so settings get read first
SettingsReader reader;
reader.init(mOsc, sam);


mOsc.init(input, bpm, volume, rootNote);
sam.init(input, bpm, volume, rootNote);
recorder.init();
Main main;
spork~main.exitOnEsc();

while (true) {
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
    EffectsChain effectsChain;

    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {

        bpm_ =>bpm;
        60/(bpm_ $ float) => beat;
        volume_ => volume;
        rootNote_ => rootNote;
        //audioSource=>phaseOne=>finalEnvelope=>gain=>output;
        audioSource=>phaseOne;
        //phaseOne =>gain;
        //initialize effectsChain
        effectsChain.init(phaseOne, gain);
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
    LIST OF EFFECTS 
    lfo
        lfoActive 
        lfoShape
        lfoRate
    delay
        delayActive 
        delayBufSize
        delayTime
    reverb 
        reverbActive
        reverbMix
    chorus 
        chorusActive
        chorusModFreq
        chorusModDepth
        chorusMix
    eq
        eqLow
        eqMidLow
        eqMid
        eqHighMid
        eqHigh
    */
    //
    Gain in, out;
    //active effects stores a list of ints that represents the active elements in the patch
    //0 - Input of effects loop
    //1 - lfo
    //2 - Delay
    //3 - Reverb
    //4 - chorus
    //5 - EQ
    //6 - Output of effects loop
    //eg if just reverb and chorus were active activeEffects would look like: 0,3,4,6
    //0 and 6 will always be in activeEffects to avoid edge cases
    //0 and 6 represent input and output Gain
    IntArray activeEffects;
    //init lfo 
    LFO lfo;
    //init delay 
    MyDelay delay;
    //init reverb
    Reverb reverb;
    //init chorus
    MyChorus chorus;
    // init EQ
    EQ eq;
    //the chain of Gains that represent the in/out of each of the elements in the chain
    ["lfo", "delay", "reverb", "chorus", "eq"]
        @=> string effectNames[];
    
    /*a list of all the gain objects in the chain in sequential order
    activeEffects map to chainIndex in the following diagram
    					activeEffect  chainIndex
        in			        0-----------0
        lfo.in				1-----------1
        lfo.out				1-----------2
        delay.in			2-----------3
        delay.out			2-----------4
        reverb.in			3-----------5
        reverb.out			3-----------6
        chorus.in			4-----------7
        chorus.out			4-----------8
        eq.in				5-----------9
        eq.out				5-----------10
        out					6-----------11*/
    Gain chain[];


    fun void init(Gain in_, Gain out_) {
        in_ @=> in;
        out_ @=> out;
        [in, lfo.in, lfo.out, delay.in, delay.out, reverb.in, reverb.out, chorus.in, chorus.out, eq.in, eq.out, out]
        @=>chain;
        activeEffects.add([0,6]);
        //conect the first element in chain to the last
        chain[0] => chain[chain.cap()-1];
        spork~debug();
    }
    //a function that listens to key presses to do debug stuff
    fun void debug() {
        
        // which keyboard
        0 => int device;
        // HID
        Hid hi;
        HidMsg msg;
        // open keyboard (get device number from command line)
        if( !hi.openKeyboard( device ) ) me.exit();
        // infinite event loop
        while( true ) {
            // wait for event
            hi => now;
            // get message
            while( hi.recv( msg ) ){
                // if the button is pressed down
                if( msg.isButtonDown() ) {
                    //<<< "down:", msg.which, "(code)", msg.key, "(usb key)", msg.ascii, "(ascii)" >>>;
                    //A
                    if (msg.which==30) {
                         <<<"activeEffects:","">>>;
                         activeEffects.print();
                    }
                    //S
                    else if (msg.which==31) {
                         <<<"setLfoActive(False);","">>>;
                         setLfoActive("False");
                    }
                    //D
                    else if (msg.which==32) {
                         <<<"setLfoActive(True);","">>>;
                         setLfoActive("True");
                    }
                    //F
                    else if (msg.which==33) {
                         <<<"setLfoShape(Square);","">>>;
                         lfo.setLfoShape("Square");
                    }
                }
                else {
                    //its been released
                }
            }
        }
    }
    //activeStr is either "True" or "False"
    fun void setLfoActive(string activeStr) {
        //the index in activeEffects that represents the lfo
        1=> int currentEffect;
        if (activeStr == "True") {
            if (lfo.active==1) {
                <<<"the lfo is already on","">>>;
                return;
            }
            //connect the effect
            activeEffects.print();
            activeEffects.add(currentEffect, 1);
            activeEffects.indexOf(currentEffect) =>int  index;
            activeEffects.print();
            <<<"index: ",index>>>;
            //get the value in activeEffects of the effect before and after LFO
            activeEffects.get(index -1) => int formerEffectIndex;
            activeEffects.get(index +1) => int latterEffectIndex;
            disconnect(formerEffectIndex, latterEffectIndex);
            connect(formerEffectIndex, currentEffect);
            connect(currentEffect, latterEffectIndex);
            1=>lfo.active;
        }
        else if(activeStr == "False") {
            if (lfo.active==0) {
                <<<"the lfo is already off","">>>;
                return;
            }
            //disconnect the effect
            activeEffects.indexOf(currentEffect) =>int  index;
            //get the value in activeEffects of the effect before and after LFO
            activeEffects.get(index -1) => int formerEffectIndex;
            activeEffects.get(index +1) => int latterEffectIndex;
            disconnect(formerEffectIndex, currentEffect);
            disconnect(currentEffect, latterEffectIndex);
            connect(formerEffectIndex, latterEffectIndex);
            activeEffects.remove(currentEffect);
            0=>lfo.active;

        }
        else {
            <<<"EffectsChain.SetLfoActive() did not recognize that string","">>>;
        }
    }
    //activeStr is either "True" or "False"
    fun void setDelayActive(string activeStr) {
        //the index in activeEffects that represents the delay
        2=> int currentEffect;
        if (activeStr == "True") {
            //connect the effect
            activeEffects.add(currentEffect);
            activeEffects.indexOf(currentEffect) =>int  index;
            //get the value in activeEffects of the effect before and after delay
            activeEffects.get(index -1) => int formerEffectIndex;
            activeEffects.get(index +1) => int latterEffectIndex;
            disconnect(formerEffectIndex, latterEffectIndex);
            connect(formerEffectIndex, currentEffect);
            connect(currentEffect, latterEffectIndex);
        }
        else if(activeStr == "False") {
            //disconnect the effect
            activeEffects.indexOf(currentEffect) =>int  index;
            //get the value in activeEffects of the effect before and after delay
            activeEffects.get(index -1) => int formerEffectIndex;
            activeEffects.get(index +1) => int latterEffectIndex;
            disconnect(formerEffectIndex, currentEffect);
            disconnect(currentEffect, latterEffectIndex);
            connect(formerEffectIndex, latterEffectIndex);
            activeEffects.remove(currentEffect);

        }
        else {
            <<<"EffectsChain.SetLfoActive() did not recognize that string","">>>;
        }
    }
    //activeStr is either "True" or "False"
    fun void setReverbActive(string activeStr) {
        //the index in activeEffects that represents the delay
        3=> int currentEffect;
        if (activeStr == "True") {
            //connect the effect
            activeEffects.add(currentEffect);
            activeEffects.indexOf(currentEffect) =>int  index;
            //get the value in activeEffects of the effect before and after reverb
            activeEffects.get(index -1) => int formerEffectIndex;
            activeEffects.get(index +1) => int latterEffectIndex;
            disconnect(formerEffectIndex, latterEffectIndex);
            connect(formerEffectIndex, currentEffect);
            connect(currentEffect, latterEffectIndex);
        }
        else if(activeStr == "False") {
            //disconnect the effect
            activeEffects.indexOf(currentEffect) =>int  index;
            //get the value in activeEffects of the effect before and after reverb
            activeEffects.get(index -1) => int formerEffectIndex;
            activeEffects.get(index +1) => int latterEffectIndex;
            disconnect(formerEffectIndex, currentEffect);
            disconnect(currentEffect, latterEffectIndex);
            connect(formerEffectIndex, latterEffectIndex);
            activeEffects.remove(currentEffect);

        }
        else {
            <<<"EffectsChain.SetLfoActive() did not recognize that string","">>>;
        }
    }
    //activeStr is either "True" or "False"
    fun void setChorusActive(string activeStr) {
        //the index in activeEffects that represents the chorus
        4=> int currentEffect;
        if (activeStr == "True") {
            //connect the effect
            activeEffects.add(currentEffect);
            activeEffects.indexOf(currentEffect) =>int  index;
            //get the value in activeEffects of the effect before and after chorus
            activeEffects.get(index -1) => int formerEffectIndex;
            activeEffects.get(index +1) => int latterEffectIndex;
            disconnect(formerEffectIndex, latterEffectIndex);
            connect(formerEffectIndex, currentEffect);
            connect(currentEffect, latterEffectIndex);
        }
        else if(activeStr == "False") {
            //disconnect the effect
            activeEffects.indexOf(currentEffect) =>int  index;
            //get the value in activeEffects of the effect before and after chorus
            activeEffects.get(index -1) => int formerEffectIndex;
            activeEffects.get(index +1) => int latterEffectIndex;
            disconnect(formerEffectIndex, currentEffect);
            disconnect(currentEffect, latterEffectIndex);
            connect(formerEffectIndex, latterEffectIndex);
            activeEffects.remove(currentEffect);

        }
        else {
            <<<"EffectsChain.SetLfoActive() did not recognize that string","">>>;
        }
    }
    //activeStr is either "True" or "False"
    fun void setEQActive(string activeStr) {
        //the index in activeEffects that represents the eq
        5=> int currentEffect;
        if (activeStr == "True") {
            
            //connect the effect
            activeEffects.add(currentEffect);
            activeEffects.indexOf(currentEffect) =>int  index;
            //get the value in activeEffects of the effect before and after eq
            activeEffects.get(index -1) => int formerEffectIndex;
            activeEffects.get(index +1) => int latterEffectIndex;
            disconnect(formerEffectIndex, latterEffectIndex);
            connect(formerEffectIndex, currentEffect);
            connect(currentEffect, latterEffectIndex);
        }
        else if(activeStr == "False") {
            
            //disconnect the effect
            activeEffects.indexOf(currentEffect) =>int  index;
            //get the value in activeEffects of the effect before and after eq
            activeEffects.get(index -1) => int formerEffectIndex;
            activeEffects.get(index +1) => int latterEffectIndex;
            disconnect(formerEffectIndex, currentEffect);
            disconnect(currentEffect, latterEffectIndex);
            connect(formerEffectIndex, latterEffectIndex);
            activeEffects.remove(currentEffect);

        }
        else {
            <<<"EffectsChain.SetLfoActive() did not recognize that string","">>>;
        }
    }
    //takes two numbers from the activeEffects[] and disconnects their Gains in the chain array
    //also a => b (a is connected to b)
    fun void disconnect(int a, int b) {
        activeEffectsToChainIndex(a, "out")=>int chainIndexA;
        activeEffectsToChainIndex(b, "in") => int chainIndexB;
        <<<"disconnecting ",a, " from ",b>>>;
       <<<"chain[",chainIndexA,"] =< chain[",chainIndexB,"]">>>;
        chain[chainIndexA]=< chain[chainIndexB];
    }
    //takes two numbers from the activeEffects[] and connects their Gains in the chain array
    fun void connect(int a, int b) {
        activeEffectsToChainIndex(a, "out")=>int chainIndexA;
        activeEffectsToChainIndex(b, "in") => int chainIndexB;
       <<<"connecting ",a, " to ",b>>>;
       <<<"chain[",chainIndexA,"] => chain[",chainIndexB,"]">>>;
        chain[chainIndexA]=> chain[chainIndexB];
    }
    //this function takes the index from active effects and a string that is either "in or "out" 
    //the functionreturns the index of the respective Gain object in chain
    /*a list of all the gain objects in the chain in sequential order
    activeEffects map to chainIndex in the following diagram
    					activeEffect  chainIndex
        in			        0-----------0
        lfo.in				1-----------1
        lfo.out				1-----------2
        delay.in			2-----------3
        delay.out			2-----------4
        reverb.in			3-----------5
        reverb.out			3-----------6
        chorus.in			4-----------7
        chorus.out			4-----------8
        eq.in				5-----------9
        eq.out				5-----------10
        out					6-----------11*/
    fun int activeEffectsToChainIndex(int a, string inOut) {
        a*2=>int result;
        if (inOut=="in") result-1 => result;
        else if (inOut=="out") ;
        else <<<"wierd option. didnt recognize in EffectsChain.activeEffectsToChainIndex()","">>>;
        return result;
    }

}

//note: I was gonna have them all extend from one class to simplify common functionality, but chuck's extensio system is horrible.
//lfo delay, reverb,chorus, eq
private class LFO {
    //the setup of the lfo
    //in                                    => inputGain(1-lfoDepth)        =>      out
    //                                                                            /
    //lfoOsc    =>      modulatedChannel     => modulatedGain(lfoDepth)      =>
    //in        =>    /    
    0=> int active;
    float lfoDepth;
    float lfoFreq;
    Gain in =>Gain inputGain =>Gain out;
    0.2=>inputGain.gain;
    in => Gain modulatedChannel=> Gain modulatedGain=> out;
    modulatedChannel.op(3);
    Gain lfoOscGain => modulatedChannel;
    1=>modulatedGain.gain;
    //chuck is kinda weird so to have a bunch of types of oscillators(sqre, sin saw) I need to create an array of osc' connected to gains, and set the gain to set the type of oscillator
    // all the different oscs are connected in parallel to an array of gain objects. the gains are then connected to lfoOscGain and through the system
    //setting the gains determins the shape of the lfo
    SqrOsc a;
    SinOsc b;
    TriOsc c;
    SawOsc d;
    PulseOsc e;
    Noise n;
    //[SqrOsc a, SinOsc b, TriOsc c, SawOsc d, PulseOsc e, Noise n] @=> Osc oscillators[];
    [a, b, c, d, e, n] @=> UGen oscillators[];
    setLfoFreq(1);
    Gain oscGains[oscillators.cap()];
    for (0=>int i;i<oscillators.cap();i++) {
        1=>oscillators[i].gain;
        oscillators[i]=>oscGains[i] =>lfoOscGain;
        0=>oscGains[i].gain;
    }
    1=>oscGains[1].gain;
    
    
    fun void setLfoDepth(float lfoDepth_) {
        //check that its from 0-1
        if (lfoDepth_<0 || lfoDepth_ >1) {
            <<<"invalid arg for lfoDepth. expected a number from [0-1], but got ", lfoDepth_>>>;
            return;
        }
        lfoDepth_=>lfoDepth;
        (1-lfoDepth) =>inputGain.gain;
        lfoDepth => modulatedGain.gain;
    }
    fun void setLfoFreq(float freq) {
        freq => lfoFreq;
        //freq=>lfoOsc.freq;
        freq=>a.freq;
        freq=>b.freq;
        freq=>c.freq;
        freq=>d.freq;
        freq=>e.freq;
    }
    //sets the lfo shape options are "Square", "Sine", "Tri", "Saw", "Pulse" "Noise"
    fun void setLfoShape (string name) {
        if (name =="Square") {
            //set all the other gains to zero, except the saw
            for (0=>int i;i<oscGains.cap();i++) {
                0=>oscGains[i].gain;
                if (i==0) 1=>oscGains[i].gain;
            }
        }
        else if (name =="Sine") {
            for (0=>int i;i<oscGains.cap();i++) {
                0=>oscGains[i].gain;
                if (i==1) 1=>oscGains[i].gain;
            }
        }
        else if (name =="Tri") {
            for (0=>int i;i<oscGains.cap();i++) {
                0=>oscGains[i].gain;
                if (i==2) 1=>oscGains[i].gain;
            }
        }
        else if (name =="Saw") {
            for (0=>int i;i<oscGains.cap();i++) {
                0=>oscGains[i].gain;
                if (i==3) 1=>oscGains[i].gain;
            }
        }
        else if (name =="Pulse") {
            for (0=>int i;i<oscGains.cap();i++) {
                0=>oscGains[i].gain;
                if (i==4) 1=>oscGains[i].gain;
            }
        }
        else if (name =="Noise") {
            for (0=>int i;i<oscGains.cap();i++) {
                0=>oscGains[i].gain;
                if (i==5) 1=>oscGains[i].gain;
            }
        }
        else {
            <<<"didnt recognize that option"," LFO.setLfoShape()">>>;
        }
    }
}
private class MyDelay  {
    0=> int active;
    Gain in, out;
    in => Delay delay => out;
}
private class Reverb  {
    0=> int active;
    Gain in, out;
    in => PRCRev reverb => out;
}
private class MyChorus  {
    0=> int active;
    Gain in, out;
    in => Chorus chorus => out;
}
private class EQ  {
    0=> int active;
    Gain in, out;
    //eq has 5 different frequecy ranges connected in parallel
    in=>LPF lpfLowEq=>Gain eqLow=> out;
    75=>lpfLowEq.freq;

    in=>LPF lpfMidLowEq=>HPF hpfMidLowEq=>Gain eqMidLow=> out;
    75=>hpfMidLowEq.freq;
    100=> lpfMidLowEq.freq;

    in=>LPF lpfMidEq=>HPF hpfMidEq=>Gain eqMid=> out;
    100=>hpfMidEq.freq;
    2500=> lpfMidEq.freq;

    in=>LPF lpfHighMidEq=>HPF hpfHighMidEq=>Gain eqHighMid=> out;
    2500=>hpfHighMidEq.freq;
    7500=> lpfHighMidEq.freq;

    in=>HPF hpfHighEq=>Gain eqHigh=> out;
    7500=>hpfHighEq.freq;
}


private class Recorder {
    //the id of the shred that is currently recording. 
    //if there is no shred recording it is -1
    -1=>int recordShredID;
    RandomWordGenerator randomWord;
    fun void init() {
        //spork~listenForEvents();
    }
    fun void listenForEvents() {
        
        // which keyboard
        0 => int device;
        // HID
        Hid hi;
        HidMsg msg;
        // open keyboard (get device number from command line)
        if( !hi.openKeyboard( device ) ) me.exit();
        // infinite event loop
        while( true )
        {
            
            // wait for event
            hi => now;

            // get message
            while( hi.recv( msg ) )
            {
                // if the button is pressed down
                if( msg.isButtonDown() )
                {
                    //<<< msg.which,"">>>;
                    //if tab was pressed
                    if (msg.which== 15) {
                        if (recordShredID==-1) {
                            //start a new record shred
                            <<<"tab","">>>;
                            //spork~startRecording() @=> Shred offspring;
                            (randomWord.next()+randomWord.next()+randomWord.next())=>string fileName;
                            Machine.add("record.ck:"+fileName)=>recordShredID;
                        }
                        else {
                            //close the current record shred
                            Machine.remove(recordShredID);
                            //reset id
                            -1=>recordShredID;
                        }
                    }

                    80::ms => now;
                }
                else //its been released
                {
                    
                }
            }
        }

    }

    //this function is called when the user presses tab and there is no shred currently recording
    fun void startRecording() {
        dac => Gain g => WvOut w => blackhole;
        "chuck-session" => w.autoPrefix;
        //recording folder
        "C:\\Users\\Calvin\\Documents\\Chuck-Scripts\\Recordings\\"=> string folder;
        // this is the output file name
        (randomWord.next()+randomWord.next()+randomWord.next())=>string fileName;
        folder + fileName => w.wavFilename;

        // print it out
        <<<"writing to file: ", w.filename()>>>;

        // any gain you want for the output
        .5 => g.gain;

        // temporary workaround to automatically close file on remove-shred
        null @=> w;

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
                    //synth.setReverbActive(Std.atoi(variableValue));
                }
                else if (variableName=="reverbMix") {
                    //synth.setReverbMix(Std.atof(variableValue));
                }
                else if (variableName=="delayActive") {
                    //synth.setDelayActive(Std.atoi(variableValue));
                }
                else if (variableName=="delayTime") {
                    //synth.setDelayTime(Std.atof(variableValue));
                }
                else if (variableName=="delayMax") {
                    //synth.setDelayMax(Std.atof(variableValue));
                }
                else if (variableName=="synthRootNote") {
                    //synth.setRootNote(Std.atoi(variableValue));
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
        me.sourceDir()+"../Samples/" => samplesFolder;
        //"C:\\Users\\Calvin\\Documents\\Chuck-Scripts\\Samples\\" => samplesFolder;
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

private class RandomWordGenerator {
    ["1.", "Eventually", "as", "my", "whole", "world", "comes", "down", "around", "me", "show", "me", "no", "pity", "as", "i", "ease", "into", "a", "suicidal", "laughter", "with", "the", "setting", "sun,", "my", "father's", "gun", "is", "whispering", "and", "as", "my", "family", "dies", "from", "cancer", "i", "am", "teary-eyed", "and", "weak", "i'm", "not", "weary", "of", "disasters", "the", "end", "is", "numb,", "for", "everyone,", "eventually", "and", "as", "my", "friendships", "are", "decaying", "and", "we're", "all", "waking", "from", "the", "dream", "this", "dying", "day", "just", "ain't", "worth", "saving", "so", "i", "hide", "away,", "in", "my", "poison", "brain,", "trying", "to", "sleep", "2.", "Loss", "Memory", "how", "do", "i", "wake", "up?", "how", "do", "i", "get", "free?", "tethered", "to", "an", "anchor", "of", "loss", "memory", "dreaming", "so", "long", "dreaming", "so", "lonely", "i", "get", "a", "phone", "call,", "no", "one's", "on", "the", "line", "i", "take", "in", "their", "silence", "and", "say", "my", "goodbyes", "dreaming", "so", "long", "dreaming", "so", "lonely", "3.", "Phillip", "02:14", "i", "woke", "up", "so", "tired", "drag", "me", "through", "the", "light", "i've", "been", "alone", "for", "so", "long", "hello", "sad", "world", "take", "me", "in,", "let", "me", "know", "i've", "been", "alone", "for", "so", "long", "i'm", "through", "begging", "off", "an", "eternity", "of", "loss", "i've", "been", "alone", "for", "so", "long", "so", "long", "4.", "Tether", "03:28", "i'm", "the", "fucked", "up", "kid", "in", "school", "dead", "in", "the", "eyes", "of", "the", "rules", "i", "got", "sent", "home", "for", "throwing", "up", "my", "friends", "think", "being", "sick", "is", "cool", "and", "my", "dad", "beat", "up", "my", "mom", "because", "she's", "an", "alcoholic", "but", "he's", "an", "alcoholic", "too", "through", "the", "looking", "glass", "of", "abuse", "i", "want", "to", "sleep", "next", "to", "you", "after", "school", "before", "my", "mom", "calls", "to", "see", "when", "i'm", "coming", "home", "i", "can", "finally", "see", "where", "the", "tether", "ends", "mortally", "coiled", "around", "nothingness", "i'm", "the", "fucked", "up", "kid", "in", "school", "maybe", "i'll", "join", "the", "army", "no", "one", "will", "ever", "know", "me", "truly", "my", "rage", "has", "silenced", "a", "cry", "for", "help", "my", "mom's", "dealer", "put", "a", "gun", "to", "my", "head", "for", "a", "laugh,", "for", "his", "friends", "and", "in", "that", "moment", "i", "knew", "i", "could", "kill", "my", "mother's", "prison", "is", "herself", "i", "want", "to", "sleep", "next", "to", "you", "after", "school", "before", "my", "mom", "calls", "to", "see", "when", "i'm", "coming", "home", "i", "can", "finally", "see", "where", "the", "tether", "ends", "mortally", "coiled", "around", "nothingness", "5.", "Thunder", "02:38", "can", "you", "face", "me?", "i", "already", "know", "the", "answer", "if", "it's", "over,", "let's", "go", "our", "separate", "ways", "when", "the", "thunder", "calls", "to", "me", "then", "i'll", "come", "over", "i", "am", "waiting", "with", "an", "open", "mind", "i", "am", "drawn", "to", "the", "mirror", "in", "a", "dull", "revulsion", "i", "forgive", "you", "but", "i", "do", "not", "know", "why", "6.", "Ambrosia", "in", "the", "Bitter", "World", "02:35", "ambrosia", "in", "the", "bitter", "world", "i", "cling", "to", "your", "light", "to", "keep", "from", "sinking", "down", "the", "clouds", "rip", "open", "and", "the", "rain", "reaches", "out", "to", "the", "people", "who", "just", "want", "to", "drown", "and", "now", "my", "heart", "aches", "but", "it", "keeps", "pounding", "to", "crush", "my", "little", "world", "and", "leave", "me", "dreaming", "in", "endless", "silence,", "only", "of", "you", "ambrosia", "i", "was", "once", "a", "little", "girl,", "i", "was", "twisted", "into", "what", "i", "am", "now", "my", "heart", "is", "open", "but", "i", "don't", "know", "how", "to", "reach", "out", "and", "be", "a", "person", "so", "i", "up", "and", "drown", "and", "now", "my", "heart", "aches", "but", "it", "keeps", "pounding", "to", "crush", "my", "little", "world", "and", "leave", "me", "dreaming", "in", "endless", "silence,", "only", "of", "you", "ambrosia", "7.", "Burden", "03:04", "when", "you", "get", "off", "work", "come", "by", "my", "house,", "and", "lay", "your", "burden", "down", "may", "the", "world", "the", "keep", "spinning", "until", "it", "spirals", "out", "lay", "your", "burden", "down", "my", "mom's", "gone", "to", "california", "they", "got", "a", "treatment", "center", "there", "my", "mom", "had", "a", "fucked", "up", "childhood", "that's", "the", "burden", "that", "we", "both", "bear", "lay", "your", "burden", "down", "i", "quit", "drinking,", "but", "i", "still", "smoke,", "lay", "your", "burden", "down", "carried", "down", "a", "highway", "with", "nowhere", "else", "to", "go", "lay", "your", "burden", "down", "my", "mom's", "gone", "to", "california", "they", "got", "a", "treatment", "center", "there", "my", "mom", "had", "a", "fucked", "up", "childhood", "that's", "the", "burden", "that", "we", "both", "bear", "lay", "your", "burden", "down", "8.", "Running", "Wide", "Open", "02:43", "traffic", "lights", "turning", "blue", "everyone", "that", "we", "burn", "through", "only", "me", "and", "you,", "queen", "of", "booze", "ain't", "no", "furniture", "in", "our", "house", "no", "screaming", "and", "fighting", "anymore", "the", "living", "room", "turns", "blue", "we're", "both", "sleeping", "on", "the", "floor", "i", "want", "to", "be", "an", "engine", "running", "wide", "open", "running", "wide", "open", "until", "i", "can't", "run", "no", "more", "living", "with", "one", "eye", "closed", "and", "one", "eye", "on", "the", "cage", "door", "everyday", "is", "the", "day", "that", "i'll", "die", "and", "be", "afraid", "no", "more", "when", "dad", "found", "out", "about", "where", "we", "were", "hiding", "out", "he", "came", "down", "like", "a", "sea", "of", "rage,", "crashing", "onto", "the", "shore", "i", "want", "to", "be", "an", "engine", "running", "wide", "open", "running", "wide", "open", "until", "i", "can't", "run", "no", "more", "i", "let", "the", "years", "go", "by,", "i", "let", "no", "one", "know", "what's", "inside", "my", "broken", "heart", "keeps", "a", "beat", "just", "fine", "i", "don't", "want", "to", "die", "no", "more", "i", "see", "my", "future", "and", "my", "past", "all", "at", "once", "in", "a", "lightning", "flash", "all", "you", "can", "do", "is", "laugh", "until", "you", "just", "can't", "no", "more", "i", "want", "to", "be", "an", "engine", "running", "wide", "open", "running", "wide", "open", "until", "i", "can't", "run", "no", "more", "i", "want", "to", "be", "an", "engine", "running", "wide", "open", "running", "wide", "open", "until", "i", "can't", "run", "no", "more", "9.", "Window", "02:41", "closing", "my", "eyes", "when", "i", "drive", "back", "in", "my", "hometown,", "past", "every", "bar", "i've", "been", "thrown", "out", "i", "can't", "make", "it", "to", "class", "so", "i'm", "drunk", "in", "my", "car", "i", "can't", "roll", "my", "window", "up", "the", "glass", "is", "stuck", "in", "the", "door", "at", "home", "there's", "blood", "on", "my", "bed", "and", "no", "running", "water", "there", "is", "a", "room", "i", "don't", "go", "in", "i", "see", "myself", "through", "the", "door", "me", "and", "my", "mom", "used", "to", "hide", "there", "crying", "our", "prayers", "through", "a", "window", "a", "fig", "tree", "covered", "in", "water", "holds", "the", "moonlight", "like", "a", "prison", "Sad", "World", "rot", "me", "around", "your", "sword,", "paint", "me", "wet", "i", "don't", "want", "to", "dry", "out", "just", "yet", "rot", "me", "alcoholic", "womb,", "i", "want", "to", "burn", "my", "way", "through", "this", "world", "consumed", "with", "you", "i've", "got", "a", "bad", "idea", "let's", "lose", "our", "minds", "in", "love", "with", "bad", "ideas", "so", "long", "sad", "world,", "goodbye", "peeling", "back", "the", "skin,", "i", "want", "to", "see", "the", "mask", "you", "wear", "within,", "beneath", "your", "eyes", "gnawing", "at", "your", "mind", "i", "want", "to", "wither", "away", "in", "your", "love", "until", "i", "die", "i've", "got", "a", "bad", "idea", "let's", "lose", "our", "minds", "in", "love", "with", "bad", "ideas", "so", "long", "sad", "world,", "goodbye"]
        @=> string words[];
    fun string next() {
        return words[Math.random2(0, words.cap()-1)];
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
    //add a single int at an index
    //ie 0 would be the start (new) size - 1 would be the end
    fun void add(int element, int index) {
        //if its empty
        if (elements==null) {
            [element]@=> elements;
        }
        if (index>elements.cap()) {
            <<<"index error IntArray.add(element, index)","">>>;
            return;
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
            //switch the last element with the element at index
            
            elements[index]=>int tmp;
            elements[elements.cap()-1]=>elements[index];
            tmp=> elements[elements.cap()-1];
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
