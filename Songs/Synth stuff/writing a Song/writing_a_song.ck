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

SinOsc audioSource => Gain gain => dac;
audioSource.op(-1);
volume => gain.gain;
//a sin osc for each midi note
SinOsc oscillators[128];
//an adsr filter for each note
ADSR adsrs[128];
//an array of adsr settings: AttackTime, DelayTime, Sustain, Release
[beat/2, beat, beat/8, beat/8] @=> float adsrSettings[];
//instantiate the elements in the the array
for (0=>int i;i<oscillators.cap();i++) {
    oscillators[i] => adsrs[i] => audioSource;
    //oscillators[i]  => audioSource;
    //apply setting to the adsr
    adsrs[i].set(adsrSettings[0]::second, adsrSettings[1]::second, adsrSettings[2], adsrSettings[3]::second);

    Std.mtof(i) => oscillators[i].freq;
    1 => oscillators[i].gain;
    
}

//notes is an array of ints that are the offset from rootNote of the notes to play
fun void notesOn(int notes[]) {
    //volume =>audioSource.gain;
    for(0=>int i;i<notes.cap();i++) {
        adsrs[rootNote+notes[i]].keyOn();
    }
}

fun void notesOff(int notes[]) {
    //volume =>audioSource.gain;
    for(0=>int i;i<notes.cap();i++) {
        adsrs[rootNote+notes[i]].keyOff();
        
    }
}

fun void wait(float duration) {
    duration::second=>now;
}

[[0,4,7], //Gmaj
[4,7,11], //Bmin
[7,11,14], //Dmaj
[5,10,13] //Cmaj
] @=> int chords[][];
/*
//start the other shreds
Drums drums;
drums.init(gain, beat, .2, rootNote);
*/
//spork~ drums.start();
Bass bass;
bass.init(gain, beat, .9, rootNote-12);
//spork~bass.start();
//Machine.add(me.sourceDir() +"clicks.ck:100:.2:60");
<<<"source: " + me.sourceDir()>>>;

while (true) {
    //strums the chord one note at a time going up and down
    beat*2=>float chordDuration;
    float noteDuration;
    for (0=>int i;i<chords.cap();i++) {
        (chordDuration/(chords[i].cap()*2-2)) =>noteDuration;
        for (0=>int j;j<((2*chords[i].cap())-2);j++) {
            //if its strumming down
            if (j<chords[i].cap()) {
                notesOn([chords[i][j]]);
                wait(noteDuration);
                notesOff([chords[i][j]]);
            }
            //its strumming up
            else {
                notesOn([chords[i][2*chords[i].cap()-1-j]]);
                wait(noteDuration);
            }
            //hold the chord for a duration
            //if its playing the last note
            if (j==((chords[i].cap()*2)-3)) {
                wait(beat);
                notesOff(chords[i]);
                wait(beat);
            }
        }
 
    }
}