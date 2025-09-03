//Line6 Loop Pedal Emulation
//(condensed into one SynthDef)
//FEEDBACK WARNING! USE HEADPHONES!
// ServerOptions.inDevices;
//
// Server.default.options.device = "Aggregate Device";
// Server.default.options.inDevice_("Built-in Microphone");
// Server.default.options.outDevice_("Built-in Output");


// LOOPER

s.waitForBoot({

	~mainOut = 0;
	~micIn = 0;

	Buffer.freeAll;

	~overflow_piano = Buffer.read(s, "/Users/nikitasmelk/Desktop/RECITAL/overflow_piano_sample2.wav");
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


});

"OVERFLOW SYNTHS FILE LOADED".postln;
