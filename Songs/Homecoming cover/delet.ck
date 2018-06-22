
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

Modulate m => dac;
SubNoise noise => blackhole;
SinOsc a=>SinOsc b => blackhole;
1 => a.gain;
1 => a.freq;
1 => b.gain;
1 => b.freq;

1 => b.op;
.3=>m.vibratoRate;
1000=>m.vibratoGain;
100 =>m.randomGain;

while (true){
    <<<"a: " +a.last()>>>;
    <<<"b: " +b.last()>>>;
    <<<"---">>>;
    //(noise.last()+1)*5 =>m.vibratoRate;
    250::ms =>now;
}
