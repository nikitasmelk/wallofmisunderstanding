// YOU MIGHT NEED THAT


Quarks.install("Dirt-Samples");

Quarks.openFolder;

SCLOrkSamples.clear;

SCLOrkSamples.gui;



// LOAD SCLORK SAMPLES

Buffer.freeAll;

(

o = Server.default.options;
o.numBuffers = 2048;

)

(
// all the samples can be referenced through d.bird1 or so
d = SCLOrkSamples.loadFolder("/Users/nikitasmelk/Library/Application Support/SuperCollider/downloaded-quarks/Dirt-Samples/");


)


(
    // Loading your samples
    ~ru_samples = [
        Buffer.read(s, "/Users/nikitasmelk/Desktop/music/samples/drop-rvrb.wav"),
        Buffer.read(s, "/Users/nikitasmelk/Desktop/music/samples/drop-quiet.wav"),
        Buffer.read(s, "/Users/nikitasmelk/Desktop/music/samples/drop-mid.wav")
    ];

~metro = Buffer.readChannel(s, "/Users/nikitasmelk/Desktop/music/SuperCollider/samples/ru_samples/Московское метро Динамо.wav",channels: [0]);

~industrial = Buffer.readChannel(s, "/Users/nikitasmelk/Music/SuperCollider Recordings/crazy_industrial_sample.wav",channels: [0]);




// dursfrom handler

~dursFrom = {|array, dur=1|
			var size = array.size;
			var subdiv = dur / size;
			var result = array.collect({ |item|
				if(item.isArray, {
					~dursFrom.value(item, subdiv)
				}, {
					subdiv
				});
			});
			result.flat;
		};


// Setting the tempo
~tempo = TempoClock(120/60);
~tempo.tempo = 120/60;




SynthDef("grain-asr", {arg buffer, rate = 1, startPos = 0, gate = 1, att = 0.01, rel = 0.1, amp = 1, pan = 0;
    var env, snd;
	env = Env.asr(att, amp, rel).kr(gate: gate);
    snd = PlayBuf.ar(
        numChannels: 1,
        bufnum:  buffer,
        rate: rate * BufRateScale.kr(buffer),
        startPos: startPos * BufFrames.kr(buffer),
		loop: 0,
		doneAction: 2 // Free the synth when done
    );

    snd = snd * env;

	snd = FreeVerb.ar(snd, 0.1, 0.5, 0.5);

	snd = Mix.ar(snd);
	snd = Limiter.ar(snd);
	snd = Pan2.ar(snd, pan);
    Out.ar(0, snd);
    DetectSilence.ar(snd, doneAction: 2);
}).add;

)








d.choose;




