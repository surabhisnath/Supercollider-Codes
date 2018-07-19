MIDIClient.init;
MIDIIn.connectAll;
~midiPortA = MIDIOut(0);
~count=4;
(
MIDIdef.noteOn(\noteOnTest, {
	arg vel,nn,chan,src;
	{
		var sig, env;
		if( ~count==4,{
			case
			{ nn==60 } { sig=[SinOsc.ar(nn.midicps)+SinOsc.ar((nn+4).midicps)+SinOsc.ar((nn+7).midicps),SinOsc.ar(nn.midicps)+SinOsc.ar((nn+4).midicps)+SinOsc.ar((nn-3).midicps),SinOsc.ar(nn.midicps)+SinOsc.ar((nn-3).midicps)+SinOsc.ar((nn-7).midicps)].choose;}

			{ nn==62 } { sig=[SinOsc.ar(nn.midicps)+SinOsc.ar((nn+3).midicps)+SinOsc.ar((nn+7).midicps),SinOsc.ar(nn.midicps)+SinOsc.ar((nn+3).midicps)+SinOsc.ar((nn-3).midicps),SinOsc.ar(nn.midicps)+SinOsc.ar((nn-3).midicps)+SinOsc.ar((nn-7).midicps)].choose;}

			{ nn==64} { sig=[SinOsc.ar(nn.midicps)+SinOsc.ar((nn+3).midicps)+SinOsc.ar((nn+7).midicps),SinOsc.ar(nn.midicps)+SinOsc.ar((nn+3).midicps)+SinOsc.ar((nn-3).midicps),SinOsc.ar(nn.midicps)+SinOsc.ar((nn-3).midicps)+SinOsc.ar((nn-7).midicps)].choose;}

			{ nn==65 } {sig=[SinOsc.ar(nn.midicps)+SinOsc.ar((nn+4).midicps)+SinOsc.ar((nn+7).midicps) , SinOsc.ar(nn.midicps)+SinOsc.ar((nn+4).midicps)+SinOsc.ar((nn-3).midicps) , SinOsc.ar(nn.midicps)+SinOsc.ar((nn-3).midicps)+SinOsc.ar((nn-7).midicps)].choose;}

			{ nn==67} { sig=[SinOsc.ar(nn.midicps)+SinOsc.ar((nn+4).midicps)+SinOsc.ar((nn+7).midicps),SinOsc.ar(nn.midicps)+SinOsc.ar((nn+4).midicps)+SinOsc.ar((nn-3).midicps),SinOsc.ar(nn.midicps)+SinOsc.ar((nn-3).midicps)+SinOsc.ar((nn-7).midicps)].choose; }

			{ nn==69 } { sig=[SinOsc.ar(nn.midicps)+SinOsc.ar((nn+3).midicps)+SinOsc.ar((nn+7).midicps),SinOsc.ar(nn.midicps)+SinOsc.ar((nn+3).midicps)+SinOsc.ar((nn-3).midicps),SinOsc.ar(nn.midicps)+SinOsc.ar((nn-3).midicps)+SinOsc.ar((nn-7).midicps)].choose;}

			{ nn==71 } { sig=[SinOsc.ar(nn.midicps)+SinOsc.ar((nn+3).midicps)+SinOsc.ar((nn+6).midicps),SinOsc.ar(nn.midicps)+SinOsc.ar((nn+3).midicps)+SinOsc.ar((nn-4).midicps),SinOsc.ar(nn.midicps)+SinOsc.ar((nn-4).midicps)+SinOsc.ar((nn-7).midicps)].choose;};
			~count=1;
			"something".postln;
		},{
			sig=SinOsc.ar(nn.midicps);
			~count=~count+1;
			"ironic something".postln;
});

		env=EnvGen.kr(Env.perc,doneAction:2);
		sig=sig*env;
	}.play

});
)

s.boot

