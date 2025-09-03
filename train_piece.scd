//Server.killAll;

(
MIDIClient.init;

MIDIIn.connectAll;

~train = Buffer.read(s, "/Users/nikitasmelk/Desktop/RECITAL/Московское метро Динамо.wav");

~talking_ambience = Buffer.read(s, "/Users/nikitasmelk/Desktop/RECITAL/metro_ambience.mp3");

~airSiren_sample = Buffer.read(s, "/Users/nikitasmelk/Desktop/RECITAL/air-raid-kyiv.mp3");

~tea_sample = Buffer.read(s, "/Users/nikitasmelk/Desktop/RECITAL/Закипает чайник.wav");


//~bpm = TempoClock.new(56/60).permanent_(true);


~bufferArray = Array.newClear(128);


	"/Users/nikitasmelk/Desktop/RECITAL/Cassette808_Samples/*.wav".resolveRelative.pathMatch.do({ |path|
	var nameAsInt = path.keep(-7).keep(3).asInteger;
	//nameAsInt.postln;

	~bufferArray[nameAsInt] = Buffer.readChannel(s,path,channels: [0]);
});

~bufferArray[049];


SynthDef("grain-asr", {arg buffer, rate = 1, startPos = 0, gate = 1, att = 0.01, rel = 0.1, amp = 1, pan = 0, chan = 1;
    var env, snd;
	env = Env.asr(att, amp, rel).kr(gate: gate);
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


)

(
~train_start = Pbind(
    \instrument, "grain-asr",
	\dur, Pseq([1], 1),
	\buffer, ~train,
	\startPos, 0.01,
	\loop, 0,
    \amp, 1.0,
    \legato, 5.0,
	\att, 10.0,
	\rel, 100.0,
	\pan, -1,
).play(~bpm).stop;

~ambience_start = Pbind(
    \instrument, "grain-asr",
	\dur,  Pseq([~talking_ambience], 1),
	\buffer, ~talking_ambience,
	\startPos, 0.01,
	\loop, 0,
    \amp, 0.4,
    \legato, 5.0,
	\att, 10.0,
	\rel, 10.0,
	\pan,1,
).play(~bpm).stop;

~tea = Pbind(
    \instrument, "grain-asr",
	\dur, ~tea_sample.duration,
	\buffer, ~tea_sample,
	\startPos, 0.1,
	\loop, 0,
    \amp, 0.3,
    \legato, 5.0,
	\att, 10.0,
	\rel, 10.0,
).play(~bpm).stop;

~airSiren = Pbind(
    \instrument, "grain-asr",
	\dur, ~airSiren_sample.duration,
	\buffer, ~airSiren_sample,
	\startPos, 0.0,
	\loop, 0,
	\amp, Pseq([0.1], inf),
    \legato, 5.0,
	\att, 10.0,
	\rel, 10.0,
).play(~bpm).stop;



~beat1 = Pbind(
    \instrument, "grain-asr",
	\dur, Pseq([1,1,1, 1/3,1/4,1/5,1/6,1,1,2,1/10,1/10,1/10]*2, 90),
	\buffer, ~train,
	\startPos, Pwhite(0.0, 0.05,inf),
	\rate, Prand([1.0,2.0,1.0,1.0,2.0,1.0] * 0.8,inf),
	\loop, 0,
    \amp, 0.2,
    \legato, 1.0,
	\pan, Prand([1.0, 0.5, 0.6,0.7, 0.8, 0.9],inf),
).play(~bpm).stop;


~beat2 = Pbind(
    \instrument, "grain-asr",
	\dur, Pseq([1,1,1, 1/3,1/4,1/5,1/6,1,1,2,1/10,1/10,1/10]*3, 60),
	\buffer, ~train,
	\startPos, 1.0,
	\rate, Prand([-1.0,-2.0,-3.0,-4.0,-5.0,-6.0]*0.05 ,inf),
	\loop, 0,
    \amp, 0.1,
    \legato, 1.0,
	\pan, Prand([-1.0, -0.5, -0.6,-0.7, -0.8, -0.9],inf),
).play(~bpm).stop;

~rhytmic1 = Pbind(
    \instrument, "grain-asr",
	\dur, Pseq([2,2,1,1,1,2,2,1,1,1,1,1]*0.25,inf),
	\buffer, ~bufferArray[049],
	//\startPos, 0,
	\rate, 1.0,//Prand([-1.0,-2.0,-3.0,-4.0,-5.0,-6.0]*0.05 ,inf),
	\loop, 0,
	\amp, Pseq([Pseries(0.21,0.01,40), Pseq([0.6], inf)], 1),
    \legato, 1.0,
	//\pan, Prand([-1.0, -0.5, -0.6,-0.7, -0.8, -0.9],inf),
).play(~bpm).stop;


~rhytmic2 = Pbind(
    \instrument, "grain-asr",
	\dur, Pseq([1,1,2,2,2,1,1,2,2,2,2,2]*1.0,inf),
	\buffer, ~bufferArray[065],
	\startPos, 0.8,
	//\rate, Prand([-1.0,-2.0,-3.0,-4.0,-5.0,-6.0]*0.05 ,inf),
	\loop, 0,
	\amp, Pwhite(0.05, 0.13, inf),
    \legato, 1.0,
	\pan, Prand([-1.0, -0.5, -0.6,-0.7, -0.8, -0.9],inf),
).play(~bpm).stop;


~underSynth1 =  Pbind(
	\instrument, "my0rgan",
	//\freq, Pwhite(100.0, 500.0, inf),
		\midinote, Pseq([
		//57,
		//60,
		//50,
		//40,
		//random chords?
		[58, 62],
		[61,65],
	], inf),
	\dur, 4,
	//\legato, Pwhite(4.0, 8.0, inf),
	//\pan, -1,
	\amp, Pwhite(0.2, 0.5, inf),
	\ctranspose, -12,
	\rel, 1.0,
	\legato, 1.0,
	\pan, 0,//Pseq([1,-1],inf),//Pwhite(-0.8, 0.8, inf),
).play(~bpm).stop;

~underSynth2 = Pbind(
	\instrument, "my0rgan",
	//\freq, Pwhite(100.0, 500.0, inf),
		\midinote, Prand([
		58, 62, 61, 65
		//random chords?
	], inf),
	\dur, Pseq([Prand([0.5, 1, 0.25], 50),Prand([0.25, 0.5, 0.125], 50),Prand([0.125, 0.125/2, 0.125/3], 50)], 1),
	\legato, Pwhite(0.3, 0.6, inf),
	//\pan, -1,
	\amp, Pwhite(0.1, 0.2, inf),
	\ctranspose, Prand([12,24,0,12],inf),
	\pan, 1,//Pseq([1,-1],inf),//Pwhite(-0.8, 0.8, inf),
).play.stop;



~notes = Array.newClear(128);
~bend = 8192;
~bpm = TempoClock.new(60/60).permanent_(true);

//~arrayOfSynths = [\tone, \tone_new, \spacey, \sampleSynth, \synthbass, \pulsey, \sawReverb];
//~selectedSynth = ~arrayOfSynths.choose;
~selectedSynth = \pulsey;

//~arrayOfSynths = [\pulsey, \sawReverb, \myOrgan];

~bufferArray = Array.newClear(128);



MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn;
	[vel, nn].postln;
	~bufferArray[nn].postln;
	~notes[nn] = Synth.new(

		\pulsey,
		[
			\buf, ~bufferArray[nn],
			\freq, nn.midicps,
			\amp, vel.linexp(1,127,0.1,2.0) ,
			\gate, 1,
			\bend, ~bend.linlin(0,16383,-2,2),
	    ]);

		//\sampleSynth,[\bufnum, ~testbuf]);
});

MIDIdef.cc(\pads_control, {
	arg value, cc_num;
	[value, cc_num].postln;

	//16 - 23 pads nums
	case
	{cc_num == 16} {"hello".postln;}
	{cc_num == 17} {"hello2".postln;}
	{cc_num == 19} {
		//~selectedSynth = ~arrayOfSynths.choose;
		//~selectedSynth = ~arrayOfSynths[0];
		//~selectedSynth.postln;
	}

	//64 for sustain

},(16..23)
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


(
~bpm = TempoClock.new(60/60).permanent_(true);

{

//START
~train_start.reset.play(~bpm);

5.wait;
"ambience".postln;
~ambience_start.reset.play(~bpm);


//ADD RHYTHMIC
20.wait;
"beat2".postln;
~beat2.reset.play(~bpm);

10.wait;

"rhytmic1".postln;
~rhytmic1.reset.play(~bpm);
~beat1.reset.play(~bpm);


30.wait;


// ADD UNDERLINE SYNTH
"undersynth1".postln;
~underSynth1.reset.play(~bpm);
~beat2.stop;

20.wait;
//~underSynth2.reset.play(~bpm);
~beat1.stop;

//
//TEA & CHANGE DRUMS
~underSynth2.reset.play(~bpm);
~tea.reset.play(~bpm);
~rhytmic2.reset.play(~bpm);
~rhytmic1.stop;
40.wait;


// DROP OFF
"DROP OFF".postln;
~rhytmic2.stop;
~rhytmic1.stop;
~underSynth2.stop;
~rhytmic2.stop;
~tea.stop;
~train_start.stop;
~beat2.stop;
~beat1.stop;
~rhytmic2.stop;
//Server.killAll;

20.wait;
"siren".postln;
~airSiren.reset.play(~bpm)
// SIRENS




}.fork(~bpm);
)


