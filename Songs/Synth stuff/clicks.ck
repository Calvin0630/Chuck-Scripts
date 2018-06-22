// 100:.2:60
//recommended args: (bpm, gain, rootNote)
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

SinOsc osc =>blackhole;
3=>osc.gain;
beat=>osc.freq;

Impulse i =>PitShift shift =>Delay d=>Gain gain=> dac;
volume =>gain.gain;
-1=>shift.shift;
-2 => float x;
 while( true ) {
    if(x>2) -2=>x;
    for(6=> int j;j>2;j--) {
        Math.pow(2,j)=>float repetitions;
        repeat(repetitions) {
            osc.last()=>i.next;
            wait(beat/repetitions); 
            x+1=>x;
        }
    }
    //x=>shift.shift;
    1+x=>x;
    
 }