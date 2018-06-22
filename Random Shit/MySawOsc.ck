SawOsc saw => blackhole;
2 => saw.gain;
1=>saw.freq;

while(true) {
    <<<saw.last()>>>;
    250::ms => now;
}