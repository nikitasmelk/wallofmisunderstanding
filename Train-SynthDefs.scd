// Train SynthDefs

s.waitForBoot({

	~train = Buffer.read(s, "/Users/nikitasmelk/Desktop/RECITAL/Московское метро Динамо.wav");

	~talking_ambience = Buffer.read(s, "/Users/nikitasmelk/Desktop/RECITAL/metro_ambience.mp3");

	~airSiren_sample = Buffer.read(s, "/Users/nikitasmelk/Desktop/RECITAL/air-raid-kyiv.mp3");

	~tea_sample = Buffer.read(s, "/Users/nikitasmelk/Desktop/RECITAL/Закипает чайник.wav");

	~bufferArray = Array.newClear(128);


	"/Users/nikitasmelk/Desktop/RECITAL/Cassette808_Samples/*.wav".resolveRelative.pathMatch.do({ |path|
		var nameAsInt = path.keep(-7).keep(3).asInteger;
		//nameAsInt.postln;

		~bufferArray[nameAsInt] = Buffer.readChannel(s,path,channels: [0]);
	});

	~bufferArray[049];
	//~bufferArray[49];

	~bpm = TempoClock.new(60/60).permanent_(true);




	SynthDef("grain-asr", {arg buffer, rate = 1, startPos = 0, gate = 1, att = 0.01, rel = 0.1, amp = 1, pan = 0, chan = 1;
		var env, snd;
		env = Env.asr(att, amp, rel).kr(gate: gate);

		snd = PlayBuf.ar(
			numChannels: 2,
			bufnum:  buffer,
			rate: rate * BufRateScale.kr(buffer),
			startPos: startPos * BufFrames.kr(buffer),
			loop: 0,
			doneAction: 2
		);

		snd = snd * env;

		snd = Mix.ar(snd);
		snd = Limiter.ar(snd);
		snd = Pan2.ar(snd, pan);
		Out.ar(0, snd);
		DetectSilence.ar(snd, doneAction: 2);
	}).add;

		SynthDef("grain-asr-single", {arg buffer, rate = 1, startPos = 0, gate = 1, att = 0.01, rel = 0.1, amp = 1, pan = 0, chan = 1;
		var env, snd;
		env = Env.asr(att, amp, rel).kr(gate: gate);

		snd = PlayBuf.ar(
			numChannels: 1,
			bufnum:  buffer,
			rate: rate * BufRateScale.kr(buffer),
			startPos: startPos * BufFrames.kr(buffer),
			loop: 0,
			doneAction: 2
		);

		snd = snd * env;

		snd = Mix.ar(snd);
		snd = Limiter.ar(snd);
		snd = Pan2.ar(snd, pan);
		Out.ar(0, snd);
		DetectSilence.ar(snd, doneAction: 2);
	}).add;

	SynthDef("train-asr", {arg buffer, rate = 1, startPos = 0, gate = 1, att = 0.01, rel = 0.1, amp = 1, pan = 0, chan = 1;
		var env, snd;
		env = Env.asr(0.5, amp, 60).kr(gate: gate);
		snd = PlayBuf.ar(
			numChannels: 2,
			bufnum:  buffer,
			rate: rate * BufRateScale.kr(buffer),
			startPos: startPos * BufFrames.kr(buffer),
			loop: 0,
		);
		snd = snd * env;

		snd = Mix.ar(snd);
		snd = Limiter.ar(snd);
		snd = Pan2.ar(snd, pan);
		Out.ar(0, snd);
		DetectSilence.ar(snd, doneAction: 2);
	}).add;


	SynthDef("my0rgan", { arg freq=440, amp=1, gate=1, pan=0, rel = 0.01;
		var snd, env, harmonics, amplitudes;
		harmonics = [ 1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 14, 16, 18, 20, 22, 24];
		amplitudes = [ -10, -10, -10, -20, -20, -48, -82, -55, -77, -70, -90, -78, -78, -80, -95, -90].dbamp; //.scramble;
		//amplitudes = [ SinOsc.ar(2).range(-120, -45), -33, -45, -36, SinOsc.ar(10).range(-120, -85), -48, -82, SinOsc.ar(30).range(-120, -45), -77, -70, -90, -78, SinOsc.ar(2).range(-120, -45), -80, -95, -90].dbamp;
		//SinOsc.ar(10).range(-120, -25)
		env = Env.asr(0.001, amp, rel).kr(gate: gate, doneAction: 2);
		snd = SinOsc.ar(
			freq: freq * harmonics,
			mul: amplitudes * 0.2
		);
		snd = Mix.ar(snd) * env;
		snd = Limiter.ar(snd);
		snd = Pan2.ar(snd, 1.0);
		Out.ar(0, snd);
	}).add;

	SynthDef(\pulsey, { arg freq, amp, gate=1;
		var snd, env;


		env = Env.adsr(
			attackTime: 0.05,
			decayTime: 0.4,
			releaseTime: 0.4,
			sustainLevel: 1.0//SinOsc.ar(10).range(0.2,0.8)
		).kr(gate: gate, doneAction: 2);


		snd = SinOsc.ar(freq: freq * LFNoise2.kr([4, 5, 7]).range(0.5, 1.5).round(0.5), mul: env);
		// snd = Pulse.ar(freq: freq * LFNoise2.kr([4, 5, 7]).range(0.988, 1.011), mul: env);
		// kr(8) means generate 8 times per second
		snd = LPF.ar(in: snd, freq: SinOsc.ar(SinOsc.ar(1/5).range(20, 100)).range(1000,5000));

		snd = Splay.ar(snd) * 0.1;

		snd = Limiter.ar(snd); // limites the amplitudes of the sound
		Out.ar(0, snd); // Send the sound out to the speakers
		DetectSilence.ar(snd, doneAction: 2);

	}).add;

});

"TRAIN SYNTH DEFS LOADED".postln;