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


    //Options: "snare", "kick
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
        else if(sampleName=="you will die - edit") {
            localFolder + "Samples/you_will_die.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="there is none") {
            localFolder + "Samples/there_is_none.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else {
            <<<"I didn't recognize that option">>>;
        }
    }
    
    
    
    fun void pattern1() {
        while(true) {
            for (0=>int x;x<2;x++) {
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
}

private class Didgeridoo{
    int bpm, rootNote;
    float volume, beat;
    ADSR adsr;
    Echo echo;
    Impulse impulse;
    Gain gain, volumeGain;
    UGen output;
    //float decay: how fast the note goes quiet 0(instant)-1(never)
    .8 => float decay ;
    fun void init(UGen output_, int bpm_, float volume_, int rootNote_) {
        output => output_;
        impulse => echo => gain => adsr =>volumeGain => output;
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
    
    fun void playNote(int midiNote, float duration) {
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
    
    fun void setADSR(dur attack, dur delay, float sustain, dur release) {
        adsr.set(attack, delay, sustain, release);
    }
    
    fun void setDecay(float decay_) {
        decay_=>decay;
        decay_=>echo.mix;
    }
    
    //minor pentatonic
    fun void pattern1() {
        int duration;
        while (true) {
            [0,5,8,0,5,10] @=> int notes[];
            for (0=>int i;i<notes.cap();i++) {
                1=>duration;
                if(i==2||i==5) {
                    2=>duration;
                }
                playNote(notes[i], duration*beat);
            }
        }
    }
    //minor pentatonic
    fun void pattern2() {
        while(true) {
            [0,3,5,7,10,12]@=>int pentMin[];
            [0,1,2,3,0,1,2,3,0,1,4,5,0,1,4,5] @=> int pattern[];
            for (0=>int i;i<pattern.cap();i++) {
                playNote(pentMin[pattern[i]],beat/2);
                
            }
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
Gain finalGain=>dac;
volume=>finalGain.gain;

PitShift pitShift=> Chorus chorus=>PRCRev reverb =>Gain dig1Gain=>dac;
beat/32=>chorus.modFreq;
.4=>chorus.modDepth;
4=>pitShift.shift;
2=>dig1Gain.gain;
.2=>reverb.mix;
Didgeridoo dig1;
dig1.init(pitShift, bpm, 1.5, rootNote);
dig1.setDecay(.6);
dig1.setADSR((beat/32)::second, (beat/2)::second,1, (beat/4)::second);
spork~dig1.pattern1();
wait(beat*16);
Didgeridoo dig2;
dig2.init(finalGain, bpm, 1, rootNote);
dig2.setDecay(.8);
spork~dig2.pattern2();
wait(beat*16);
Sampler sam;
sam.init(finalGain, bpm,.4,rootNote);
spork~sam.pattern1();
while (true) {
    wait(beat);
}
