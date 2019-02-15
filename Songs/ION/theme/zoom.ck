<<<"zoom 1","">>>;
zoom1();
0.5::second=>now;
<<<"zoom 2","">>>;
zoom2();
0.5::second=>now;
<<<"zoom 3","">>>;
zoom3();
0.5::second=>now;

<<<"done!","">>>;
fun void zoom1() {
    SinOsc a =>PRCRev reverb=> dac;
    0=>reverb.mix;
    1=>a.gain;
    100=>a.freq;
    1=>int i;
    while (a.freq()<350) {
        a.freq()+1=>a.freq;
        5::ms=>now;
    }
    reverb =<dac;
}
fun void zoom2() {
    Phasor b => PRCRev reverb=> dac;
    0.1=>reverb.mix;
    0.5=>b.gain;
    200=>b.freq;
    0.5::second=> now;
    while (b.freq()<350) {
        b.freq()+1=>b.freq;
        10::ms=>now;
    }
    reverb =<dac;
}

fun void zoom3() {
    SinOsc a =>PRCRev reverb=>Chorus chorus=>Gain volume=> dac;
    0.3=>chorus.mix;
    220=>chorus.modFreq;
    0.2=>chorus.modDepth;
    a=>volume;
    1=>volume.gain;
    0.001=>reverb.mix;
    0.5=>a.gain;
    100=>a.freq;
    1=>int i;
    spork~modulateChorusEffect(chorus, a) @=> Shred @ chorusMod;
    while (a.freq()<350) {
        a.freq()+1=>a.freq;
        5::ms=>now;
    }
    while (a.freq()<1100) {
        a.freq()+4=>a.freq;
        5::ms=>now;
    }
    while (a.freq()<2200) {
        a.freq()+20=>a.freq;
        5::ms=>now;
    }
    while (a.freq()<8800) {
        a.freq()+100=>a.freq;
        5::ms=>now;
    }
    volume =<dac;
    chorusMod.exit();
}

fun void modulateChorusEffect(Chorus chorus, UGen valueSpecifier) {
    while (true) {
        valueSpecifier.last() + 200=>chorus.modFreq;
        10::ms=>now;
    }

}