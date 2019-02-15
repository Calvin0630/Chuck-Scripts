SinOsc a =>PRCRev reverb=> dac;
0=>reverb.mix;
1=>a.gain;
200=>a.freq;
1=>int i;
while (a.freq()<1000) {
    a.freq()+i*i=>a.freq;
    10::ms=>now;
    i+1=>i;
}