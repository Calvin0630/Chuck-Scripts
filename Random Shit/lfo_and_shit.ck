SinOsc osc1 => dac;
//osc2 is lfo
//chucking it to black hole makes it oscilate 
//without sound
SinOsc osc2 => blackhole;
10 => osc2.gain;
.5 => osc2.freq;
.01 => osc1.gain;
2 => osc1.freq;
[60, 65, 67, 65 ] @=> int scale[];
//the first arg is how long a note will last
//(milliseconds)
float duration;
if (me.args() == 1) {
    Std.atof(me.arg(0)) => duration;
}
else {
    200 => duration;
}
0 => int i;

while (true) {
    if (i>=scale.cap()) 0 => i;
    Std.mtof(scale[i]) + osc2.last() => osc1.freq;
    duration::ms => now;
    0 => osc1.gain;
    duration::ms => now;
    .2 => osc1.gain;
    i+1 => i;
}
