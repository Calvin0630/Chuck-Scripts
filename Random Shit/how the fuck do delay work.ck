
private class Sampler {
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
    string localFolder;
    SndBuf buf;
    Gain gain;
    
    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {
        buf => gain => output;
        me.sourceDir() => localFolder;
        bpm_ =>bpm;
        60/(bpm_ $ float);
        volume_ => volume;
        rootNote_ => rootNote;
        volume =>gain.gain;
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
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName == "kick") {
            localFolder + "Samples/Kicks/Cymatics - Kick 1 - C.wav" =>filePath;
            filePath =>buf.read;
        }
        else if(sampleName=="rant") {
            localFolder + "Samples/rant.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="pizza time") {
            localFolder + "Samples/pizza_time.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;

        }
        else {
            <<<"I didn't recognize that option">>>;
        }
    }
    
    fun void start() {
        
    }
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

fun void wait(float duration) {
    duration::second=>now;
}

Echo echo =>Gain gain =>dac;
//gain=> echo;
Sampler sam;
sam.init(echo, bpm, volume, rootNote);
10::second=>echo.delay;
1::second=>echo.max;
sam.loadSample("rant");
//1.0=>echo.mix;
while(true) {
    
    <<<gain.last()>>>;
    10::second=>now;
}