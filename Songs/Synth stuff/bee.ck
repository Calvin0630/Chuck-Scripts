
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
private class Bee {
    SqrOsc osc;
    ADSR adsr;
    100=>osc.freq;
    float beat, volume;
    int rootNote;
    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {
        osc =>adsr=> output;
        bpm_ =>bpm;
        60/(bpm_ $ float) => beat;
        volume_ => volume;
        rootNote_ => rootNote;
        adsr.set((beat/4)::second, (beat/16)::second, beat/4, (beat)::second);
    }
    fun void start() {
        int randomX;
        1=>int i;
        while (true) {
            Math.random2(0,100)=>randomX;
            
            if (randomX%3 ==2) {
                //<<<"up">>>;
                i++;
            }
            else if(randomX%3==1) {
                //<<<"same">>>;
            }
            else if(randomX%3==0) {
                //<<<"down">>>;
                i--;
            }
            
            if(i<=0) {
                11=>i;
            }
            else if (i>=12) {
                0=>i;
            }
            Std.mtof(rootNote+i)=>osc.freq;
            wait(beat/128);
        }
    }
    fun void off() {
        adsr.keyOff();
    }
    fun void on() {
        adsr.keyOn();
    }
    fun void setRoot(int rootNote_) {
        rootNote_=>rootNote;
    }
}
Gain gain => PRCRev reverb=> dac;
.2=>reverb.mix;
volume=>gain.gain;
Bee bee;
bee.init(gain, bpm, volume, rootNote);
spork~bee.start();

[0,16,31]@=>int notes[];
while(true) {
    for(0=>int i;i<notes.cap();i++) {
        bee.setRoot(rootNote+notes[i]);
        bee.off();
        wait(beat/2);
        bee.on();
        wait(beat);
    }
}