private class Sampler {
    
    //arguements separated by a colon
    int bpm;
    //the time(seconds) of one beat
    float beat;
    //a number between 0 and 1 athat sets the volume
    float volume;
    //the midi int of the root note
    int rootNote;
    string samplesFolder;
    Gain gain;
    
    fun void init(UGen output, int bpm_, float volume_, int rootNote_) {
        gain => output;
        "C:\\Users\\Calvin\\Documents\\Chuck-Scripts\\Samples\\" => samplesFolder;
        bpm_ =>bpm;
        60/(bpm_ $ float)=>beat;
        volume_ => volume;
        rootNote_ => rootNote;
        volume =>gain.gain;
    }

    fun void wait(float duration) {
        duration::second=>now;
    }


    /*
   Loads and plays a sample. The function returns once the sample is done playing
    
   Options:
   snare
   kick
   rant: a religious rant with google translate
   pizza time
   death
   you will die
    there is none
   despacito song
   despacito
    riff 1
    waterfall
    woof
    boop
    hi hat 0open
    hi hat closed
   */ 
	fun void playSample(string sampleName) {
        
        //checks to make sure you initialized the sampler
         if(samplesFolder=="") {
            <<<"Did you initialize the sampler?","">>>;
        }
        SndBuf buf=>gain;
        string filePath; 
        if (sampleName == "snare") {
            samplesFolder + "Snares\\Cymatics - Snare 1.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName == "kick") {
            samplesFolder + "Kicks\\Cymatics - Kick 1 - C.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="rant") {
            samplesFolder + "rant.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="pizza time") {
            samplesFolder + "pizza_time.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;

        }
        else if(sampleName=="death") {
            samplesFolder + "death.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="you will die") {
            samplesFolder + "you_will_die.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="there is none") {
            samplesFolder + "there_is_none.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="despacito song") {
            samplesFolder + "despacito_song.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="despacito") {
            samplesFolder + "despacito.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="riff 1") {
            samplesFolder + "riff_1(70bpm,16beats).wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="waterfall") {
            samplesFolder + "Allen_gardens_waterfall.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="woof") {
            samplesFolder + "woof.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="boop") {
            samplesFolder + "boop.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="hi hat open") {
            samplesFolder + "271_hi_hat_samples\\hihat_004a.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else if(sampleName=="hi hat closed") {
            samplesFolder + "271_hi_hat_samples\\hihat_004b.wav" =>filePath;
            filePath =>buf.read;
            (buf.length()/buf.rate())=>now;
        }
        else {
            <<<"I didn't recognize that option","">>>;
        }
    }
    
    
    
    fun void pattern1() {
        while(true) {
            for (0=>int x;x<4;x++) {
                for(0=>int i;i<4;i++) {
                    if (i==0) {
                        playSample("kick");
                        wait(beat);
                    }
                    else if(i==1) {
                        if (x==0) {
                            playSample("death");
                            wait(beat);
                        }
                        else if (x==1) {
                            spork~playSample("there is none");
                            wait(beat);
                        }
                        else if (x==2||x==3) {
                            spork~playSample("despacito");
                            wait(beat);
                        }
                    }
                    else if(i==2) {
                        repeat(2) {
                            playSample("kick");
                            wait(beat/2);
                        }
                    }
                    else if(i==3) {
                        if(x==0) {
                            playSample("snare");
                            wait(beat);
                        }
                        else if(x==1) {
                            repeat(8) {
                                playSample("snare");
                                wait(beat/8);
                            }
                        }
                    }
                }
            }
        }
    }
    
    fun void roll(float initialDuration) {
        initialDuration=>float duration;
        while(duration>.0001) {
            <<<duration,"">>>;
            playSample("snare");
            wait(duration);
            2/=>duration;
        }
    }
    
}

