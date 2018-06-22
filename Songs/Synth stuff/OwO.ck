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

SinOsc audioSource => Gain gain => dac;
audioSource => PitShift shift => PRCRev reverb =>Chorus chorus=> gain;
.5=>reverb.mix;
-2=>shift.shift;
audioSource.op(-1);
volume => gain.gain;
//a sin osc for each midi note
SinOsc oscillators[128];
//an adsr filter for each note
ADSR adsrs[128];
//an array of adsr settings: AttackTime, DelayTime, Sustain, Release
[beat/4, 0.05, 0.3, beat/2] @=> float adsrSettings[];
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

int chordRoot;

while(true) {
    repeat(2) {
        notesOn([rootNote]);
        wait(beat/2);
        notesOn([rootNote+3]);
        wait(beat/2);
        notesOff([rootNote, rootNote+3]);
        notesOn([rootNote+2, rootNote+7]);
        wait(beat);
        notesOff([rootNote+2, rootNote+7]);
        wait(beat/2);
    }
    repeat(2) {
        notesOn([rootNote+8]);
        wait(beat/2);
        notesOn([rootNote+5]);
        wait(beat/2);
        notesOff([rootNote+8, rootNote+5]);
        notesOn([rootNote+2, rootNote+5]);
        wait(beat);
        notesOff([rootNote+2, rootNote+5]);
        wait(beat/2);
    }
}