(
var samples2;
//samples2 = [~buffers[0]!2, ~buffers[1]!2, ~buffers[2]];
//samples2 = [~bufferArray[59]!3, ~bufferArray[65]!4, ~bufferArray[59]!2, ~bufferArray[64], ~bufferArray[59]];
//samples2 = [~bufferArray[60], [ ~bufferArray[59], ~bufferArray[59] ], ~bufferArray[59], ~bufferArray[59]];
//samples2 = [~bufferArray[60], ~bufferArray[59]!3, ~bufferArray[59], ~bufferArray[59]];
//samples2 = [~bufferArray[60], [~bufferArray[59],~bufferArray[59],~bufferArray[59]], ~bufferArray[59]!4, ~bufferArray[59]];

samples2 = [d.birds9!20, d.birds8!5, d.birds7!5, d.stab0!2, d.toys1!4];
samples2 = [d.birds1, d.birds2, d.birds3, d.birds4, d.birds5!2, d.birds8, d.birds7];
//samples2 = [d.birds3, d.birds2, d.birds5!3];

samples2 = [d.bd0, d.techno0, d.bd0, d.techno1, d.cp0, d.drum2, d.techno1, d.drum2];
//samples2 = [d.house5, d.cp1, d.drum1, d.east2];

 //samples2 = [d.glitch20!4, d.e7!2, d.bass1, d.can7];
samples2 = [d.amencutup0, [d.drum2, d.drum2], d.drum0!2, d.drum1, d.hh3, d.techno1, d.amencutup13, d.techno1];

//samples2 = [d[1]];
samples2 = [
	[~ru_sample, ~ru_sample], [[~ru_sample], [\r, ~ru_sample]],
	[ [~ru_sample, ~ru_sample], [~ru_sample]],[[~ru_sample], [\r, ~ru_sample]]
];

samples2 = [
	[d.choose, d.choose], [[d.choose], [\r, d.choose]],
	[ [d.choose, d.choose], [d.choose]],[[d.choose], [\r, d.choose]]
];

samples2 = [
	[[~industrial, ~industrial], [~industrial, ~industrial]], [[~industrial], [\r, ~industrial]],
	[ [~industrial, ~industrial], [~industrial]],[[~industrial], [\r, ~industrial]]
];

samples2 = [
	[d.choose, d.choose], [[d.choose], [\r, d.choose]],
	[ [d.choose, d.choose], [d.choose]],[[d.choose], [\r, d.choose]]
];

//samples2 = [d.choose, d.choose, d.choose, [d.choose, d.choose]];

//samples2 = [~industrial, ~industrial, [~industrial, ~industrial], [\r, ~industrial]];




// samples = [\techno2, \bd0, \cp0, \cp1];
// samples = [\bubble3!2, \house3!rrand(1, 3), \house2!2, \cp0];
// samples = [\house1, \house2, \cp0, \a808ht4];
//samples = [~bufferArray[48]!5, ~bufferArray[48]!20, [~bufferArray[59], ~bufferArray[61], ~bufferArray[61]]];
// samples = [\bass10, \e7!5, \east2!3, \dork22]; // \r is a rest
// samples = [\control0, \gab7, Prand([\east2, \coins0])!2, \dork22]; // \r is a rest
// samples = [\glitch23!3, \e7!5, \east2!3, \ifdrums0!3]; // \r is a rest
// samples = [\glitch23!2, \birds4, \can6!2, \ifdrums0!2]; //BIRD
 //samples2 = [d.glitch20, d.e7!2, d.bass1, d.can7]; // NICE
// samples = [\sid1!2, \sid7, \sid9!2, \sf1!2];
// samples = [\amencutup0, [\drum2, \drum2], \drum0!2, \drum1, \hh3, \techno1, \amencutup13, \techno1];
// samples = [\house5!2, \house2, Prand([\bass112, \sn1, \sn2]), \db3];
// samples = [\house5, \cp1, \drum1, \sn1];
//samples2 = [d.house5, d.cp1, d.drum1, d.east2];

Ndef(\b1).quant = 0;
Ndef(\b1,

	//s.prepareForRecord;
	//s.record(duration: 8);

	Pbind(
		\instrument, "grain-asr",
		//\type, \dirt,
		//\sampleName, Pseq(samples.flat, inf),
		//\midinote, Pwhite(60, 90, inf),
		\startPos, Pseq([0.45, 0.32, 0.20, 0.32, 0.76,
			0.20, 0.45, 0.04, 0.32, 0.5, 0.31],inf),
		\buffer, Pseq(samples2.flat, inf) ,
		\dur, Pseq(~dursFrom.(samples2), inf).trace,
		\stretch, 4,
		\amp, Pseq([1.0, 1.0, 1.0, 0.1, 1.0,
			1.0, 1.0, 1.0, 1.0, 1.0, 1.0],inf), //Pwhite(0.6, 1),
		\rate, Pseq([5.0, 0.5, -0.2, 0.5, 1.0,
			0.2, 1.0, 1.0, 3.0, 1.0, 1.0] * 0.25,inf), //Pwhite(1, 1.01) * Prand([1, 1, 1, 1, 1, -1], inf)
		\pan, Pseq([-1, 1], inf),
	)
).play(~tempo);

);

Ndef(\b1).release(6);

