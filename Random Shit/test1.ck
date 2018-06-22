float x;
SinOsc wave => dac;
.3 => wave.gain;
while( true )
{
  // generate random float (and print)
  Std.rand2f( 100.0, 1000.0 ) => x ;
  x => wave.freq;
  300::ms => now;
  // wait a bit
}