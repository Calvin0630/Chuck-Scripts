private class Sampler {

    //arguements separated by a colon
    int bpm;
    //the time(seconds) of one beat
    float beat;
    //a number between 0 and 1 athat sets the volume
    float volume;
    //the midi int of the root note
    int rootNote;
    string localFolder;
    Gain gain;
    
    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {
        gain => output;
        me.sourceDir() => localFolder;
        bpm_ =>bpm;
        60/(bpm_ $ float)=>beat;
        volume_ => volume;
        rootNote_ => rootNote;
        volume =>gain.gain;
    }

    fun void wait(float duration) {
        duration::second=>now;
    }


    /*Options:
   snare
   kick
   rant: a religious rant with google translate
   pizza time
   death
   you will die
    there is none
   despacito song
   despacito
   */ 
    fun void loadSample(string sampleName) {
        SndBuf buf=>gain;
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
            localFolder + "Samples/rant.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="pizza time") {
            localFolder + "Samples/pizza_time.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;

        }
        else if(sampleName=="death") {
            localFolder + "Samples/death.wav" =>filePath;
            filePath =>buf.read;
        }
        else if(sampleName=="you will die") {
            localFolder + "Samples/you_will_die.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="there is none") {
            localFolder + "Samples/there_is_none.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="despacito song") {
            localFolder + "Samples/despacito_song.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="despacito") {
            localFolder + "Samples/despacito.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else {
            <<<"I didn't recognize that option">>>;
        }
    }
    
    
    
    fun void pattern1() {
        while(true) {
            for (0=>int x;x<2;x++) {
                for(0=>int i;i<4;i++) {
                    if (i==0) {
                        loadSample("kick");
                        wait(beat);
                    }
                    else if(i==1) {
                        if (x==0) {
                            loadSample("death");
                            wait(beat);
                        }
                        else if (x==1) {
                            spork~loadSample("there is none");
                            wait(beat);
                        }
                    }
                    else if(i==2) {
                        repeat(2) {
                            loadSample("kick");
                            wait(beat/2);
                        }
                    }
                    else if(i==3) {
                        if(x==0) {
                            loadSample("snare");
                            wait(beat);
                        }
                        else if(x==1) {
                            repeat(8) {
                                loadSample("snare");
                                wait(beat/8);
                            }
                        }
                    }
                }
            }
        }
    }
    fun void pattern2() {
        <<<"hello">>>;
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

Gain gain => dac;
Sampler sam;
sam.init(gain, bpm, volume, rootNote);
spork~sam.pattern1();

while(true) {
    wait(beat);
}