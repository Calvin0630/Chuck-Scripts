SinOsc a =>dac;
.2=>a.gain;
SinOsc b =>blackhole;
.2=>b.gain;
10=>b.freq;
SawOsc saw => blackhole;
3 =>saw.freq;
40 =>saw.gain;

1=>int i;

while (true) {
    i + saw.last()=>a.freq;
    .2+b.last() =>a.gain;
    if(i>3000) {
        0=>i;
    }
    i++;
    1::ms=>now;
}