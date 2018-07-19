// define your own buffers

b = Buffer.read(s,"C:/Users/Surabhi/Desktop/IIITD/Other/Proj/Bong wav.wav");
b = Buffer.read(s,"D:/backup/Documents/Audio & Video & Image Samples/Audio/AppleLoops/Jam Pack 1/Orchestral Woodwinds 03.wav" );
c = Buffer.read(s, "C:/Users/Timothy/Desktop/downloaded files/violin.wav");



(
{
	var signal;
	{
		inf.do
		{
			signal = PlayBuf.ar(1,b.bufnum,1,loop:1);
		}
	}.fork()


}.play
)



(
{
	var signal,ampEnv,sample;
	sample = PlayBuf.ar(2,b.bufnum,loop:1) * 0.5;
	//signal = SoundIn.ar();
	ampEnv = Amplitude.ar(sample,0.004,0.04);
	//ampEnv = Amplitude.ar(signal,0.04,0.04);
	signal = SinOsc.ar(700) * ampEnv;
	[signal,sample]
}.play
)


(
{
	var signal,ampEnv,chain;
	signal = PlayBuf.ar(1,b.bufnum,loop:1);


	ampEnv = WAmp.kr(signal,0.2).poll(60) * 0.95;
	signal = SinOsc.ar() * ampEnv;



}.play
)



(
{
	var signal,ampEnv,chain;
	signal = PlayBuf.ar(2,b.bufnum,loop:1) ;
	chain = FFT(LocalBuf(1024), signal);  // for sampling rates 44100 and 48000

	ampEnv =  Loudness.kr(chain,0.01,6).poll(5);

	signal = SinOsc.ar() * ampEnv;



}.play
)


(
{
	var signal,ampEnv,chain,sample;
	sample = PlayBuf.ar(2,c.bufnum,2,loop:1) ;
	chain = FFT(LocalBuf(1024), sample);  // for sampling rates 44100 and 48000

	ampEnv = PV_JensenAndersen.ar(chain, threshold:MouseX.kr(0.01, 1.0));
	//signal = SinOsc.ar(300) * ampEnv
	//signal = SinOsc.ar(300) * Decay.ar(0.3 * ampEnv, 0.3);
	signal = SinOsc.ar(300) * EnvGen.ar(Env.sine(0.1,0.3),ampEnv) * 0.8;
	//[sample,signal]



}.play
)




(
{
	var signal,ampEnv,chain;
	signal = PlayBuf.ar(2,b.bufnum,loop:1) ;
	chain = FFT(LocalBuf(1024), signal);  // for sampling rates 44100 and 48000

	ampEnv = PV_HainsworthFoote.ar(chain, MouseX.kr(0,1), MouseY.kr(0,1));

	signal = SinOsc.ar(300) * EnvGen.ar(Env.perc(0.1,0.3),ampEnv) * 0.8;
	//signal = SinOsc.ar(300) * ampEnv;


}.play
)


( //sample tracking
SynthDef("pitchFollow1",{
    var in, amp, freq, hasFreq, out;

    in = PlayBuf.ar(1,c.bufnum,2, loop:1);
    amp = Amplitude.kr(in, 0.05, 0.05);

    # freq, hasFreq = Tartini.kr(in);

    out = Mix.new(VarSaw.ar(freq * [0.5,1,2], 0, LFNoise1.kr(0.3,0.1,0.1), amp));

    Out.ar(0,[out,in])
}).play(s);
)



freq.cpsmidi.round(1).midicps

481.145141.cpsmidi.round(1).midicps
71.midicps

(
SynthDef("pitchFollow1",{
    var in, amp, freq, hasFreq, out;
    in =  PlayBuf.ar(1,c.bufnum,2, loop:0);
    amp = Amplitude.kr(in, 0.05, 0.05);
    # freq, hasFreq = Tartini.kr(in, 0.93,1024,512,512);
   // freq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
    out = Mix.new(VarSaw.ar(freq * [0.5,1,2], 0, LFNoise1.kr(0.3,0.1,0.1), amp));
    6.do({
        out = AllpassN.ar(out, 0.040, [0.040.rand,0.040.rand], 2)
    });
    Out.ar(0,out)
}).play(s);
)

(
a= SynthDef("testtartini",{arg infreq=440;
    var in, freq, hasFreq, out;

    in=Mix(PlayBuf.ar(2,c.bufnum,2));

    # freq, hasFreq = Tartini.kr(in);

//freq.poll;
	freq.cpsmidi.round(1).poll;

    Out.ar(0,[SinOsc.ar((freq*2),0.1)]);
}).play(s);
)



//use mic input

(
a = {
	var ampEnv,signal,sample,freq,hasFreq;
	//sample = Mix(PlayBuf.ar(2,b.bufnum,1));
	sample = SoundIn.ar();
	ampEnv = Amplitude.ar(sample,0.04,0.04);
	#freq,hasFreq = Pitch.kr(sample,median:8);
	signal = SinOsc.ar(freq) * ampEnv;
	signal = LPF.ar(signal, 1000);
	[signal,signal];
}.play;
)



(
a = {
	var ampEnv,signal,sample,freq,hasFreq,chain;
	sample = Mix(PlayBuf.ar(2,b.bufnum,1,loop:1));
	chain = FFT(LocalBuf(1024), sample);  // for sampling rates 44100 and 48000

	ampEnv = PV_JensenAndersen.ar(chain, threshold:MouseX.kr(0.01, 1.0));

	#freq,hasFreq = Pitch.kr(sample,median:8);
	signal = SinOsc.ar(freq) * EnvGen.ar(Env.sine(0.2,0.5),ampEnv) * 0.8;
	signal = LPF.ar(signal, 1000);
	[signal,signal];
}.play;
)






(
a = {
	var ampEnv,signal,sample,freq,hasFreq;
	//sample = Mix(PlayBuf.ar(2,b.bufnum,1));
	sample = SoundIn.ar;
	ampEnv = Amplitude.ar(sample,0.04,0.04);
	#freq,hasFreq = Pitch.kr(sample,median:8);
	signal = SinOsc.ar(freq) * ampEnv;
	//signal = LPF.ar(signal, 1000);
	[signal,signal];
}.play;
)


(
a = {
	var ampEnv,signal,sample,freq,hasFreq;
	sample = PlayBuf.ar(2,b.bufnum,1,loop:1);
	ampEnv = Amplitude.ar(sample,0.04,0.04);
	   # freq, hasFreq = Tartini.kr(sample,0.5);

	freq = freq.cpsmidi.round(1).midicps;
	signal = SinOsc.ar(freq) * ampEnv;

	[signal,sample];
}.play;
)





