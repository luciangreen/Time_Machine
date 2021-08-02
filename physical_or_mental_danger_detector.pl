% lppm, .md file ***


:- use_module(library(date)).
%:- include('../Text-to-Breasonings/texttobr2qb').
:- include('../mindreader/mindreadtestshared').
%:-include('../listprologinterpreter/la_strings.pl'). %**** change path on server
%:-include('../listprologinterpreter/la_strings_string.pl'). %**** change path on server
%:-include('../listprologinterpreter/la_maths.pl'). %**** change path on server

physical_or_mental_danger_detector(_Minutes_to_check):-
	physical_or_mental_danger(0,Threats1),
	% no_death(0,Threats2), % medits for life
	writeln([Threats1,physical_or_mental_dangers]),
	
	((Threats1 > 0) -> writeln("Warning: Please don't travel in this time and place.");true).
	%,Threats2,no_death]).
	
physical_or_mental_danger(Threats1,Threats2):-
	%% "Given that we are interested in friendliness in primary school, secondary school and university, is there anything else?"
	trialy2_6("Yes",R1),
	trialy2_6("No",R2),
		R=[R1,R2/**,R3,R4,R5,R6,R7,R8,R9,R10**,R11,R12,R13,R14,R15,R16,R17,R18,R19,R20,R21,R22,R23,R24,R25,R26,R27**/
		],
	sort(R,RA),
	reverse(RA,RB),
	RB=[[_,Answer]|_Rest],
	
	(Answer="No"->Threats2=Threats1;(Threats3 is Threats1+1,physical_or_mental_danger(Threats3,Threats2))),!.
