SinOsc c=> Gain gain=> dac;
c.op(-1);
2=>gain.gain;
SinOsc a => c;
SinOsc b => c;

0.5 => a.gain;
1 => a.freq;
0.5 =>b.gain;
1 =>b.freq;

while (true) {
    <<<"gain: " +gain.last()>>>;
    250::ms => now; 
}