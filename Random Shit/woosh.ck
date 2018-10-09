//recommended args: (bpm, gain, rootNote)
// 100:.2:60
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

Noise n =>LPF lpf =>HPF hpf => Gain gain => dac;
volume => gain.gain;
while(true) {
    for(1=>int i;i<128;i++) {
        10*i - 10 =>hpf.freq;
        10*i + 10 =>lpf.freq;
        (beat/64)::second => now;
    }
}