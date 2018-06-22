//recommended args: (bpm, gain, rootNote)
// 120:.2:60
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

SinOsc audioSource => Chorus chorus =>PRCRev reverb => Gain gain => dac;

.2 =>reverb.mix;
audioSource.op(-1);
volume => gain.gain;
//a sin osc for each midi note
SinOsc oscillators[128];
//an adsr filter for each note
ADSR adsrs[128];
//an array of adsr settings: AttackTime, DelayTime, Sustain, Release
[0.2, 0.2, 0.3, 0.5] @=> float adsrSettings[];
//instantiate the elements in the the array
for (0=>int i;i<oscillators.cap();i++) {
    oscillators[i] => adsrs[i] => audioSource;
    //oscillators[i]  => audioSource;
    //apply setting to the adsr
    adsrs[i].set(adsrSettings[0]::second, adsrSettings[1]::second, adsrSettings[2], adsrSettings[3]::second);

    Std.mtof(i) => oscillators[i].freq;
    0 => oscillators[i].gain;
    
}

fun void notesOn(int notes[]) {
    //volume =>audioSource.gain;
    for(0=>int i;i<notes.cap();i++) {
        1 => oscillators[notes[i]].gain;
        adsrs[notes[i]].keyOn();
    }
}

fun void notesOff(int notes[]) {
    //volume =>audioSource.gain;
    for(0=>int i;i<notes.cap();i++) {
        0 => oscillators[notes[i]].gain;
        adsrs[notes[i]].keyOff();
        
    }
}

fun void wait(float duration) {
    duration::second=>now;
}

[[rootNote+0, rootNote+5, rootNote+3],
[rootNote+0, rootNote+5, rootNote+7],
[rootNote+0, rootNote+5, rootNote+9],
[rootNote+5, rootNote+10, rootNote+12]
] @=> int chords[][];

int chordRoot;

while(true) {
    //loop through the chords
    for (0=>int i;i<chords.cap();i++) {
        <<<i>>>;
        //turn the notes on one-by-one. (takes a half beat to do)
        //the line below makes it so the chord can contain any # of notes
        beat/(chords[i].cap()*2) => float pauseTime;
        for (0=>int j;j<chords[i].cap();j++) {
            notesOn([chords[i][j]]);
            wait(pauseTime);
        }
        wait(beat/2);
        notesOff(chords[i]);
        wait(beat/2);
        notesOn(chords[i]);
        wait(beat);
        notesOff(chords[i]);
        wait(beat/2);
        //repeat but in the other direction
        for ((chords[i].cap()-1)=>int j;j>=0;j--) {
            notesOn([chords[i][j]]);
            wait(pauseTime);
        }
        wait(beat/2);
        notesOff(chords[i]);
        wait(beat/2);
        notesOn(chords[i]);
        wait(beat);
        notesOff(chords[i]);
        wait(beat/2);
    }
}


