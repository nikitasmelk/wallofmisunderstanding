
~train_start = Pbind(
    \instrument, "grain-asr-single",
	\dur, Pseq([1], 1),
	\buffer, ~train,
	\startPos, 0.01,
	\loop, 0,
    \amp, 1.5,
    \legato, 5.0,
	\att, 10.0,
	\rel, 100.0,
	\pan, -1,
).play(~bpm).stop;


~ambience_start = Pbind(
    \instrument, "grain-asr",
	\dur,  Pseq([~talking_ambience.duration], 1),
	\buffer, ~talking_ambience,
	\startPos, 0.01,
	\loop, 0,
    \amp, 0.9,
    \legato, 1.0,
	\att, 10.0,
	\rel, 10.0,
	\pan,1,
).play(~bpm).stop;


~tea = Pbind(
    \instrument, "grain-asr-single",
	\dur, Pn(~tea_sample.duration, 1),
	\buffer, ~tea_sample,
	\startPos, 0.0,
	\loop, 0,
    \amp, 0.4,
    \legato, 1.0,
	\att, 10.0,
	\rel, 0.01,
).play(~bpm).stop;

~airSiren = Pbind(
    \instrument, "grain-asr",
	\dur, ~airSiren_sample.duration,
	\buffer, ~airSiren_sample,
	\startPos, 0.0,
	\loop, 0,
	\amp, Pseq([0.2], inf),
    \legato, 5.0,
	\att, 10.0,
	\rel, 10.0,
).play(~bpm).stop;



~beat1 = Pbind(
    \instrument, "grain-asr-single",
	\dur, Pseq([1,1,1, 1/3,1/4,1/5,1/6,1,1,2,1/10,1/10,1/10]*2, 90),
	\buffer, ~train,
	\startPos, Pwhite(0.1, 0.05,inf),
	\rate, Prand([1.0,2.0,1.0,1.0,2.0,1.0] * 1.5,inf),
	\loop, 0,
    \amp, 0.4,
    \legato, 1.0,
	\pan, Prand([1.0, 0.5, 0.6,0.7, 0.8, 0.9],inf),
).play(~bpm).stop;

~beat_finale = Pbind(
    \instrument, "grain-asr-single",
	\dur, Pseq([1,1,1, 1/3,1/4,1/5,1/6,1,1,2,1/10,1/10,1/10]*2, 90),
	\buffer, ~train,
	\startPos, Pwhite(0.1, 0.05,inf),
	\rate, Prand([1.0,2.0,1.0,1.0,2.0,1.0] * 1.5,inf),
	\loop, 0,
    \amp, 0.7,
    \legato, 1.0,
	\pan, Prand([1.0, 0.5, 0.6,0.7, 0.8, 0.9],inf),
).play(~bpm).stop;

~ambience_finale = Pbind(
    \instrument, "grain-asr",
	\dur,  Prand([0.5, 1.0, 3.0, 0.5, 0.8], inf),
	\buffer, ~talking_ambience,
	\startPos, 0.2,
	\loop, 0,
    \amp, 1.3,
    \legato, 5.0,
	\att, 10.0,
	\rel, 10.0,
	\rate, Prand([-2.0, -0.3, -0.4, 0.2, -1.0], inf),
	\pan,1,
).play(~bpm).stop;


~beat2 = Pbind(
    \instrument, "grain-asr-single",
	//\dur, Pseq([1,1,1, 1/3,1/4,1/5,1/6,1,1,2,1/10,1/10,1/10]*3, 60),
	\dur, Pseq([2,2,1,1,1,2,2,1,1,1,1,1]*0.25,inf),
	\att, 0.1,
	\buffer, ~train,
	\startPos, Pwhite(0.4, 0.8, inf),
	\rate, Prand([-1.0, -2.0]*0.4 ,inf),
	\loop, 0,
    \amp, 0.4,
	\rel, 0.2,
    \legato, 1.0,
	\pan, Prand([-1.0, -0.5, -0.6,-0.7, -0.8, -0.9],inf),
).play(~bpm).stop;

