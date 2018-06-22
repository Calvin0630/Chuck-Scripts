SinOsc osc => PRCRev r=> dac;
0.2 => r.mix;
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

//functions for the verse and chorus etc
fun void preVerse() {
    repeat(4) {
        repeat(4) {
            playNote(rootNote, beat/4);
            wait(beat/4);
        }
        repeat(4) {
            playNote(rootNote+9, beat/4);
            wait(beat/4);
        }
    }
}
fun void verse() {
    repeat(4) {
        repeat(4) {
            playNote(rootNote+7, beat/4);
            wait(beat/4);
        }
        repeat(4) {
            playNote(rootNote+5, beat/4);
            wait(beat/4);
        }
    }
}
fun void chorus() {
    repeat(3) {
        repeat(4) {
            playNote(rootNote, beat/4);
            wait(beat/4);
        }
        repeat(4) {
            playNote(rootNote+9, beat/4);
            wait(beat/4);
        }
    }
    repeat(4) {
        playNote(rootNote+7, beat/4);
        wait(beat/4);
    }
    repeat(4) {
        playNote(rootNote+5, beat/4);
        wait(beat/4);
    }

}

while (true) {
    //pre-verse
    preVerse();
    verse();
    chorus();
    
    me.exit();
}