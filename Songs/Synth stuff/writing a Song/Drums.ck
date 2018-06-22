

public class Drums {
    string localFolder;
    SndBuf buf;
    float beat;
    float volume;
    int rootNote;
    fun void init(UGen destination, float beat_, float volume_, int rootNote_) {
        beat_ =>beat;
        volume_ =>volume;
        rootNote_ => rootNote;
        buf => Gain gain => destination;
        volume=> gain.gain;
        me.sourceDir() => localFolder;
        
    }

    fun void wait(float duration) {
        duration::second=>now;
    }
    
    //Options: "snare", "kick"
    fun void loadSample(string sampleName) {
        string filePath; 
        if (sampleName == "snare") {
            localFolder + "Drum_Samples/Snares/Cymatics - Snare 1.wav" =>filePath;
            filePath =>buf.read;
        }
        else if(sampleName == "kick") {
            localFolder + "Drum_Samples/Kicks/Cymatics - Kick 1 - C.wav" =>filePath;
            filePath =>buf.read;
        }
        else {
            <<<"I didn't recognize that option">>>;
        }
    }
    
    fun void start() {
        while(true) {
            for (0=>int i;i<4;i++) {
                if (i==0) {
                    repeat(3) {
                        loadSample("snare");
                        wait(beat/3);
                    }
                }
                if (i==1) {
                    loadSample("kick");
                    wait(beat);
                }
                if (i==2) {
                    repeat(17) {
                        loadSample("snare");
                        wait(beat/17);
                    }
                }
                if (i==3) {
                    repeat(4) {
                        loadSample("kick");
                        wait(beat/4);
                    }
                }
            }
        }
    }
}

