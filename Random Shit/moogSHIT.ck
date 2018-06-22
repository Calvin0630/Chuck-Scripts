// STK ModalBar

// patch
Moog moog => dac;

// scale
[0, 3,5,7,5,3] @=> int scale[];
/*
Math.random2f( 0, 1 ) => moog.filterQ; //0-1
Math.random2f( 0, 1 ) => moog.filterSweepRate; //0-1
Math.random2f( 0, 12 ) => moog.lfoSpeed; //0-12
Math.random2f( 0, 1 ) => moog.lfoDepth;//0-1
Math.random2f( 0, 1 ) => moog.volume;//0-1
*/

.9 => moog.filterQ; //0-1
.5 => moog.filterSweepRate; //0-1
12 => moog.lfoSpeed; //0-12
.2 => moog.lfoDepth;//0-1
.7 => moog.volume;//0-1

0=>int i;
// infinite time loop
while( true )
{
    if(i>=scale.cap())0=>i;
    // ding!

    // set freq
    42 + scale[i] => Std.mtof => moog.freq;

    // go
    1 => moog.noteOn;

    // advance time
    .5::second => now;
    moog.noteOff(0);
    i++;
}