~beat3 = Pbind(
    \instrument, "grain-asr-single",
	//\dur, Pseq([1,1,1, 1/3,1/4,1/5,1/6,1,1,2,1/10,1/10,1/10]*3, 60),
	\dur, Pseq([2,2,1,1,1,2,2,1,1,1,1,1]*0.25,inf),
	\att, 0.1,
	\buffer, ~train,
	\startPos, Pwhite(0.4, 0.8, inf),
	\rate, Prand([4.0, 5.0]*20 ,inf),
	\loop, 0,
    \amp, 0.3,
	\rel, 0.2,
    \legato, 1.0,
	\pan, Prand([1.0, 0.9, 0.6],inf),
).play(~bpm).stop;

~beat4 = Pbind(
    \instrument, "grain-asr-single",
	//\dur, Pseq([1,1,1, 1/3,1/4,1/5,1/6,1,1,2,1/10,1/10,1/10]*3, 60),
	\dur, Pseq([2,2,1,1,1,2,2,1,1,1,1,1]*0.6,inf),
	\att, 0.1,
	\buffer, ~train,
	\startPos, Pwhite(0.4, 0.8, inf),
	\rate, Prand([-1.0, -2.0]*0.2 ,inf),
	\loop, 0,
    \amp, 1.7,
	\rel, 0.2,
    \legato, 1.0,
	\pan, Prand([-1.0, -0.5, -0.6,-0.7, -0.8, -0.9],inf),
).play(~bpm).stop;

~beat5 = Pbind(
    \instrument, "grain-asr-single",
	//\dur, Pseq([1,1,1, 1/3,1/4,1/5,1/6,1,1,2,1/10,1/10,1/10]*3, 60),
	\dur, Pseq([5,5,5,5]*1,inf),
	\att, 0.1,
	\buffer, ~train,
	\startPos, Pwhite(0.4, 0.8, inf),
	\rate, Prand([-1.0, -2.0]*0.5 ,inf),
	\loop, 0,
    \amp, 3.0,
	\rel, 0.2,
    \legato, 1.0,
	\pan, Prand([-1.0],inf),
).play(~bpm).stop;

~beat6 = Pbind(
    \instrument, "grain-asr-single",
	//\dur, Pseq([1,1,1, 1/3,1/4,1/5,1/6,1,1,2,1/10,1/10,1/10]*3, 60),
	\dur, Pseq([5,5,5,5]*1,inf),
	\att, 0.1,
	\buffer, ~train,
	\startPos, Pwhite(0.4, 0.8, inf),
	\rate, Prand([1.0, 2.0]*3 ,inf),
	\loop, 0,
    \amp, 3.0,
	\rel, 0.2,
    \legato, 1.0,
	\pan, Prand([11.0],inf),
).play(~bpm).stop;

~beat7 = Pbind(
    \instrument, "grain-asr-single",
	//\dur, Pseq([1,1,1, 1/3,1/4,1/5,1/6,1,1,2,1/10,1/10,1/10]*3, 60),
	\dur, Pseq([2,2,1,1,1,2,2,1,1,1,1,1]*3,inf),
	\att, 0.1,
	\buffer, ~train,
	\startPos, Pwhite(0.9, 0.92, inf),
	\rate, Prand([-1.0, -2.0]*0.1 ,inf),
	\loop, 0,
    \amp, 10.0,
	\rel, 0.2,
    \legato, 0.1,
	\pan, Prand([-1.0, 1.0],inf),
).play(~bpm).stop;


~beat8 = Pbind(
    \instrument, "grain-asr-single",
	//\dur, Pseq([1,1,1, 1/3,1/4,1/5,1/6,1,1,2,1/10,1/10,1/10]*3, 60),
	\dur, Pseq([1,1,3]*0.1,inf),
	\att, 0.1,
	\buffer, ~train,
	\startPos, Pwhite(0.1, 0.2, inf),
	\rate, Prand([1.0, 1.0]*0.1 ,inf),
	\loop, 0,
    \amp, 5.0,
	\rel, 0.2,
    \legato, 1.0,
	\pan, Prand([11.0],inf),
).play(~bpm).stop;



~rhytmic1 = Pbind(
    \instrument, "grain-asr-single",
	\dur, Pseq([2,2,1,1,1,2,2,1,1,1,1,1]*0.25,inf),
	\buffer, ~bufferArray[48],
	//\startPos, 0,
	\rate, Pwhite(0.8, 1.1, inf),//Prand([-1.0,-2.0,-3.0,-4.0,-5.0,-6.0]*0.05 ,inf),
	\loop, 0,
	\rel, Pwhite(0.01, 0.1, inf),
	\amp, Pseq([Pseries(0.21,0.01,40), Pseq([0.6], inf)] * 2.0, 1),
    \legato, 0.2,
	\att, 0.01,
	//\pan, Prand([-1.0, -0.5, -0.6,-0.7, -0.8, -0.9],inf),
).play(~bpm).stop;

