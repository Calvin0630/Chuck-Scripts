SinOsc osc => dac;
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


//int is the midi note value, duration is the time (seconds) to 
//play the note
fun void playNote(int midiNote, float duration) {
    volume => osc.gain;
    Std.mtof(midiNote) => osc.freq;
    duration::second => now;
    0 => osc.gain;
}

fun void wait(float duration) {
    duration::second=>now;
}
[0,7,3,9] @=> int offset[];

0=> int i;
while (true) {
    if (i>=offset.cap())0=>i;
    playNote(rootNote + offset[i], beat/16);
    wait(beat/16);
    i++;
}

