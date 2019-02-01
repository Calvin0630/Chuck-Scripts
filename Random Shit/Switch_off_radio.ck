<<<"UWU","">>>;
Noise noise => PRCRev reverb1=>NRev reverb2=>LPF lpf=> Gain finalGain =>dac;
4=>finalGain.gain;
1=>reverb1.mix;
1=>reverb2.mix;
0.5=>noise.gain;
20000=>lpf.freq;
25::ms=>now;
//i is the time in mill
0=>int i;
2=> int j;
while (j<20000) {
    (20000-j)=>lpf.freq;
    j*j=>j;
    100::ms=> now;
}

//3::second=> now;