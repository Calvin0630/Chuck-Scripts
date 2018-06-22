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

// impulse to filter to dac
Impulse i  => BiQuad f  => dac;
SinOsc osc => blackhole;
1 => osc.gain;
beat/4 => osc.freq;
// set the filter's pole radius
.99 => f.prad; 
// set equal gain zeros
1 => f.eqzs;
// set filter gain
volume => f.gain;

fun void click(int midiNote, float duration) {
    // set the current sample/impulse
    1 => i.next;
    std.mtof(midiNote) => f.pfreq;
    duration::second =>now;
}
while (true) {
    repeat(4) {
        click(rootNote , beat/4);
        wait(beat/4);
    }
    repeat(4) {
        click(rootNote , beat/16);
        wait(beat/16);        
    }
    repeat(3) {
        click(rootNote , beat/4);
        wait(beat/4);
    }
}