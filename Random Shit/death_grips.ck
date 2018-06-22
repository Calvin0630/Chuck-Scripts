
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
// our patch
SqrOsc so => LPF f=>Gain gain => dac;
volume => gain.gain;
// set osc frequency
32 => so.freq;
// set Q
100 => f.Q;
// set gain
volume => f.gain;

// infinite time-loop
float t;
while( true )
{
    // sweep the cutoff
    100+Std.fabs(Math.tan(t)) * 500 => f.freq;
    20 + Std.fabs(Math.sin(5*Math.sin(t))) * 50 => so.freq;
    // increment t
    .005 +=> t;
    // advance time
    5::ms => now;
}
