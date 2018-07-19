// initialize the midiclient and define a midi port, on PC I use the free loopMidi software to route midi signals
MIDIClient.init;
~midiPortA = MIDIOut(1);



// there are many patterns to explore - here I convert each pattern to a stream - a.next will iterate through each pattern
a = Pseq([1,2,3,4,5],inf).asStream;
a = Pseries(0,2,inf).asStream;
a = Prand([1,5,10,20],inf).asStream;
a = Pxrand([1,5,10,20],inf).asStream;
a = Pwhite(200,300,inf).asStream;
a = Pexprand(200,300,inf).asStream;
a = Pbrown(200,300,10,inf).asStream;

a.next
a.nextN(10);

// using a predefined array of data in a pattern
~durations = [1,1,0.25,0.25,0.5];
~pitches = [200,300,400,500,600];
a = Pseq(~pitches,inf).asStream;
b = Pseq(~durations,inf).asStream;


//a Pbind will bind a key such as \freq with values - these values can be single numbers or patterns - this will use a default synth to generate the sound

Pbind(\freq,Pseq([400,500,600],inf),\dur,0.25).play;

//list of some of the default key values to use in a Pbind
\legato - 0.5 staccato, 1 full length, 2 notes overlap
\octave - changes the octave, default is 5
\scale - which scale to use when used in conjunction with \degree - \scale, Scale.locrian - Scale.directory
\degree - degree of a scale to use 0,1,2,3,4,5,6,7 is a one octave scale    1.1 would be a half step up
\dur,Rest(0.5) creates a rest 0.5 beats long
\mtranspose - transpose the mode this number is simply added to \degree
\stretch - amount to stretch \dur this will effect patterns individually
\tempo - change tempo of all patterns playing on the same clock


//use degree for pitch and using Rest
Pbind(\degree,Pseq([1,2,3],inf),\dur,Pseq([0.25,0.25,0.25,Rest(0.25)],inf)).play;

//chords
Pbind(\degree,Pseq([[1,3,5]-1,[2,4,6]-1],inf),\dur,1).play;

a = Ptuple([
	Pseq([1,2,5]-1,1),
	Pseq([3,4,9]-1,1),
	Pseq([5,6,7]-1,1)
	],inf);

Pbind(\degree,a,\dur,1).play;

// define a synth def and use a Pbind to control parameters
SynthDef(\harpsi, { |outbus = 0, freq = 440, amp = 0.1, gate = 1|
    var out;
    out = EnvGen.ar(Env.perc, doneAction: 2) * amp *
        Pulse.ar(freq, 0.25, 0.75);
    Out.ar(outbus, out ! 2);
}).add;

(0!7) ++ (1!7);

Pbind(\instrument, \harpsi, \freq,Pseq([400,500,600],inf),\dur,0.25).play;


Scale.directory;

//same using degree, mtranspose,octave and scale keys
Pbind(\instrument, \harpsi, \degree,Pseq([0,1,2,3,4,5,6],inf),\scale, Scale.dorian,\mtranspose, Pseq((0!7) ++ (2!7),inf),
	\octave,Pseq((5!14)++ (4!14),inf),\dur,0.25).play;



//same alternating between different scales
Pbind(\instrument, \harpsi, \degree,Pseq([0,1,2,3,4,5,6],inf),\scale, Pseq((Scale.dorian!7) ++ (Scale.locrian!7)++ (Scale.whole!7),inf),\mtranspose, Pseq((0!7) ++ (2!7),inf),\octave,Pseq((5!14)++ (4!14),inf),\dur,0.25).play;




// send to a midi instrument
Pbind(\type, \midi,\midiout, ~midiPortA,\legato,0.9,\degree,Pseq([1,2,3,4,5],inf),\dur,0.25,\amp,0.7).play;




