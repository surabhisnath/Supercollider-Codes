//Amplitude
//Wamp
//poll to display
//increasing the window size will round the sound more, averages over a longer duration
//FFT
//FFT.new(buffer, in, window size = 1024)

//chain = FFT(LocalBuf(1024), signal)

//Loudness.kr(FFT,smark, mask) - takes into account how we perceive.
//Pv_HainsworthFoote - only gives 0/1
//spectral change - quality of sound, 2 people singing C
// # means a tuple is being returned.

//loopMIDI - setup ports here
//voice meter
//kontakt

(
x ={
	var in, amp, freq, hasfreq, out;
	in = SoundIn.ar(0);
	amp = Amplitude.ar(in);
	# freq, hasfreq = Pitch.kr(in);

	LFTri.ar(freq*[1,2])*amp;
}.play
)



(
x ={
	var in, amp, freq, an, out;
	in = SoundIn.ar(0);
	amp = Amplitude.ar(in);
	an = Pitch.kr(in).poll;
	freq = an[0];
	freq.postln;
	LFTri.ar(freq*[1,2])*amp;
}.play
)


x.free;

(
var out;
// Pan2 uses an OutputProxy for each of its two outputs.
out = Pan2.ar(WhiteNoise.ar, 0.0);
out.postln;
)

(
h = {
var input = SoundIn.ar(0);
var pitchoutput = Pitch.kr(input);
var rate= ControlRate.ir*0.5; //faster than this and triggers can get dropped
SendTrig.kr(Impulse.kr(rate),0,pitchoutput[0]);
LFTri.ar(pitchoutput[0]*[1,2]);
}.play
)


(
SynthDef(\freqpoll,{
var input = SoundIn.ar(0);
var pitchoutput = Pitch.kr(input);
var rate= ControlRate.ir*0.5; //faster than this and triggers can get dropped

SendTrig.kr(Impulse.kr(rate),0,pitchoutput[0]);

}).send(s)
)

(
OSCresponder(s.addr,'/tr',{ arg time,responder,msg;
	[time,responder,msg].postln;

	msg[3].postln;

}).add
);






