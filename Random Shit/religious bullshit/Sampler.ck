public class Sampler {
    //recommended args: (bpm, gain, rootNote)
    // 100:.2:60
    //arguements separated by a colon
    int bpm;
    //the time(seconds) of one beat
    float beat;
    //a number between 0 and 1 athat sets the volume
    float volume;
    //the midi int of the root note
    int rootNote;
    
    fun void init(Ugen output, int bpm_, float volume_, int rootNote_) {
        SndBuf buf => Gain g => output;
        me.sourceDir() => string localFolder;
        bpm_ =>bpm;
        60/Std.atof(bpm) => beat;
        volume_ => volume;
        rootNote_ => rootNote;
        volume =>g.gain;
    }

    fun void wait(float duration) {
        duration::second=>now;
    }


    //Options: "snare", "kick
    fun void loadSample(string sampleName) {
        string filePath; 
        if (sampleName == "snare") {
            localFolder + "Samples/Snares/Cymatics - Snare 1.wav" =>filePath;
            filePath =>buf.read;
        }
        else if(sampleName == "kick") {
            localFolder + "Samples/Kicks/Cymatics - Kick 1 - C.wav" =>filePath;
            filePath =>buf.read;
        }
        else if(sampleName=="rant") {
            localFolder + "Samples/rant.mp3" =>filePath;
            filePath =>buf.read;        
        }
        else {
            <<<"I didn't recognize that option">>>;
        }
    }
    
    fun void start() {
        while(true) {
            loadSample("rant");
            wait(beat*100);
        }
    }
}