SinOsc osc1=>  dac;


[60, 64, 67, 65, 62] @=> int scale[];

.3 => osc1.gain;
// infinite time loop
0.0 => float t;
0 => int i;
while (true)
{
    if (i>=scale.cap()) 0 => i;
    <<<i>>>;
    std.mtof(scale[i]) =>osc1.freq;
    // advance time
    0.25::second => now;
    0 => osc1.gain;
    .25::second => now;
    .3 => osc1.gain; 
    i+1 => i;
}