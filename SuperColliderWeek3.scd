
/*
Concepts:

Buffers
playing samples
Subtractive Synthesis
Audio Effects
Sequencing
Loops
SynthDefs
*/


/*
Homework:

1. listen to "I am Sitting in a Room" by Alvin Lucier
a. this is good example of the resonant frequencies in a room

https://www.youtube.com/watch?v=fAxHlLK3Oyk

2. create your own synth defs and use loops to create instances and set parameters

3. read the Pitch Shift section in chapter 4 of the Computer Music Tutorial
a. this demonstrates Pitch Shifting in the time domain
b. Pitch Shifting in the Frequency domain will be covered later




*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1. create buffers to store audio samples
a. two manditory arguments are
b. s for the server to allocate the buffer space on
c. the path where the audio is stored
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

b = Buffer.read(Server.local,"C:/Users/Surabhi/Desktop/IIITD/Other/Tim/Free Cartoon Clock Tick Tock Sound Effect.mp3");
b.play
;
c = Buffer.read(s,"D:/tsmoyers/Documents/Audio & Video & Image Samples/Audio/AppleLoops/Jam Pack World Music/Ukranian Solo Violin 09.aif");


d = Buffer.read(s,"D:/tsmoyers/Documents/Audio & Video & Image Samples/Audio/ViennaSaxaphone/VSL Tenor Sax Samples/SXT_stac_f1_C#3.wav");

*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
2. a PlayBuf UGen is a simple way to play back an audio sample
a. Two manditory arguments are
b. the number of channels the sample has
c. the buffer number - for example b.bufnum
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

(
a = {
	PlayBuf.ar(2,b.bufnum);
}.play
)


(
a = {
	var signal;

	signal = PlayBuf.ar(2,b.bufnum);
	signal = signal * SinOsc.ar(500);
	//signal = signal * SinOsc.ar(Line.kr(1500,10,3,doneAction:2));

}.play
)

*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1. Subtractive Synthesis using noise and audio files
2. a number of filters and audio effects are listed
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/


(
a = {
	var signal;
	//signal = WhiteNoise.ar();
	signal = PlayBuf.ar(2,b.bufnum);

	//signal = LPF.ar(signal,XLine.kr(100,22000,10));
	//signal = RLPF.ar(signal,XLine.kr(100,22000,10),0.2);
	//signal = HPF.ar(signal,XLine.kr(100,22000,10));
	//signal = RHPF.ar(signal,XLine.kr(100,22000,10),0.2);
	//signal = BPF.ar(signal,XLine.kr(100,22000,10),0.2);
	//signal = FreeVerb.ar(signal,Line.kr(0,1.0,10));
	//signal = Decimator.ar(signal,44100,4);
	//signal = DynKlank.ar(`[[1200,300,400,500], nil, [1, 1, 1, 1]],signal,decayscale:0.6);

}.play
)


*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1. SynthDef and an instance of Synth using an Env
2. notice that each time Synth is run a new synth is added to the server
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/



(
SynthDef(\soundA, {

	var signal;
	signal = SinOsc.ar() * Env.perc().kr();
	//signal = PlayBuf.ar(2,c.bufnum) * Env.perc().kr();
	Out.ar(0,signal);

}).add;
)


Synth(\soundA);

*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1. by using the donAction argument the synth is freed after the Env is complete
2. EnvGen gives us more options beyond that of just using Env
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

(
SynthDef(\soundA, {

	var signal;
	//signal = SinOsc.ar() * EnvGen.kr(Env.perc(),doneAction:2);
	signal = PlayBuf.ar(2,d.bufnum) * EnvGen.kr(Env.perc(),doneAction:2);
	Out.ar(0,signal);

}).add;
)


Synth(\soundA);


*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1. set synth arguments on creation
2. some arguments  include changing the pitch, duration of the Env, the buffer used and position in the buffer
3. start position is a number 0 - 1. This is multiplied by the number of frames in the buffer. 0 = beginning of the buffer, 0.5 = half, 1 = end of the buffer
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

(
SynthDef(\soundA, {

	arg pitch, duration= 1,buffer,position;
	var signal;
	//signal = SinOsc.ar() * EnvGen.kr(Env.perc(),doneAction:2);
	signal = PlayBuf.ar(2,buffer,pitch,startPos:BufFrames.kr(buffer) * position) * EnvGen.kr(Env.perc(0.01,duration),doneAction:2);
	Out.ar(0,signal);

}).add;
)


Synth(\soundA,[\pitch,rrand(0.5,1.5),\duration,rrand(0.1,2),\buffer, c.bufnum,\position,0.5]);

*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1. assign each synth to a variable
2. this allows you to set arguments after the synth is running
3. to free each synth
4. and interact with multiple instances independently
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/


(
SynthDef(\soundA,{
	arg freq = 400;
	var signal;
	signal = SinOsc.ar(freq);
	Out.ar(0,signal);


}).add;

)


x = Synth(\soundA,[\freq,400]);
y = Synth(\soundA,[\freq,500]);

x.set(\freq,rrand(500,800));
y.set(\freq,rrand(500,800));


x.free;
y.free;




*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1. sequence events using {}.fork
2. the first sequence sets a synth and the second creates new synths
3. if you try to set a synth that has already been freed you will get a node not found error
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/




(
SynthDef(\soundA,{
	arg freq = 400;
	var signal;
	//signal = SinOsc.ar(freq);
	signal = SinOsc.ar(freq)* EnvGen.kr(Env.perc,doneAction:2);
	Out.ar(0,signal);


}).add;

)

// set a synth each time - this fails but why?
(
{

	x = Synth(\soundA,[\freq,400]);
	1.wait;
	x.set(\freq,rrand(500,800));
	0.5.wait;
	x.set(\freq,rrand(500,800));
	1.wait;
	x.set(\freq,rrand(500,800));
	1.wait;
	x.free;

}.fork;
)

// create a new synth each time
(
{

	Synth(\soundA,[\freq,400]);
	1.wait;
	Synth(\soundA,[\freq,rrand(500,800)]);
	0.5.wait;
	Synth(\soundA,[\freq,rrand(500,800)]);
	1.wait;
	Synth(\soundA,[\freq,rrand(500,800)]);
	1.wait;
	Synth(\soundA,[\freq,rrand(500,800)]);

}.fork;
)



*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1. use a loop inside of the {}.fork sequence
2. random wait times can be used
3. notice that when we reach the end of each loop two notes are played - why is this?
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/


4.do{11.postln};
4.do {arg repeatnumber; repeatnumber.postln; "iteration complete".postln;};
// inf.do{10.postln}; an infinite loop but this will crash your server


(
{

	10.do{
	Synth(\soundA,[\freq,400]);
	0.25.wait;
	Synth(\soundA,[\freq,rrand(500,800)]);
	0.25.wait;
	Synth(\soundA,[\freq,rrand(500,800)]);
	0.5.wait;
	Synth(\soundA,[\freq,rrand(500,800)]);
		rrand(0.25,1).wait;
	Synth(\soundA,[\freq,rrand(500,800)]);
	}

}.fork;
)





678.midicps;
(495.cpsmidi.round).midicps;
(403.cpsmidi);