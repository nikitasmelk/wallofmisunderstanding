MIDIClient.init;

MIDIIn.connectAll;

~notes = Array.newClear(128);
~bend = 8192;
~bpm = TempoClock.new(60/60).permanent_(true);


~selectedSynth = "vintageOrgan";

~bufferArray = Array.newClear(128);

~bufferPPG = Buffer.readChannel(s, "/Users/nikitasmelk/Desktop/RECITAL/Televized.wav",channels: [0]);




MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn;
	[vel, nn].postln;
	~bufferArray[nn].postln;
	~notes[nn] = Synth.new(

		~selectedSynth,
		[
			\buf, ~bufferArray[nn],
			\freq, nn.midicps,
			\amp, vel.linexp(1,127,0.1,0.6) ,
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
			~looper.set(\trig, 1, \run, 1, \reclev, 2, \prelev, 1, \xfade, 0.02);
		}
		{cc_num == 21} {
			//stop recording/overdubbing, begin/continue looping
			"stop recording/overdubbing, begin/continue looping".postln;
			~looper.set(\run, 0, \reclev, 0, \prelev, 1);
		}
		{cc_num == 22} {
			//start overdubbing (slight attenuation on existing content to prevent buildup)
			"start overdubbing (slight attenuation on existing content to prevent buildup)".postln;
			~looper.set(\run, 0, \reclev, 1,\prelev, -1.dbamp);
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

			~bufferPPG.duration;
			//~bufferPPG.play;

			Synth(\singleStereoSamplePlayer, [\buf, ~bufferPPG, \amp, 2.0]);



/*			~ppgPlayer = Pbind(
				\instrument, "grain-asr",
				\dur, ~bufferPPG.duration,
				\buffer, Prand([~bufferPPG], inf),
				//\buffer, Prand([~bufferArray[50]], inf),
				//\buffer, Pseq([~bufferArray[56], ~bufferArray[56], ~bufferArray[57], ~bufferArray[57], ~bufferArray[56]], inf),
				\startPos, 0.0,
				//\startPos, Pwhite(0.02, 0.01, inf),
				\rate, 1,
				\amp, 1.0,
				\pan, 0.0,
				\legato, 1,
			).play;*/



		}
		{cc_num == 17} {

			~bufferRain = Buffer.readChannel(s, "/Users/nikitasmelk/Desktop/music/SuperCollider/samples/rain/SCU RAIN.wav",channels: [0]);
			~bufferRain2 = Buffer.readChannel(s, "/Users/nikitasmelk/Desktop/music/SuperCollider/samples/rain/SCU RAIN 2.wav",channels: [0]);


			~beat1 = Pbind(
				\instrument, "grain-asr-effects",
				\dur, Pwhite(5, 25, inf),
				\buffer, Prand([~bufferRain], inf),
				//\buffer, Prand([~bufferArray[50]], inf),
				//\buffer, Pseq([~bufferArray[56], ~bufferArray[56], ~bufferArray[57], ~bufferArray[57], ~bufferArray[56]], inf),
				\startPos, Pwhite(0.02, 0.7, inf),
				//\startPos, Pwhite(0.02, 0.01, inf),
				\rate, Pseq([1.5], inf),
				//\amp, Pwhite(0.1, 0.5, inf) * 1.0,
				\amp, 0.5,
				\pan, -1.0,
				\legato, 5,
			).play;

			~beat2 = Pbind(
				\instrument, "grain-asr-effects",
				\dur, Pwhite(5, 25, inf),
				\buffer, Prand([~bufferRain2], inf),
				//\buffer, Prand([~bufferArray[50]], inf),
				//\buffer, Pseq([~bufferArray[56], ~bufferArray[56], ~bufferArray[57], ~bufferArray[57], ~bufferArray[56]], inf),
				\startPos, Pwhite(0.02, 0.7, inf),
				//\startPos, Pwhite(0.02, 0.01, inf),
				\rate, Pseq([1.5], inf),
				\amp, Pwhite(0.1, 0.5, inf),
				\pan, 1.0,
				\legato, 3,
			).play;

			// ADD A SYNTH SWITCH FROM PPG TO RAIN

		}
		{cc_num == 18} {

			~beat1.stop;
			~beat2.stop;


		}
		{cc_num == 19} {
			//~selectedSynth = ~arrayOfSynths.choose;
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

"RAIN MIDI FILE LOADED".postln;