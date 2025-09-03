(
{

	// 1 measure is 4 seconds or 4 beats
	// //START
	"start".postln;
	~train_start.reset.play(~bpm);
	~ambience_start.reset.play(~bpm);
	//
	//
	// //ADD RHYTHMIC
	 4*8.wait;
	~beat1.reset.play(~bpm);
	 //"beat2".postln;
	8.wait;
	 ~beat2.reset.play(~bpm);
	8.wait;
	~rhytmic1.reset.play(~bpm);
	//
	16.wait;
	~rhytmic2.reset.play(~bpm);

	12.wait;
	~rhytmic3.reset.play(~bpm);
	~rhytmic2.stop;

	4.wait;
	~rhytmic2.reset.play(~bpm);
	~rhytmic3.stop;

	12.wait;
	~underSynth1.reset.play(~bpm);
	~beat1.stop;

	16.wait;
	~underSynth2.reset.play(~bpm);
	~beat2.stop;

	8.wait;
	~underSynth2.stop;
	~rhytmic1.stop;

	16.wait;
	~rhytmic1.reset.play(~bpm);
	~beat1.reset.play(~bpm);






	8.wait;

		"TEA".postln;
	~rhytmic3.reset.play(~bpm);
	~tea.reset.play(~bpm);



	16.wait;
	~rhytmic1.reset.play(~bpm);

	16.wait;
	~rhytmic2.reset.play(~bpm);
	~rhytmic1.stop;
	~underSynth1.reset.play(~bpm);
	~beat4.reset.play(~bpm);

	16.wait;
	~rhytmic1.reset.play(~bpm);
	~underSynth2.reset.play(~bpm);
	~beat3.reset.play(~bpm);
	~train_start.reset.play(~bpm);

	8.wait;
	~beat1.reset.play(~bpm);
	~ambience_start.reset.play(~bpm);
	~rhytmic1.reset.play(~bpm);

	6.wait;






	    "DROP OFF".postln;
	~rhytmic1.stop;
	~rhytmic2.stop;
	~rhytmic3.stop;

	~underSynth2.stop;
	~underSynth1.stop;

	~tea.stop;
	~train_start.stop;

	~beat2.stop;
	~beat1.stop;
	~beat3.stop;
	~beat4.stop;

	~ambience_start.stop;
	//Server.killAll;

	s.freeAll;

	10.wait;
	"siren".postln;
	~airSiren.reset.play(~bpm);
	// SIRENS
	20.wait;
	~airSiren.stop;






}.fork(~bpm);
)