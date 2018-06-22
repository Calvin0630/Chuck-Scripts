public class Bass {
    int bpm, rootNote;
    float beat, volume;
    ADSR adsrs[128];
    fun void init(UGen u, float beat_, float volume_, int rootNote_) {
        //recommended args: (bpm, gain, rootNote)
        //arguements separated by a colon
        (beat_*60) $ int=> bpm;
        //the time(seconds) of one beat
        beat_ => beat;
        //a number between 0 and 1 that sets the volume
        volume_ => volume;
        //the midi int of the root note
        rootNote_=> rootNote;
            
        SinOsc audioSource => Gain gain=> u;
        audioSource.op(-1);
        volume => gain.gain;
        //a sin osc for each midi note
        SinOsc oscillators[128];
        
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
    
    fun void start() {
        //writing a song.ck
        //Gmaj, Bmin, Dmaj, Cmaj
        [[2,5,9], //Amin
        [7,10,14], //Dmin
        [5,9,13], //Cmaj
        [3,7,11], //A#min
        [0,3,7] // Gmin
        ] @=> int chords[][];

        while(true) {
            for(0=>int i;i<chords.cap()-1;i++) {
                notesOn(chords[i]);
                wait(3*beat);
                notesOff(chords[i]);
                repeat(2) {
                    wait(beat/4);
                    notesOn(chords[chords.cap()-1]);
                    wait(beat/4);
                    notesOff(chords[chords.cap()-1]);
                }
            }
        }
    }
}