private class IntArray {
    /*
    functions:
    add: int[] or int
    remove: int[] or int
    get: int index
    indexOf:int element
    contains returns 0 if no, 1 if yes
    print: void, prints the array
    size return the size of the array
    
    */
    int elements[];
    //add an array of ints
    fun void add(int newElements[]) {
        for (0=>int i;i<newElements.cap();i++) {
            add(newElements[i]);
        }
    }
    //add a single int
    fun void add(int element) {
        //if its empty
        if (elements==null) {
            [element]@=> elements;
        }
        else { //creates a new array and appends the new element
            elements.cap()+1=>int newArraySize;
            int newElements[newArraySize];
            for (0=>int i;i<newArraySize;i++) {
                //if its at the end
                if (i==newArraySize-1) {
                    //append element
                    element=>newElements[i];
                }
                else {
                    elements[i]=>newElements[i];
                }
            }
            newElements@=>elements;
        }
    }
    //removes a list of numbers
    fun void remove(int removeThis[]) {
        for (0=>int i;i<removeThis.cap();i++) {
            remove(removeThis[i]);
        }
    }
    //removes the element parameter (not the index)
    fun void remove(int element) {
        indexOf(element)=> int index;
        //if the element isnt here
        if (index==-1) {
            <<<"the element you're trying to remove isn't here","">>>;
        }
        else {//the element is in the array
            int newElements[];
            if (elements.cap()>1) { //if the array is bigger than 1
                int newElements[elements.cap()-1];
                for (0=>int i;i<elements.cap();i++) {
                    if (i==index) {
                        continue;
                    }
                    if (i>index) {
                        elements[i]=>newElements[i-1];
                    }
                    else {
                        elements[i]=>newElements[i];
                    }
                }
                newElements@=>elements;
            }
            else if(elements.cap()==1){
                 null@=>elements;
            }
        }
        
    }
    //returns the element @ index
    fun int get(int index) {
        if (index >=elements.cap()) <<<"invalid index","">>>;
        else return elements[index];
    }
    //returns the index of the element
    //if not found returns -1
    fun int indexOf(int element) {
        //int
        -1=>int contains;
        if (elements!= null) {
            for (0=>int i;i<elements.cap();i++) {
                if (elements[i]==element) {
                    i=>contains;
                    return contains;
                }
            }
        }
        return contains;
    }
    
    fun int contains(int element) {
        indexOf(element)=>int result;
        if (result ==-1) return 0;
        else return 1;
    }
    fun void print() {
        ""=>string result;
        for (0=>int i;i<elements.cap();i++) {
            //if its the last element
            if(i==elements.cap()-1) {
                //dont put a comma
                elements[i]+"" +=>result;
            }
            else {
                //do
                elements[i] + "," +=>result;
            }
        }
        <<<("["+result+"]"),"">>>;
    }
    fun int size() {
        if(elements==null) return 0;
        
        else return elements.cap(); 
    }
}
IntArray arr;
arr.add([1]);
arr.print();

<<<arr.contains(5),"">>>;


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
    <<<"Fix your args","">>>;
    <<<"","Expected: bpm:volume:rootNote">>>;
    me.exit();
}

fun void wait(float duration) {
    duration::second=>now;
}


Gain gain => dac;
volume=>gain.gain;
Sampler sam;
//numrow 0-9
IntArray keys;
keys.add([30, 31, 32, 33, 34, 35, 36, 37, 38 , 39]);
// the names of the samples that correspond to their mutally indexed keys
["snare", "kick", "boop", "pizza time", "death", "you will die", "there is none", "despacito song", "hi hat closed", "hi hat open"]     
    @=> string sampleStrings[];
sam.init(gain, bpm, volume, rootNote);

Hid hi;
HidMsg msg;

// which keyboard
0 => int device;

// open keyboard (get device number from command line)
if( !hi.openKeyboard( device ) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;

// infinite event loop
while( true )
{
    // wait on event
    hi => now;

    // get one or more messages
    while( hi.recv( msg ) )
    {
        // check for action type
        if( msg.isButtonDown() )
        {
            //<<< "down:", msg.which, "(code)", msg.key, "(usb key)", msg.ascii, "(ascii)" >>>;
            //msg.key is unique for each buitton on a qwerty
            //q1<<<  msg.key, ", " >>>;
            keys.indexOf(msg.key)=>int sample;
            <<<sample,"">>>;
            //if the user pressed 0-9 on num row
            if (sample != -1) {
                spork~sam.playSample(sampleStrings[sample]);
            }
        }
        
        else
        {
            //<<< "up:", msg.which, "(code)", msg.key, "(usb key)", msg.ascii, "(ascii)" >>>;
        }
    }
}