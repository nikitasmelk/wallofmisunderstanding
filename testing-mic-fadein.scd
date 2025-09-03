


(
Ndef(\test, {
	var snd, env;

	env = Env.pairs([[0,0],[9,0],[10,1]]).kr;
	snd = SinOsc.ar(440);

	snd = snd * env;

	snd = Limiter.ar(snd);
}).play;
)