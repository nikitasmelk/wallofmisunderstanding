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
	 32.wait;
	~beat1.reset.play(~bpm);
	 //"beat2".postln;
	4.wait;
	~beat5.reset.play(~bpm);
	4.wait;
	~beat8.reset.play(~bpm);

	~beat2.reset.play(~bpm);
	8.wait;
	~beat4.reset.play(~bpm);
	~rhytmic1.reset.play(~bpm);
	~beat5.stop;

	4.wait;
	~rhytmic1_extra.reset.play(~bpm);
	//
	12.wait;
	~rhytmic2.reset.play(~bpm);

	12.wait;
	~rhytmic3.reset.play(~bpm);
	~beat8.stop;
	~rhytmic2.stop;

	4.wait;
	~rhytmic2.reset.play(~bpm);
	~rhytmic3.stop;
	~rhytmic1_extra.stop;

	2.wait;
	~ambience_finale.reset.play(~bpm);

	2.wait;
	~beat4.stop;
	~ambience_finale.stop;

	8.wait;
	~underSynth1.reset.play(~bpm);
	~beat1.stop;
	~beat5.reset.play(~bpm);

	8.wait;
	~beat7.reset.play(~bpm);

	8.wait;
	~underSynth2.reset.play(~bpm);
	~beat2.stop;

	8.wait;
	~underSynth2.stop;
	~rhytmic1.stop;

	16.wait;
	~rhytmic1.reset.play(~bpm);
	~beat1.reset.play(~bpm);
	~beat7.stop;






	8.wait;

		"TEA".postln;
	~rhytmic3.reset.play(~bpm);
	~tea.reset.play(~bpm);
	~beat8.reset.play(~bpm);



	16.wait;
	~rhytmic1.reset.play(~bpm);

	16.wait;
	~rhytmic2.reset.play(~bpm);
	~rhytmic1.stop;
	~underSynth1.reset.play(~bpm);
	~beat4.reset.play(~bpm);
	~rhytmic1_extra.reset.play(~bpm);

	16.wait;
	~rhytmic1.reset.play(~bpm);
	~underSynth2.reset.play(~bpm);
	~beat3.reset.play(~bpm);
	~train_start.reset.play(~bpm);
	~rhytmic4.reset.play(~bpm);
	~ambience_finale.reset.play(~bpm);
	~beat6.reset.play(~bpm);


	8.wait;
	~beat1.reset.play(~bpm);
	~ambience_start.reset.play(~bpm);
	~rhytmic1.reset.play(~bpm);
	~beat_finale.reset.play(~bpm);
	~beat5.reset.play(~bpm);

	3.wait;

	1.wait;
	"DROP OFF IN 3".postln;
	1.wait;
	"DROP OFF IN 2".postln;
	1.wait;
	"DROP OFF IN 1".postln;






	    "DROP OFF".postln;
	~rhytmic1.stop;
	~rhytmic2.stop;
	~rhytmic3.stop;
	~rhytmic4.stop;
	~rhytmic1_extra.stop;

	~underSynth2.stop;
	~underSynth1.stop;

	~tea.stop;
	~train_start.stop;

	~beat.stop;
	~beat2.stop;
	~beat1.stop;
	~beat3.stop;
	~beat4.stop;
	~beat5.stop;
	~beat6.stop;
	~beat7.stop;
	~beat8.stop;
	~beat_finale.stop;

	~ambience_start.stop;
	~ambience_finale.stop;
	~train_start.stop;
	//Server.killAll;

	s.freeAll;

	20.wait;
	"siren".postln;
	~airSiren.reset.play(~bpm);
	// SIRENS
	20.wait;
	~airSiren.stop;






}.fork(~bpm);
)