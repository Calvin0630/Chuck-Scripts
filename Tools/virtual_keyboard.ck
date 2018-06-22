
private class VirtualKeyboard {
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
    //a sin osc for each midi note
    SinOsc oscillators[128];
    //an adsr filter for each note
    ADSR adsrs[128];
    SinOsc audioSource;
    SinOsc lfo;
    Gain gain;
    
    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {

        bpm_ =>bpm;
        60/(bpm_ $ float) => beat;
        <<<beat>>>;
        volume_ => volume;
        rootNote_ => rootNote;
        
        audioSource => gain => output;
        audioSource.op(-1);
        volume => gain.gain;
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
}
fun void wait(float duration) {
    duration::second=>now;
}
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

Gain gain => dac;
.5=>gain.gain;
VirtualKeyboard synth;
synth.init(gain, bpm, .2, 60);

[[0, 4, 5],
[8,12,13],
[3,7,8],
[0, 4, 5],
[3, 7, 8],
[5, 9, 10],
[12, 14, 15]]
@=> int chords[][];
while (true) {
    for (0=>int i;i<chords.cap();i++) {
        <<<i>>>;
        repeat(3) {
            synth.notesOn(chords[i]);
            wait(beat/3);
            synth.notesOff(chords[i]);
            wait(beat/3);
        }
        if(i==chords.cap()-1) {
            repeat(10) {
                synth.notesOn(chords[i]);
                wait(beat/10);
                synth.notesOff(chords[i]);
                wait(beat/10);
            }
        }
    }
}
