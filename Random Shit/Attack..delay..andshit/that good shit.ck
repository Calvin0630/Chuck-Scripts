SinOsc osc => ADSR adsr=> dac;
adsr.set(.2::second,.1::second,.3,.3::second);
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
fun void playNote(int midiNote, dur duration) {
    volume => osc.gain;
    Std.mtof(midiNote) => osc.freq;
    adsr.keyOn();
    duration => now;
    adsr.keyOff();
    0 => osc.gain;
}

fun void wait(float duration) {
    duration::second=>now;
}
[0, 2, 4, 7, 9, 12] @=> int pentMaj[];
0 => int i;
while (true) {
    playNote(rootNote + pentMaj[1], (beat/2)::second);
    wait(beat/4);
    playNote(rootNote + pentMaj[4], (beat/2)::second);
    wait(beat/4);
    playNote(rootNote + pentMaj[1], (beat/2)::second);
    wait(beat/4);
    playNote(rootNote + pentMaj[5], (beat/2)::second);
    wait(beat/4);
}