SinOsc a =>Gain g => dac;
SinOsc b => g;
SinOsc c => g;
0 => g.gain;
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


//int is the midi notes value, duration is the time (seconds) to 
//play the note

fun void playTriple(int midiNotes[], float duration) {
    if (midiNotes.cap() != 3) <<<"I can only play 3 notes">>>;
    volume =>  g.gain;
    volume/1000 => a.gain, b.gain, c.gain;
    Std.mtof(midiNotes[0]) => a.freq;
    Std.mtof(midiNotes[1]) => b.freq;
    Std.mtof(midiNotes[2]) => c.freq;
    duration::second => now;
    0 => a.gain, b.gain, c.gain;
    0 => g.gain;
}

fun void wait(float duration) {
    duration::second=>now;
}


int chordRoot;

while (true) {
    
    repeat(2) {
        //E
        repeat(4) {
            rootNote => chordRoot;
            [chordRoot, chordRoot+7, chordRoot + 12] @=> int chord[];
            playTriple(chord, beat/2);
            wait(beat/2);
        }
        //A
        repeat(4) {
            rootNote + 5 => chordRoot;
            [chordRoot, chordRoot+7, chordRoot + 12] @=> int chord[];
            playTriple(chord, beat/2);
            wait(beat/2);
        }
    }
    
    
}