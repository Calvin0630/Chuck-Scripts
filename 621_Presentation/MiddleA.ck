SinOsc osc => dac;
0.5=> osc.gain;
440=> osc.freq;
1::second=>now;