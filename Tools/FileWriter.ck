//a class to parse settings.txt to update volume, lfoDepth, etc.
private class SettingsReader {
    MidiOscillator synth;
    Sampler sam;
    //
    fun void init(MidiOscillator synth_, Sampler sam_) {
        synth_@=>synth;
        sam_@=>sam;
        spork~readData();
    }
    fun void readData() {
        while (true) {
            // default file
            me.sourceDir() + "/Assets/Resources/settings.txt" => string filename;
            // instantiate
            FileIO fio;
            // open a file
            fio.open( filename, FileIO.READ );
            // ensure it's ok
            if( !fio.good() ) {
                cherr <= "can't open file: " <= filename <= " for reading..." <= IO.newline();
                me.exit();
            }

            // loop until end
            while( fio.more() ) {
                //reads the line and separates it into a string for the variable name and value.
                fio.readLine()=>string line;
                if (line.length()==0) continue;
                line.trim();
                line.find(" ")=>int spaceIndex;
                line.substring(0,spaceIndex)=>string variableName;
                //takes a substring from the spaceIndex+1 to end
                line.substring(spaceIndex+1)=>string variableValue;
                if (variableName=="SynthVolume") {
                    synth.setVolume(Std.atof(variableValue));
                }
                else if (variableName=="LFOActive") {
                    synth.setLFOActive(Std.atoi(variableValue));
                }
                else if (variableName=="LFORate") {
                    synth.setLFORate(Std.atof(variableValue));
                }
            }
            .1::second=>now;
        }
    }


}
