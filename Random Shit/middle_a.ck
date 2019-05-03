SinOsc sina => Gain gain =>dac;
SinOsc sinb;//=>gain;
gain.op(3);
1=>sinb.gain;
1=>sinb.freq;
0.5=>sina.gain;
440=>sina.freq;
while(true) {
    <<<"running and","">>>;
    10::second=>now;
}