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

[0,4,5,0,4,7] @=> int notes[];
while(true) {
    int repetitions;
    for (0=>int i;i<notes.cap();i++) {
        <<<me.dir()+ "notes and shit.ck:70:.4:63:"+repetitions>>>;
        4=>repetitions;
        if(i==2||i==5) {
            8=>repetitions;
        }
        machine.add(me.dir() + "notes and shit.ck:70:"+volume+":" + (rootNote+notes[i]) + ":"+repetitions);
        wait(beat*repetitions);
    }
}