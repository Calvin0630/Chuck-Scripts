
private class Didgeridoo{
    int bpm, rootNote;
    float volume, beat;
    ADSR adsr;
    Echo echo;
    Impulse impulse;
    Gain gain, volumeGain;
    UGen output;
    fun void init(UGen output_, int bpm_, float volume_, int rootNote_) {
        output => output_;
        impulse => echo => gain => adsr =>Chorus chorus=>PRCRev reverb =>volumeGain => output;
        (1/Std.mtof(rootNote_))=>chorus.modFreq;
        .5=>chorus.modDepth;
        .2=>reverb.mix;
        gain=>echo;
        bpm_=>bpm;
        (60/(bpm$float))=>beat;
        volume_=>volumeGain.gain;
        rootNote_=>rootNote;
    }
    
    //waits for duration(seconds)
    fun void wait(float duration) {
        duration::second=>now;
    }
    
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
    fun void pattern1() {
        [0,3,5,8,5,8,3,5]@=> int scale[];
        while(true) {
            for (0=>int i;i<scale.cap();i++) {
                playNote(scale[i],3*beat/4,.3); 
                wait(beat/4);
            }
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
    string localFolder;
    Gain gain;
    
    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {
        gain => output;
        me.sourceDir() => localFolder;
        bpm_ =>bpm;
        60/(bpm_ $ float)=>beat;
        volume_ => volume;
        rootNote_ => rootNote;
        volume =>gain.gain;
    }

    fun void wait(float duration) {
        duration::second=>now;
    }


    /*Options:
   snare
   kick
   rant: a religious rant with google translate
   pizza time
   death
   you will die
    there is none
   despacito song
   despacito
   */ 
    fun void loadSample(string sampleName) {
        SndBuf buf=>gain;
        string filePath; 
        if (sampleName == "snare") {
            localFolder + "Samples/Snares/Cymatics - Snare 1.wav" =>filePath;
            filePath =>buf.read;
        }
        else if(sampleName == "kick") {
            localFolder + "Samples/Kicks/Cymatics - Kick 1 - C.wav" =>filePath;
            filePath =>buf.read;
        }
        else if(sampleName=="rant") {
            localFolder + "Samples/rant.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="pizza time") {
            localFolder + "Samples/pizza_time.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;

        }
        else if(sampleName=="death") {
            localFolder + "Samples/death.wav" =>filePath;
            filePath =>buf.read;
        }
        else if(sampleName=="you will die") {
            localFolder + "Samples/you_will_die.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="there is none") {
            localFolder + "Samples/there_is_none.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="despacito song") {
            localFolder + "Samples/despacito_song.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="despacito") {
            localFolder + "Samples/despacito.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else {
            <<<"I didn't recognize that option">>>;
        }
    }
    
    
    
    fun void pattern1() {
        while(true) {
            for (0=>int x;x<4;x++) {
                for(0=>int i;i<4;i++) {
                    if (i==0) {
                        loadSample("kick");
                        wait(beat);
                    }
                    else if(i==1) {
                        if (x==0) {
                            loadSample("death");
                            wait(beat);
                        }
                        else if (x==1) {
                            spork~loadSample("there is none");
                            wait(beat);
                        }
                        else if (x==2||x==3) {
                            spork~loadSample("despacito");
                            wait(beat);
                        }
                    }
                    else if(i==2) {
                        repeat(2) {
                            loadSample("kick");
                            wait(beat/2);
                        }
                    }
                    else if(i==3) {
                        if(x==0) {
                            loadSample("snare");
                            wait(beat);
                        }
                        else if(x==1) {
                            repeat(8) {
                                loadSample("snare");
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
            loadSample("snare");
            wait(duration);
            2/=>duration;
        }
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
else {
    <<<"Fix your args">>>;
    me.exit();
}

fun void wait(float duration) {
    duration::second=>now;
}

fun void moog(UGen output, int bpm_, float volume_, int rootNote_) {
    //arguements separated by a colon
    bpm_=>int bpm;
    //the time(seconds) of one beat
    (60/(bpm $ float))=>float beat;
    //a number between 0 and 1 that sets the volume
    volume_=>float volume;
    //the midi int of the root note
    rootNote_=> int rootNote;
    // patch
    Moog moog => LPF lpf => output;
    400=>lpf.freq;
    
    // scale
    [0, 3,5,8,5,3,5,3] @=> int scale[];
    /*
    Math.random2f( 0, 1 ) => moog.filterQ; //0-1
    Math.random2f( 0, 1 ) => moog.filterSweepRate; //0-1
    Math.random2f( 0, 12 ) => moog.lfoSpeed; //0-12
    Math.random2f( 0, 1 ) => moog.lfoDepth;//0-1
    Math.random2f( 0, 1 ) => moog.volume;//0-1
    */

    1 => moog.filterQ; //0-1
    .5 => moog.filterSweepRate; //0-1
    12 => moog.lfoSpeed; //0-12
    .2 => moog.lfoDepth;//0-1
    .7 => moog.volume;//0-1

    // infinite time loop
    while( true )
    {
        for(0=>int i;i<scale.cap();i++) {
            // set freq
            rootNote + scale[i] => Std.mtof => moog.freq;

            // go
            moog.noteOn(volume);

            // advance time
            wait(3*beat/4);
            moog.noteOff(1);
            wait(beat/4);
        }
    }
}

//spork~moog(dac, bpm, volume, rootNote)@=>Shred moogShred;
Didgeridoo dig;
dig.init(dac, bpm, volume*3, rootNote);
spork~dig.pattern1();
Sampler sam2;
sam2.init(dac, bpm, volume/2, rootNote);
Sampler sam;
sam.init(dac, bpm, volume/4, rootNote);
while(true) {
    spork~sam.roll(beat/2)@=>Shred roller;
    wait(3*beat/2);
    roller.exit();
    wait(beat/2);
    
    
}
