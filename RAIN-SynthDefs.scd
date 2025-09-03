s.waitForBoot({

	~mainOut = 0;
	~micIn = 0;

	Buffer.freeAll;
	s.sync;
	~b = Buffer.alloc(s, s.sampleRate * 300);

	SynthDef(\looper, {
		var mic, trig, max, ptr, loop, rec, mix;
		var xfade = \xfade.kr(0.2);
		var buf = \buf.kr(0);
		mic = SoundIn.ar(\in.ir(0)) * \inGain.kr(3);


		// NEW MIC LOGIC TURN ON MIC AFTER A CERTAIN TIME
		// how long ppg is
		//mic = mic * Env.pairs([[0,0],[180,0],[10,1]]).kr;
		// CHANGE THIS TO


		//mic = s.out(0);
		//mic = In.ar(\in.ir(0));//ir()
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
	amplitudes = [ -55, -50, -65, -46, -60, -20, -82, -55, -77, -70, -90, -78, -78, -80, -95, -90].dbamp;
	//amplitudes = [ SinOsc.ar(0.1).range(-120, -25), -33, -45, -36, SinOsc.ar(10).range(-120, -45), -48, -82, SinOsc.ar(0.3).range(-120, -55), -77, -70, -90, -78, SinOsc.ar(0.1).range(-120, -55), -80, -95, -90].dbamp;
	//SinOsc.ar(10).range(-120, -25)
	env = Env.asr(att, amp, rel).kr(gate: gate, doneAction: 2);
	snd = SinOsc.ar(
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

SynthDef("vintageOrgan", {
    |out=0, freq=440, amp=0.8, gate=1, pan=0, att=0.5, rel=4.0|
    var env, vib, trem, osc1, osc2, sound;

    // Simple ASR envelope
    env = Env.asr(att, amp, rel).kr(gate: gate, doneAction: 2);

    // Gentle vibrato
		vib = SinOsc.kr(SinOsc.ar(1/5).range(1,6), 0, 0.003, 1);

    // Two sine voices: one slightly detuned
    osc1 = LFTri.ar(freq * vib) * 0.6;
    osc2 = LFSaw.ar((freq * vib) * 0.997) * 0.9;
    sound = osc1 + osc2;

    // Vintage tremolo
    trem = SinOsc.kr(1/5, 0, 0.5, 0.5);
    sound = sound * trem;

    // Simple low‑pass to warm it up
	sound = LPF.ar(sound, SinOsc.ar(1/6).range(500, 1000));

    // Apply envelope and pan
	sound = Mix.ar(sound);
    sound = Pan2.ar(sound * env, pan) * 2;

	sound = Limiter.ar(sound);
    Out.ar(out, sound);
	DetectSilence.ar(sound, 0.001, 0.2, doneAction: 2);
}).add;



SynthDef("grain-asr-effects", {arg buffer, rate = 1, startPos = 0, gate = 1, att = 5, rel = 0.1, amp = 1, pan = 0;
    var env, snd;
	env = Env.asr(att, amp, rel).kr(gate: gate);
    snd = PlayBuf.ar(
        numChannels: 1,
        bufnum:  buffer,
        rate: rate * BufRateScale.kr(buffer),
        startPos: startPos * BufFrames.kr(buffer),
		loop: 0
    );
    snd = snd * env;

	snd = FreeVerb.ar(
		in: snd,
		mix: 0.5,
		room:  0.9,
		damp: 0.9
	);

	snd = Limiter.ar(snd);
	snd = Mix.ar(snd);
	snd = Pan2.ar(snd, pan);

    Out.ar(0, snd);
    DetectSilence.ar(snd, doneAction: 2);
}).add;

    SynthDef(\singleStereoSamplePlayer, { arg buf, amp = 1, out = 0;
        var sig;
        // Set numChannels to 2 for stereo playback.
        sig = PlayBuf.ar(
            numChannels: 2,
            bufnum: buf,
            rate: BufRateScale.kr(buf),
            loop: 0,
            doneAction: 2
        );

	sig = Mix.ar(sig);
        Out.ar(out, sig * amp);
    }).add;


});

"RAIN SYNTHS FILE LOADED".postln;