% time_machine.pl

% The war cry - we're with you!

:-include('../Text-to-Breasonings/text_to_breasonings.pl').
:-include('../Text-to-Breasonings/meditationnoreplace2.pl').
:-include('../listprologinterpreter/la_maths.pl').
:-include('physical_or_mental_danger_detector.pl').

time_machine :-
	concat_list(["Time Machine","\n\n","Warning: This software is to be used at your own risk.  Please read the Instructions for TextToBr to avoid medical problems before use.","\n\n","This time machine will transport you and named friends to a place and time and back before a specified time.  You may come back before the given time with the thought command, \"I want to time travel back to the same place in my own time line, the same amount of time relative to when I left\".,","\n\n","Please wear clothes appropriate for the time and determine whether it is a good time to travel, especially in the past and using predictions of the future."],Note1),writeln(Note1),
	concat_list(["Do you want to continue (y/n)?"],Note2),
	writeln(Note2),
	read_string(user_input,"\n\r","\n\r",_,Input1),

	(Input1="y"->
	(
		%repeat,
		concat_list(["How many people and animals are travelling, including you?"],Note3),
		writeln(Note3),
		read_string(user_input,"\n\r","\n\r",_,Input2),
		((number_string(Input2a,Input2),number(Input2a))->true;false),
		concat_list(["When do you want to travel to?"],Note4),
		writeln(Note4),
		read_string(user_input,"\n\r","\n\r",_,_Input3),
		concat_list(["Where do you want to travel to?"],Note5),
		writeln(Note5),
		read_string(user_input,"\n\r","\n\r",_,_Input4),
		%repeat,
		concat_list(["How many hours do you want to return after?"],Note6),
		writeln(Note6),
		read_string(user_input,"\n\r","\n\r",_,Input5),
		((number_string(Input5a,Input5),number(Input5a))->true;false),

	concat_list(["Do you want to travel now (y/n)?"],Note7),
	writeln(Note7),
	read_string(user_input,"\n\r","\n\r",_,Input6),
	(Input6="y"->
	(
		numbers(Input2a,1,[],Ns),
		
		retractall(meditators(_)),
		retractall(meditators2(_)),
		assertz(meditators(Ns)),
		assertz(meditators2([])),
		
		meditation, % meditation and medicine for each person
		
		findall(_,(member(_N,Ns),
		%trace,
		
		% 3 (A,B,B to B)* 64 (4*50 As of 250 br)=192
		texttobr2_1(192),% turn entity into a bot
		texttobr2_1(192),% everyone travels in a comfortable lead time machine with 1 cm thick walls for safety
		Quarter_minutes_away is Input5a*4,
		N3 is Quarter_minutes_away*192,
		texttobr2_1(N3),% provides support for a thought every 15 seconds
		Seconds_away is Input5a*60,
		N2 is Seconds_away*192,
		texttobr2_1(N2),% provide return lifeline each second - note everyone travels together
	
		texttobr2_1(192),% travel to time and place
		texttobr2_1(192),% travel back from time and place at end if anyone hasn't already
		texttobr2_1(192) % turn off lifeline and thoughts if return earlier
		),_)

	));(writeln("Execution aborted."),abort)
	);
	(writeln("Execution aborted."),abort)),!.

%texttobr2_1(N) :- texttobr2(N),!.
