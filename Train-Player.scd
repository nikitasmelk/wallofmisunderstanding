
// Cmd + Shift + L

"/Users/nikitasmelk/Desktop/RECITAL/Train-SynthDefs.scd".load;
"/Users/nikitasmelk/Desktop/RECITAL/Train-MIDI.scd".load;





// FORK
(
{

//START
~train_start.reset.play(~bpm);

6.wait;
"ambience".postln;
~ambience_start.reset.play(~bpm);


//ADD RHYTHMIC
20.wait;
"beat2".postln;
~beat2.reset.play(~bpm);

18.wait;

"rhytmic1".postln;
~rhytmic1.reset.play(~bpm);
~beat1.reset.play(~bpm);
~ambience_start.stop;


28.wait;


// ADD UNDERLINE SYNTH
"undersynth1".postln;
~underSynth1.reset.play(~bpm);
~beat2.stop;

56.wait;
~tea.reset.play(~bpm);

16.wait;
//~underSynth2.reset.play(~bpm);
~beat1.stop;

//
//TEA & CHANGE DRUMS
~underSynth2.reset.play(~bpm);
~tea.reset.play(~bpm);
~train_start.reset.play(~bpm);
~rhytmic2.reset.play(~bpm);
~rhytmic1.stop;
36.wait;




1.wait;
	"3".postln;
1.wait;
	"2".postln;
1.wait;
	"1".postln;
// DROP OFF
"DROP OFF".postln;
~rhytmic2.stop;
~rhytmic1.stop;
~underSynth2.stop;
~underSynth1.stop;
~rhytmic2.stop;
~tea.stop;
~train_start.stop;
~beat2.stop;
~beat1.stop;
~rhytmic2.stop;
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



