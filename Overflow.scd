//Line6 Loop Pedal Emulation
//(condensed into one SynthDef)
//FEEDBACK WARNING! USE HEADPHONES!
ServerOptions.inDevices;

Server.default.options.device = "Aggregate Device";
Server.default.options.inDevice_("Built-in Microphone");
Server.default.options.outDevice_("Built-in Output");


(
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
		mic = SoundIn.ar(\in.ir(0)) * \inGain.kr(3);
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
});

)

//initial start record
~looper.set(\trig, 1, \run, 1, \reclev, 1, \prelev, 1, \xfade, 0.02, \inGain, 3);

//stop recording/overdubbing, begin/continue looping
~looper.set(\run, 0, \reclev, 0, \prelev, 1);

//start overdubbing (slight attenuation on existing content to prevent buildup)
~looper.set(\run, 0, \reclev, 1,\prelev, -1.dbamp);

//gradually fade loop content on each loop, without recording new audio
~looper.set(\run, 0, \reclev, 0, \prelev, -3.dbamp);

//reset, clear buffer, and immediately begin recording again
~b.zero; ~looper.set(\trig, 1, \run, 1, \reclev, 1, \prelev, 1, \xfade, 0.02);

//reset, clear buffer, but do not begin recording again
~b.zero; ~looper.set(\trig, 1, \run, 0, \reclev, 0, \prelev, 0, \xfade, 0.02);

//fade loop signal out of/into main mix
~looper.set(\loopAmp, 0, \xfade, 3);
~looper.set(\loopAmp, 1, \xfade, 3);











// RUNNING MIDI
MIDIClient.init;

MIDIIn.connectAll;

(
~notes = Array.newClear(128);
~bend = 8192;
~bpm = TempoClock.new(60/60).permanent_(true);

//~arrayOfSynths = [\tone, \tone_new, \spacey, \sampleSynth, \pulsey];
//~selectedSynth = ~arrayOfSynths.choose;
~selectedSynth = "rainyOrgan";

~bufferArray = Array.newClear(128);

//~bufferArray[0] =21;

//~testbuf = Buffer.read(s, "/Users/nikitasmelk/Desktop/SuperCollider/midi_loop/samples/Cassette808_Samples/Cassette808_BD01.wav");

//loading samples folder
//~samples =
)

// LOADING SAMPLES

(
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
			~looper.set(\trig, 1, \run, 1, \reclev, 1, \prelev, 1, \xfade, 0.02);
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
				\amp, 0.25,
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
				\amp, Pwhite(0.1, 0.5, inf) * 0.5,
				\pan, 1.0,
				\legato, 3,
			).play;
		}
		{cc_num == 17} {

			~beat1.stop;
			~beat2.stop;
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



//MIDI SYNTHDEFS
(
SynthDef("rainyOrgan", { arg freq=440, amp=1, gate=1, pan=0, att = 2.0, rel = 3.0;
    var snd, snd2, env, harmonics, amplitudes;
	harmonics = [ 1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 14, 16, 18, 20, 22, 24];
	amplitudes = [ -25, -33, -45, -36, -60, -48, -82, -55, -77, -70, -90, -78, -78, -80, -95, -90].dbamp;
	//amplitudes = [ SinOsc.ar(0.1).range(-120, -25), -33, -45, -36, SinOsc.ar(40).range(-120, -85), -48, -82, SinOsc.ar(0.3).range(-120, -25), -77, -70, -90, -78, SinOsc.ar(0.5).range(-120, -25), -80, -95, -90].dbamp;
	//SinOsc.ar(10).range(-120, -25)
	env = Env.asr(att, amp, rel).kr(gate: gate, doneAction: 2);
	snd = Saw.ar(
		freq: freq * harmonics,
		mul: amplitudes// XLine.kr(1.0, 0.0, 10.0)
	);

	snd2 = SinOsc.ar(
		freq: freq * harmonics,
		mul: amplitudes// XLine.kr(1.0, 0.0, 10.0)
	);

	snd2 = LPF.ar(in: snd2, freq: SinOsc.ar(SinOsc.ar(1/5).range(1/2, 10)).range(1000,5000));

	snd = snd * 0.5 + snd2 * 3;

	snd = Mix.ar(snd) * env;
	snd = Pan2.ar(snd, pan);
	Out.ar(0, snd);

	DetectSilence.ar(snd, 0.001, 0.2, doneAction: 2);

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



)



SCLOrkSynths.gui;

//{Out.ar(1, SinOsc.ar * 0.1)}.play;