(
var samples;
//samples2 = [~buffers[0]!2, ~buffers[1]!2, ~buffers[2]];
//samples2 = [~bufferArray[59]!3, ~bufferArray[65]!4, ~bufferArray[59]!2, ~bufferArray[64], ~bufferArray[59]];
//samples2 = [~bufferArray[60], [ ~bufferArray[59], ~bufferArray[59] ], ~bufferArray[59], ~bufferArray[59]];
//samples2 = [~bufferArray[60], ~bufferArray[59]!3, ~bufferArray[59], ~bufferArray[59]];
//samples2 = [~bufferArray[60], [~bufferArray[59],~bufferArray[59],~bufferArray[59]], ~bufferArray[59]!4, ~bufferArray[59]];

samples = [d.birds9!20, d.birds8!5, d.birds7!5, d.stab0!2, d.toys1!4];
samples = [d.birds1, d.birds2, d.birds3, d.birds4, d.birds5!2, d.birds8, d.birds7];
//samples2 = [d.birds3, d.birds2, d.birds5!3];

//samples = [d.bd0, d.techno0, d.bd0, d.techno1, d.cp0, d.drum2, d.techno1, d.drum2];
//samples = [d.house5, d.cp1, d.drum1, d.east2];

 //samples2 = [d.glitch20!4, d.e7!2, d.bass1, d.can7];
samples = [d.amencutup0, [d.drum2, d.drum2], d.drum0!2, d.drum1, d.hh3, d.techno1, d.amencutup13, d.techno1];

//samples =  [d.amencutup0, [d.drum2, d.drum2]];

//samples2 = [d[1]];




// samples = [\techno2, \bd0, \cp0, \cp1];
// samples = [\bubble3!2, \house3!rrand(1, 3), \house2!2, \cp0];
// samples = [\house1, \house2, \cp0, \a808ht4];
//samples = [~bufferArray[48]!5, ~bufferArray[48]!20, [~bufferArray[59], ~bufferArray[61], ~bufferArray[61]]];
// samples = [\bass10, \e7!5, \east2!3, \dork22]; // \r is a rest
// samples = [\control0, \gab7, Prand([\east2, \coins0])!2, \dork22]; // \r is a rest
// samples = [\glitch23!3, \e7!5, \east2!3, \ifdrums0!3]; // \r is a rest
// samples = [\glitch23!2, \birds4, \can6!2, \ifdrums0!2]; //BIRD
 //samples2 = [d.glitch20, d.e7!2, d.bass1, d.can7]; // NICE
// samples = [\sid1!2, \sid7, \sid9!2, \sf1!2];
// samples = [\amencutup0, [\drum2, \drum2], \drum0!2, \drum1, \hh3, \techno1, \amencutup13, \techno1];
// samples = [\house5!2, \house2, Prand([\bass112, \sn1, \sn2]), \db3];
// samples = [\house5, \cp1, \drum1, \sn1];
//samples2 = [d.house5, d.cp1, d.drum1, d.east2];



Ndef(\b2).quant = 0;
Ndef(\b2,

	//s.prepareForRecord;
	//s.record(duration: 8);

	Pbind(
		\instrument, "grain-asr",
		//\type, \dirt,
		//\sampleName, Pseq(samples.flat, inf),
		//\midinote, Pwhite(60, 90, inf),
		\buffer, Pseq(samples.flat, inf) ,
		\dur, Pseq(~dursFrom.(samples), inf).trace,
		\stretch, 4,
		\amp, Pseq([2.0, 1.0, 1.0, 1.0] * 3.0, inf), //Pwhite(0.6, 1),
		\pan, Prand([-1.0, 1.0], inf),
		\rate, Pstutter(4, Pseq([1, 2, 1.5, 0.5], inf)), //Pwhite(1, 1.01) * Prand([1, 1, 1, 1, 1, -1], inf)
	)
).play();

);

p = Ndef(\clock).proxyspace.clock = TempoClock(90/60).permanent_(true);
p.quant = 1.0;
p.clock.tempo = 90/60;

(
~tempo = TempoClock(90/60);
)