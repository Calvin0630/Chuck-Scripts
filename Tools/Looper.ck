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
    Std.atoi(me.arg(2))=>rootNote;
}
else {
    <<<"Fix your args">>>;
    me.exit();
}
fun void wait(float duration) {
    duration::second=>now;
}

private class Looper {
    //tab: start/stops recording loops
    //msg.key == 43
    int bpm, rootNote;
    float volume, beat;
    "C:\\Users\\Calvin\\Documents\\Chuck-Scripts\\Loops\\"=> string loopsFolder;
    
    fun void init(UGen input, int bpm, float volume, int rootNote) {
        
    }
    
}