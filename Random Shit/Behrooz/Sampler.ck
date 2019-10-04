"C:\\Users\\Calvin\\Documents\\Chuck-Scripts\\Samples\\despacito_song.wav" => string samplePath;

SndBuf buf => dac;

samplePath => buf.read;
spork~modulate();
buf.length()=>now;

fun void modulate() {
    SinOsc a =>blackhole;
    1=>a.gain;
    1=>a.freq;
    while (true) {
        a.last()+1=>buf.rate;
    }
}