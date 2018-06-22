//arguements separated by a colon
int bpm;
//the time(seconds) of one beat
float beat;
//a number between 0 and 1 that sets the volume
float volume;
//the midi int of the root note
int rootNote;

//take in the command line args
if(me.args() == 3) {
    Std.atoi(me.arg(0)) =>bpm;
    60/Std.atof(me.arg(0)) => beat;
    Std.atof(me.arg(1)) => volume;
    Std.atoi(me.arg(2)) => rootNote;
}
else {
    <<<"Fix your args">>>;
    me.exit();
}
fun void wait(float duration) {
    duration::second=>now;
}

// impulse to filter to dac
Impulse i => BiQuad f=> PRCRev r => Pan2 p => Gain g =>  dac;
2=>g.gain;
.2=>r.mix;
SinOsc osc => blackhole;
1 => osc.gain;
2 => osc.freq;
// set the filter's pole radius
.99 => f.prad; 
// set equal gain zeros
1 => f.eqzs;
// set filter gain
volume => f.gain;

fun void click(int midiNote) {
    // set the current sample/impulse
    1 => i.next;
    osc.last() =>p.pan;
    Std.mtof(midiNote) => f.pfreq;
    0::second =>now;
}

while (true) {
    
    0 => int x;
    while(x<4) {
        if (x%2 ==0) {
            [10,400,7,333,30,90] @=> int dubs[];
            
            Std.rand2(0,dubs.cap()-1)=>int randomShit;
            repeat(randomShit) {
                click(rootNote+3);
                wait(beat/(2*dubs[randomShit]));
            }
        }
        click(rootNote+3);
        wait(beat/2);
        x++;
    }
    click(rootNote);
    wait(beat/2);
}