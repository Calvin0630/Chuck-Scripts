//recommended args: 70:.6:43
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
        impulse => echo => gain => adsr=> Phasor phasor =>volumeGain => output;
        1=>phasor.freq;
        .5=> phasor.sfreq;
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
    
    fun void pattern2() {
        rootNote-12=>rootNote;
        [[0,3,7],   //Gmaj
        [7,10,14],  //Dmin
        [5,9,12],   //Cmaj
        [3,6,10]]   //A#min
            @=>int chords[][];
        while(true) {
            for (0=>int i;i<chords.cap();i++) {
                //play the chords
                for (0=>int j;j<chords[i].cap();j++) {
                    spork~playNote(chords[i][j], 4*beat, .95);
                }
                wait(4*beat);
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
            samplesFolder + "Snares/Cymatics - Snare 1.wav" =>filePath;
            filePath =>buf.read;
        }
        else if(sampleName == "kick") {
            samplesFolder + "Kicks/Cymatics - Kick 1 - C.wav" =>filePath;
            filePath =>buf.read;
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
        }
        else if(sampleName=="you will die") {
            samplesFolder + "you_will_die.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="there is none") {
            samplesFolder + "there_is_none.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="despacito song") {
            samplesFolder + "despacito_song.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="despacito") {
            samplesFolder + "despacito.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="riff 1") {
            samplesFolder + "riff_1(70bpm,16beats).wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="waterfall") {
            samplesFolder + "Allen_gardens_waterfall.wav" =>filePath;
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
            <<<duration,"">>>;
            loadSample("snare");
            wait(duration);
            2/=>duration;
        }
    }
    
    fun void riff1() {
        while(true) {
            spork~loadSample("riff 1");
            wait(16*beat);
        }
    }
    
}


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

Gain gain=>dac;
Sampler sam;
sam.init(gain, bpm, volume*2, rootNote);
spork~sam.riff1();
Sampler sam2;
Gain sam2Out=>PitShift shift=>PRCRev reverb=>gain;
-.5=>shift.shift;
.3=>reverb.mix;
sam2.init(sam2Out, bpm, volume, rootNote);
spork~sam2.loadSample("waterfall");
Didgeridoo dig;
dig.init(gain, bpm, volume, rootNote);
spork~dig.pattern2();
while(true) {
    //sam.roll(beat);
    wait(beat);
}

