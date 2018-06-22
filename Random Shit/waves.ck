
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
// run white noise through envelope
Noise n => Envelope e => Gain g=> dac;
volume=>g.gain;

// infinite time-loop
while( true )
{
    // random choose rise/fall time
    (beat*2)::second =>  e.duration;

    // key on - start attack
    e.keyOn();
    // advance time by 800 ms
   (beat)::second => now;
    // key off - start release
    e.keyOff();
    // advance time by 800 ms
    (beat*2)::second => now;
}