~rhytmic1_extra = Pbind(
    \instrument, "grain-asr-single",
	\dur, Pseq([2,2,1,1,1,2,2,1,1,1,1,1]*0.25,inf),
	\buffer, ~bufferArray[57],
	//\startPos, 0,
	\rate, 0.6,//Prand([-1.0,-2.0,-3.0,-4.0,-5.0,-6.0]*0.05 ,inf),
	\loop, 0,
	\rel, Pwhite(0.01, 0.1, inf),
	\amp, Pwhite(0.1, 0.5, inf),
	\legato, Pwhite(0.01, 0.03, inf),
	\att, 0.01,
	//\pan, Prand([-1.0, -0.5, -0.6,-0.7, -0.8, -0.9],inf),
).play(~bpm).stop;


~rhytmic2 = Pbind(
    \instrument, "grain-asr-single",
	\dur, Pseq([1,1,2,2,2,1,1,2,2,2,2,2]*0.25,inf),
	//\dur, Pn(1, inf),
	\buffer, ~bufferArray[053],
	\startPos, 0.01,
	//\rate, Prand([-1.0,-2.0,-3.0,-4.0,-5.0,-6.0]*0.05 ,inf),
	\loop, 0,
	\amp, Pwhite(0.1, 0.61, inf),
    \legato, 1.0,
	\pan, Prand([-1.0, -0.5, -0.6,-0.7, -0.8, -0.9],inf),
).play(~bpm).stop;

~rhytmic3 = Pbind(
    \instrument, "grain-asr-single",
	\dur, Pseq([1,1,2,2,2,1,1,2,2,2,2,2, 20]*0.1,inf),
	//\buffer, ~bufferArray[057],
	\buffer, Prand(~bufferArray[49..53], inf),
	\startPos, 0.1,
	//\rate, Prand([-1.0,-2.0,-3.0,-4.0,-5.0,-6.0]*0.05 ,inf),
	\loop, 0,
	\amp, Pwhite(0.05, 0.13, inf) * 4,
    \legato, 1.0,
	\pan, Prand([-1.0, -0.5, -0.6,-0.7, -0.8, -0.9],inf),
).play(~bpm).stop;

~rhytmic4 = Pbind(
    \instrument, "grain-asr-single",
	\dur, Prand([2,2,1,1,1,2,2,1,1,1,1,1]*0.05,inf),
	\buffer, ~bufferArray[56],
	\startPos, 0.1,
	\rate, Pwhite(0.8, 1.1, inf) * 0.3,//Prand([-1.0,-2.0,-3.0,-4.0,-5.0,-6.0]*0.05 ,inf),
	\loop, 0,
	\rel, Pwhite(0.01, 0.1, inf),
	\amp, Pseq([Pseries(0.21,0.01,40), Pseq([0.6], inf)] * 4.0, 1),
    \legato, 0.7,
	\att, 0.2,
	//\pan, Prand([-1.0, -0.5, -0.6,-0.7, -0.8, -0.9],inf),
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
	\amp, Pwhite(0.5, 0.9, inf),
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
	\amp, Pwhite(0.3, 0.5, inf),
	\ctranspose, Prand([12,24,0,12],inf),
	\pan, 1,//Pseq([1,-1],inf),//Pwhite(-0.8, 0.8, inf),
).play(~bpm).stop;

MIDIClient.init;
MIDIIn.connectAll;

~selectedSynth = "pulsey";
~notes = Array.newClear(128);
~bend = 8192;

//~arrayOfSynths = [\pulsey, \sawReverb, \myOrgan];
//~bufferArray = Array.newClear(128);



MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn;
	[vel, nn].postln;
	//~bufferArray[nn].postln;
	~notes[nn] = Synth.new(

		~selectedSynth,
		[
			//\buf, ~bufferArray[nn],
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

	if(value > 0){
		//16 - 23 pads nums
		case
		{cc_num == 16} {"hello".postln;}
		{cc_num == 18} {
			"/Users/nikitasmelk/Desktop/RECITAL/Train-Fork.scd".load;
		}
		{cc_num == 19} {
			// VISUAL CONTROL

		}

	};

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



"TRAIN MIDI & PBINDS LOADED".postln;