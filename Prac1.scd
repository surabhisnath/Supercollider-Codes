//Create a synth that modifies a sound file.
//

t = TempoClock;


b=Buffer.read(Server.local,"C:/Users/Surabhi/Desktop/IIITD/Other/Proj/WAV.wav");
b.play;

b=Buffer.read(Server.local,"C:/Users/Surabhi/Desktop/081011_05.4.WAV");
b.play;

s;

//Synthdef
(
SynthDef.new(\test1,
	{
		arg noiseHz=Line.kr(2,0,5);
		var freq1, freq2, amp, sig1, sig2;
		freq1=LFSaw.kr();
		freq2=LFNoise0.kr(noiseHz).exprange(200,1000);
		amp=LFNoise1.kr(12).exprange(0.02,1);
		sig1=LFSaw.ar(freq1)*amp;
		sig2=SinOsc.ar(freq2)*amp;
		Out.ar(0,sig1);
		Out.ar(1,sig2);
}).add;
)


//Freeverb
(
a={
	a = WhiteNoise.ar;
	a = FreeVerb.ar(a,0.7,0.8,0.25);
}.play;
)
x=Synth.new(\test1);



//SynthDef
(
SynthDef.new(\test2,
	{
		var signal, env, freq, sign;
		freq=Rand(100,1000);
		env = LFSaw.kr(5,0,2);
		signal=Pulse.ar(freq)*env;
		sign=Pulse.ar([100,200,300,400,500]);
		sign=Mix.new(sign)*0.5;
		signal=Freeverb.ar(signal);
		Out.ar([0,1],signal);
 	}
).add;
)

y=Synth.new(\test2);
y.set(\freq,Rand(500,800));
y.free;


(
SynthDef(\test3,
	{



	}
)

)

//Multichannel
(
x={
	var si, am;
	am=Line.kr(7,0,5);
	si=SinOsc.ar([900,700]);
	si=si*am;
}.play;
)

(
{
	Synth.new(\test1,[\freq1,900]);
	1.wait;
	Synth.new(\test1,[\freq1,Rand(500,800)]);
	0.5.wait;
	Synth.new(\test1,[\freq1,1000]);
	1.wait;
	Synth.new(\test1,[\freq1,Rand(1000,1500)]);
	1.wait;
	Synth.new(\test1,[\freq1,Rand(200,300)]);
}.fork(t);
)


Arrays.fill
Arrays.rand
Arrays.interpolation
Arrays.series







