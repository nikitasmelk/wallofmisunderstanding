










(

MIDIClient.init;

MIDIIn.connectAll;

//~bufferArray[nameAsInt] = Buffer.readChannel(s,path,channels: [0]);
~selectedSynth = "rainyOrgan";
~notes = Array.newClear(128);
~bend = 8192;

MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn;
	[vel, nn].postln;
	//~bufferArray[nn].postln;
	~notes[nn] = Synth.new(

		~selectedSynth,
		[
			//\buf, ~bufferArray[nn],
			\freq, nn.midicps,
			\amp, vel.linexp(1,127,0.3,2.0) ,
			\gate, 1,
			\bend, ~bend.linlin(0,16383,-2,2),
	    ]);

		//\sampleSynth,[\bufnum, ~testbuf]);
});

MIDIdef.cc(\pads_control, {
	arg value, cc_num;
	[value, cc_num].postln;

	//16 - 23 pads nums
	if(value > 0){

		case
		{cc_num == 20} {
			//initial start record
			"initial start record".postln;
			~looper.set(\trig, 1, \run, 1, \reclev, 1, \prelev, 1, \xfade, 0.02);
		}
		{cc_num == 21} {
			//stop recording/overdubbing, begin/continue looping
			"stop recording/overdubbing, begin/continue looping".postln;
			~looper.set(\run, 0, \reclev, 0, \prelev, -3.dbamp); // fade out the thing
		}
		{cc_num == 22} {
			//start overdubbing (slight attenuation on existing content to prevent buildup)
			"start overdubbing (slight attenuation on existing content to prevent buildup)".postln;
			~looper.set(\run, 0, \reclev, 1,\prelev, -3.dbamp);
		}
		{cc_num == 23} {
			//reset, clear buffer, but do not begin recording again
			"reset, clear buffer, but do not begin recording again".postln;
			~b.zero; ~looper.set(\trig, 1, \run, 0, \reclev, 0, \prelev, 0, \xfade, 0.02);
		}
		{cc_num == 77}{
			~looper.set(\loopAmp, value.linlin(0, 127, 0.5, 5)).postln;
		}
		{cc_num == 16} {



			~over1 = Pbind(
				\instrument, "grain-asr",
				\dur, Pwhite(7.0, 10.0, inf),
				\buffer, ~overflow_piano,
				\startPos, Pwhite(0.5, 0.8, inf),
				\rate, Prand([1], inf),
				\att, 2.0,
				\rel, 4.0,
				//\rate, Pseq([-0.2, 0.5, -1.5, 2, -0.2] * 20, inf),
				\amp, Pseq([Pseries(0, 0.2, 5), Pseries(1.0, -1/59, 40), ]),//Pwhite(0.1, 1.0, inf) * 0.7,
				\legato, 2.0,
				\pan, -1,
			).play;


			5.postln;


			~over3 = Pbind(
				\instrument, "grain-asr",
				\dur, Pwhite(2.0, 10.0, inf),
				\buffer, ~overflow_piano,
				\startPos, Pwhite(0.1, 0.4, inf),
				\rate, Prand([0.5, 1], inf),
				\att, 2.0,
				\rel, 4.0,
				//\rate, Pseq([-0.2, 0.5, -1.5, 2, -0.2] * 20, inf),
				\amp, Pseq([Pseries(0, 0.2, 5), Pseries(1.0, -1/29, 30)]),//Pwhite(0.1, 1.0, inf) * 0.7,
				\legato, 2.0,
				\pan, 1,//Prand([-1, -0.5, -0.75, -0.25, 0.0, 0.25, 0.5, 0.75, 1.0], inf),
			).play;
		}
		{cc_num == 17} {

			~over1.stop;
			~over3.stop;
		}
		{cc_num == 19} {
			~selectedSynth = ~arrayOfSynths.choose;
			~selectedSynth.postln;
		}

	};

},(16..77)
);

MIDIdef.noteOff(\noteOffTest, {
	arg vel, nn;
	//[vel, nn].postln;
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
});

MIDIdef.bend(\bendTest, {
	arg val, chan, src;
	//[val, chan, src].postln;
	~bend = val;
	~notes.do{arg synth; synth.set(\bend, val.linlin(0, 16383, -2, 2))};
});
)
