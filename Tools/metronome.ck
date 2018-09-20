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

Metronome metro;
metro.init(dac,bpm, volume, rootNote);
metro.start();

class Metronome {
    float beat, volume;
    int bpm, rootNote;
    Impulse i => Gain gain  => dac;
    fun void init(UGen output, int _bpm, float _volume, int _rootNote) {
        _bpm =>bpm;
        60/(_bpm $ float) => beat;
        _volume => volume;
        _rootNote => rootNote;
        volume=>gain.gain;
    }
    fun void start() {
        while(true) {
            1=>i.next;
            wait(beat);
        }
    }
    fun void wait(float duration) {
        duration::second=>now;
    }
}