//Line6 Loop Pedal Emulation
//(condensed into one SynthDef)
//FEEDBACK WARNING! USE HEADPHONES!
ServerOptions.inDevices;

Server.default.options.device = "Aggregate Device";
Server.default.options.inDevice_("Built-in Microphone");
Server.default.options.outDevice_("Built-in Output");


(


SynthDef("rainyOrgan", { arg freq=440, amp=1, gate=1, pan=0, att = 2.0, rel = 3.0;
    var snd, snd2, env, harmonics, amplitudes;
	harmonics = [ 1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 14, 16, 18, 20, 22, 24];
	//amplitudes = [ -25, -33, -45, -36, -60, -20, -82, -55, -77, -70, -90, -78, -78, -80, -95, -90].dbamp;
	amplitudes = [ SinOsc.ar(0.1).range(-120, -25), -33, -45, -36, SinOsc.ar(10).range(-120, -45), -48, -82, SinOsc.ar(0.3).range(-120, -55), -77, -70, -90, -78, SinOsc.ar(0.1).range(-120, -55), -80, -95, -90].dbamp;
	//SinOsc.ar(10).range(-120, -25)
	env = Env.asr(att, amp, rel).kr(gate: gate, doneAction: 2);
	snd = LFTri.ar(
		freq: freq * harmonics,
		mul: amplitudes// XLine.kr(1.0, 0.0, 10.0)
	);

	snd2 = SinOsc.ar(
		freq: freq * harmonics,
		mul: amplitudes// XLine.kr(1.0, 0.0, 10.0)
	);

	snd2 = LPF.ar(in: snd2, freq: SinOsc.ar(SinOsc.ar(1/5).range(1/2, 10)).range(1000,5000));

	snd = snd * 2.5 + snd2 * 1.5;

	snd = snd * 3.0;

	snd = Mix.ar(snd) * env;
	snd = Pan2.ar(snd, pan);
	snd = Limiter.ar(snd);
	Out.ar(0, snd);

	DetectSilence.ar(snd, 0.001, 0.2, doneAction: 2);

}).add;



SynthDef("grain-asr", {arg buffer, rate = 1, startPos = 0, gate = 1, att = 0.01, rel = 0.1, amp = 1, pan = 0;
    var env, snd;
	env = Env.asr(att, amp, rel).kr(gate: gate);
    snd = PlayBuf.ar(
        numChannels: 1,
        bufnum:  buffer,
        rate: rate * BufRateScale.kr(buffer),
        startPos: startPos * BufFrames.kr(buffer),
		loop: 0,
    );
    snd = snd * env;

	//snd = DelayL.kr(snd, 5.0, 0.5, 0.1);
	snd = FreeVerb.ar(snd, 0.5, 0.9);


	snd = Mix.ar(snd);
	snd = Limiter.ar(snd);
	snd = Pan2.ar(snd, pan);
	snd = Limiter.ar(snd);
    Out.ar(0, snd);
	snd = Limiter.ar(snd);
    DetectSilence.ar(snd, doneAction: 2);
}).add;

//VARIABLES
)
(
// LOOPER
~mainOut = 0;
~micIn = 0;
s.waitForBoot({

	Buffer.freeAll;
	s.sync;
	~b = Buffer.alloc(s, s.sampleRate * 300);

	SynthDef(\looper, {
		var mic, trig, max, ptr, loop, rec, mix;
		var xfade = \xfade.kr(0.2);
		var buf = \buf.kr(0);
		//mic = SoundIn.ar(\in.ir(0)) * \inGain.kr(3);
		//mic = s.out(0);
		mic = In.ar(\in.ir(0));//ir()
		trig = Trig1.ar(\trig.tr(0), ControlDur.ir);
		max = Sweep.ar(trig, SampleRate.ir * \run.kr(0));
		ptr = Phasor.ar(trig, 1, 0, max, 0);
		loop = BufRd.ar(1, buf, ptr);
		rec = sum([
			mic * \reclev.kr(0).varlag(xfade,-2),
			loop * \prelev.kr(0).varlag(xfade,-2)
		]);
		rec = rec * \recAmp.kr(1).varlag(xfade,-2);
		BufWr.ar(rec, buf, ptr);
		mix = sum([
			loop * \loopAmp.kr(1).varlag(xfade,-2),
			mic * \micAmp.kr(1).varlag(xfade,-2)
		]);
		mix = mix * \mixAmp.kr(1).varlag(xfade,-2);
		Out.ar(\out.ir(0), mix!2);
	}).add;

	s.sync;

	~looper = Synth(
		\looper, [
			\in, ~micIn,
			\buf, ~b.bufnum,
			\out, ~mainOut
		]
	);
});

)








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

			~overflow_piano = Buffer.read(s, "/Users/nikitasmelk/Desktop/RECITAL/overflow_piano_sample2.wav");

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
