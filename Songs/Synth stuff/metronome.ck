//arguements separated by a colon
int bpm;
//the time(seconds) of one beat
float beat;
//a number between 0 and 1 that sets the volume
float volume;
//the midi int of the root note
int rootNote;

//take in the command line args
if(me.args() == 2) {
    Std.atoi(me.arg(0)) =>bpm;
    60/Std.atof(me.arg(0)) => beat;
    Std.atof(me.arg(1)) => volume;
}
else {
    <<<"Fix your args\nExpected: bpm:volume">>>;
    me.exit();
}
fun void wait(float duration) {
    duration::second=>now;
}

// impulse to filter to dac
Impulse i => BiQuad f=> Pan2 p  => dac;
SinOsc osc => blackhole;
1 => osc.gain;
2 => osc.freq;
// set the filter's pole radius
.99 => f.prad; 
// set equal gain zeros
1 => f.eqzs;
// set filter gain
volume => f.gain;

fun void click(int midiNote) {
    // set the current sample/impulse
    1 => i.next;
    Std.mtof(midiNote) => f.pfreq;
    0::second =>now;
}
0 => int x;
while (true) {
    click(rootNote);
    wait(beat);
    /*
    if (x>64)0 => x;
    osc.last() => p.pan;
    click(rootNote + x, beat/64);
    wait(beat/64);
    x++;
    */
}