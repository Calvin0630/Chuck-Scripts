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
// patch
BlowHole hole => dac;

// scale
[0, 2, 4, 7, 9, 11] @=> int scale[];
.2 => hole.reed;
.5 => hole.noiseGain;
.1 => hole.tonehole;
.2 => hole.vent;
1 => hole.pressure;
<<< "reed stiffness:", hole.reed() >>>;
<<< "noise gain:", hole.noiseGain() >>>;
<<< "tonehole state:", hole.tonehole() >>>;
<<< "register state:", hole.vent() >>>;
<<< "breath pressure:", hole.pressure() >>>;

fun void blow(int midiNote, float duration) {
  

  rootNote => Std.mtof => hole.freq;
  

  .4 => hole.noteOn;

  // advance time
  duration::second => now;
  .01 => hole.noteOff;
}

while (true) {
    blow(rootNote, beat);
    wait(beat/2);
    blow(rootNote+12, beat);
    wait(beat/2);
    <<<beat>>>;
}