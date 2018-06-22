
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
        dig.playNote(notes[i], duration*beat/2, .4);
    }
}
