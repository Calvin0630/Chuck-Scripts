SinOsc osc =>PRCRev r => dac;
0.2 => r.mix;
SinOsc a => osc;
SinOsc b => osc;
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

fun void fifth(int midiNote, float duration) {
    volume => a.gain;
    volume => b.gain;
    volume*200 => osc.gain;
    Std.mtof(midiNote) => a.freq;
    Std.mtof(midiNote+5) => b.freq;
    duration::second => now;
    0 => osc.gain;
    0 => a.gain;
    0 => b.gain;
}

fun void wait(float duration) {
    duration::second=>now;
}
while (true) {
    repeat(4) {
        fifth(rootNote, beat/4);
        wait(beat/4);
    }
    repeat(4) {
        fifth(rootNote + 5, beat/4);
        wait(beat/4);
    }
    repeat(4) {
        fifth(rootNote + 7, beat/4);
        wait(beat/4);
    }
    repeat(8) {
        fifth(rootNote + 5, beat/8);
        wait(beat/8);
    }
}

