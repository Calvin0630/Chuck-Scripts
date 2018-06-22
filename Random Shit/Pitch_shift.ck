SinOsc osc => PitShift shift => Gain g => dac;

1=>osc.gain;
440=>osc.freq;
.3=> g.gain;

-3 => int i;

while (true) {
    i +.5 =>shift.shift;
    if(i>3) -3 => i;
    500::ms => now;
    i++;
}