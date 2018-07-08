private class Sampler {

    //arguements separated by a colon
    int bpm;
    //the time(seconds) of one beat
    float beat;
    //a number between 0 and 1 athat sets the volume
    float volume;
    //the midi int of the root note
    int rootNote;
    string samplesFolder;
    Gain gain;
    
    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {
        gain => output;
        "C:\\Users\\Calvin\\Documents\\Chuck-Scripts\\Samples\\" => samplesFolder;
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
    riff 1
    waterfall
    woof
    open hi hat
    closed hi hat
   */ 
	fun void loadSample(string sampleName) {
        SndBuf buf=>gain;
        string filePath; 
        if (sampleName == "snare") {
            samplesFolder + "Snares/Cymatics - Snare 1.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName == "kick") {
            samplesFolder + "Kicks/Cymatics - Kick 1 - C.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="rant") {
            samplesFolder + "rant.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="pizza time") {
            samplesFolder + "pizza_time.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;

        }
        else if(sampleName=="death") {
            samplesFolder + "death.wav" =>filePath;
            filePath =>buf.read;
        }
        else if(sampleName=="you will die") {
            samplesFolder + "you_will_die.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="there is none") {
            samplesFolder + "there_is_none.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="despacito song") {
            samplesFolder + "despacito_song.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="despacito") {
            samplesFolder + "despacito.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="riff 1") {
            samplesFolder + "riff_1(70bpm,16beats).wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="waterfall") {
            samplesFolder + "Allen_gardens_waterfall.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if(sampleName=="woof") {
            samplesFolder + "woof.wav" =>filePath;
            filePath =>buf.read;
            (buf.length())=>now;
        }
        else if (sampleName=="open hi hat") {
            samplesFolder + "271_hi_hat_samples/hihat_015b.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if (sampleName=="closed hi hat") {
            samplesFolder + "271_hi_hat_samples/hihat_003a.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
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
        while (true) {
            for (0=>int i;i<4;i++) {
                if(i==0) {
                    9=>int repetitions;
                    (beat/(repetitions+9))=>float gap;
                    repeat(repetitions/3) {
                        spork~loadSample("closed hi hat");
                        wait((beat/repetitions)-(gap/2));
                        spork~loadSample("closed hi hat");
                        wait((beat/repetitions)-(gap/2));
                        spork~loadSample("closed hi hat");
                        wait((beat/repetitions)+(gap));
                    }
                }
                else if(i==1) {
                    spork~loadSample("woof");
                    wait(beat);
                }
                else if(i==2) {
                    wait(beat);
                }
                else if(i==3) {
                    spork~loadSample("you will die");
                    wait(beat);
                }
            }
        }
    }
    fun void twoAndFour() {
        while (true) {
            for (0=>int j;j<4;j++) {
                for (0=>int i;i<4;i++) {
                    if(i==0) {
                        if(j!=0) {
                            spork~loadSample("closed hi hat");
                            wait(beat);
                        }
                        else continue;
                    }
                    else if(i==1) {
                        if (j==0||j==2) {
                            spork~loadSample("kick");
                            wait(beat);
                        }
                        else if(j==1||j==3) {
                            repeat(2) {
                                spork~loadSample("kick");
                                wait(beat/2);
                            }
                        }
                    }
                    else if(i==2) {
                        spork~loadSample("closed hi hat");
                        wait(beat);
                    }
                    else if(i==3) {
                        if(j==3) {
                            6=>int repetitions;
                            (2*beat/(repetitions+9))=>float gap;
                            repeat(repetitions/3) {
                                spork~loadSample("snare");
                                wait((2*beat/repetitions)-(gap/2));
                                spork~loadSample("snare");
                                wait((2*beat/repetitions)-(gap/2));
                                spork~loadSample("snare");
                                wait((2*beat/repetitions)+(gap));
                            }
                        }
                        else {
                            spork~loadSample("snare");
                            wait(beat);
                        }
                    }
                }
            }
        }
    }
}
// 70:.6:43
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
Gain gain=> dac;
volume=>gain.gain;

Sampler sam;
sam.init(gain, bpm, volume, rootNote);
//spork~sam.twoAndFour(); 
spork~sam.twoAndFour(); 
while (true) {
    wait(beat);
}