SinOsc sinA=>SinOsc final =>blackhole;
//SinOsc sinB=>final;
1=>sinA.freq;
3=>sinA.gain;
1=>sinA.freq;
3=>sinA.gain;


//duration of time 
.01=>float deltaTime;
//number of measurements in total
2450 => int n;

Shred current;
spork~recordFinal() @=>current;
(deltaTime*(n $ float))::second=>now;


fun void recordTime() {
    now=>time start;
    <<<n>>>;
    repeat(n) {
        <<<((now-start)/44.1) , "">>>;   
        deltaTime::second=>now;
    }
}

fun void recordSinA() {
    repeat(n) {
        <<<sinA.last() , "">>>;   
        deltaTime::second=>now;
    }
}

fun void recordFinal() {
    repeat(n) {
        <<<final.last() , "">>>;   
        deltaTime::second=>now;
    }
}