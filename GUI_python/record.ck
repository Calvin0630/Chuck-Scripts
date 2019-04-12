// this script will record the speaker output and put the resulting wav in Chuck-Scripts\Recordings
//the only arg is the name of the file. Otherwise the name is pizza_time

// pull samples from the dac
// WvOut2 -> stereo operation
dac => Gain g => WvOut w => blackhole;

// set the prefix, which will prepended to the filename
// do this if you want the file to appear automatically
// in another directory.  if this isn't set, the file
// should appear in the directory you run chuck from
// with only the date and time.
"chuck-session" => w.autoPrefix;

//recording folder
"C:\\Users\\Calvin\\Documents\\Chuck-Scripts\\Recordings\\"=> string folder;
// this is the output file name
string fileName;
if(me.args() ==1) {
    me.arg(0)+".wav"=> fileName;
}
else {
    "pizza_time.wav"=>fileName;
}
folder + fileName => w.wavFilename;

// print it out
<<<"writing to file: ", w.filename()>>>;

// any gain you want for the output
.5 => g.gain;

// temporary workaround to automatically close file on remove-shred
null @=> w;

// wait for user to press tab to exit

Hid hi;
HidMsg msg;

// which keyboard
0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

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
            //<<<msg.key,"">>>;
            //tab
            if (msg.key == 43) me.exit();
        }
        
        else
        {
            //<<< "up:", msg.which, "(code)", msg.key, "(usb key)", msg.ascii, "(ascii)" >>>;
        }
    }
}

