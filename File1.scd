b=Buffer.read(Server.local,"C:/Users/Surabhi/Desktop/IIITD/Other/Proj/Bong wav.wav");
b.play;
c=Buffer.read(Server.local,"C:/Users/Surabhi/Desktop/IIITD/Other/Proj/Tic Toc wav.wav");
c.play;
d=Buffer.read(Server.local,"C:/Users/Surabhi/Desktop/IIITD/Other/Proj/Cymbal wav.wav");
d.play;
e=Buffer.read(Server.local,"C:/Users/Surabhi/Desktop/IIITD/Other/Proj/Cork wav.wav");
e.play;
f=Buffer.read(Server.local,"C:/Users/Surabhi/Desktop/IIITD/Other/Proj/Jingle wav.wav");
f.play;



~myArray = [c,d,d,d,d,b,e,e];
~dur = [6.5,6,5.3,0.7,5.5,6.5,3,3];

(
t=TempoClock(3);

a ={
 	8.do
	{|i|
		~myArray[i].play;
		~dur[i].wait;
	}
}.fork(t);
)

(
t=TempoClock();
x={
	inf.do
	{
		~myArray[6].play;
		1.wait;
	}
}.fork(t);
t.tempo=2;
)
t.tempo=4;
t.tempo=8;
x.stop;


(
t=TempoClock(6);
b={
	2.do
	{
		~myArray[0].play;
		4.wait;
		~myArray[0].play;
		13.wait;
		~myArray[0].play;
	}
}.fork(t);
)



~freq=[440, 500, 660, 700];
~dur=[1,0.5];
t = TempoClock(1);

(
a = {

	inf.do{|i|
		Synth(\mySynth,[\freq,~freq[i % ~freq.size].midicps]);
		~dur[i % ~dur.size].wait;
	   t.tempo = rrand(1,5);
	}

}.fork(t);
)




SynthDef(\mySynth,{

	arg freq;
	var signal, env;
	env = EnvGen.ar(Env.adsr,doneAction:2);
	signal = SinOsc.ar(freq) * env;
	//signal = FreeVerb.ar(signal,1);
	Out.ar(0,[signal,signal]);

}).add;




~arrayfive = [54, 56, 58, 61, 63, 66, 68, 70, 73, 75, 78];
~durationfive = [0.25,0.5];

z={SinOsc.ar(66.midicps)}.play
(
a = {

	inf.do
	{
		|i|
		q=Synth(\mySynth,[\freq,~arrayfive[rrand(0,10)].midicps]);
		~durationfive[rrand(0,1)].wait;
		q.free;
	}

}.fork();
)

//~arrayfive = [54];


//simplest
(
p = {
	arg control=10;
	var freq, amp, signal;
	freq = LFNoise0.kr(control).range(800, 1000);
	amp = Line.kr(5,0,5,doneAction:2);
	signal = SinOsc.ar(freq)*amp;
}.play;
)

p.set(\control, 20);

//using Synthdef

(SynthDef.new(\one,
	{
		arg a=100,b=5, c=10;
		var amp1, amp2, freq1, freq2, sig1, sig2;
		amp1 = LFPulse.kr(c,0);
		amp2 = LFPulse.kr(c,0.5);
		freq1 = LFNoise0.kr(4).exprange(a,a*b);
		freq2 = LFNoise0.kr(4).exprange(a,a*b);
		sig1 = Pulse.ar(freq1,0.5,amp1);
		sig2 = Pulse.ar(freq2, 1, amp2);
		sig1 = FreeVerb.ar(sig1,0.7,0.7,0.5);
		sig2 = FreeVerb.ar(sig2,0.7,0.8,0.5);
		Out.ar(0,sig1);
		Out.ar(1,sig2);
}).add;
)
l = Synth.new(\one);
l.set(\a,200);
l.set(\b,10);
l.set(\c,2);

//Envelopes
(
g = {
	//arg t_gate = 0;
	var sig, freq, env, env1;
	env = XLine.kr(0.01,1,3,doneAction:0);
	env1 = EnvGen.kr(Env.adsr());
	//env1 = EnvGen.kr(Env.new([0,1,0],[1,1],[1,1],t_gate));
	freq = XLine.kr(800,100,5,doneAction:2);
	sig = SinOsc.ar(freq)*env1;
}.play;
)








