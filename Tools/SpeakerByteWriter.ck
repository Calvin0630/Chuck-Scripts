
//a class to parse settings.txt to update volume, lfoDepth, etc.
private class ByteWriter {
    FileIO fout;
    fun void init() {
        // open for write
        fout.open( "Byte_Data.txt", FileIO.WRITE );
    }
    fun void writeData() {

        // open for write


        // test
        if( !fout.good() )
        {
            cherr <= "can't open file for writing..." <= IO.newline();
            me.exit();
        }

        while (true) {
            fout <=dac.last()<= " ";
            10::samp=>now;
        }

        // close the thing
        fout.close();

    }


}
