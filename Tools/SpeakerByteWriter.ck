
//a class to parse settings.txt to update volume, lfoDepth, etc.
private class ByteWriter {
    dac=>Gain gain=>blackhole;
    1=>gain.gain;
    FileIO fout;
    0=>int chunkSize;
    10::second=>dur recordDuration;
    time start;
    fun void init() {
        // open for write
        fout.open( "Byte_Data.txt", FileIO.WRITE );
        now=>start;
        spork~writeData();
    }
    fun void writeData() {

        // open for write


        // test
        if( !fout.good() )
        {
            cherr <= "can't open file for writing..." <= IO.newline();
            me.exit();
        }

        while (now<start+recordDuration) {
            fout <=gain.last()<= "\n";
            10::samp=>now;
        }

        // close the thing
        fout.close();

    }


}

ByteWriter w;
w.init();
<<<"writing","">>>;
w.recordDuration +1::second=> now;
<<<"Done writing","">>>;
