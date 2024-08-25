:-include('../Time_Machine/analogy_generator_n.pl').
:- include('../../GitHub/listprologinterpreter/listprolog.pl').

t2b_br_adder(N) :-

	working_directory(WD,WD),
	%working_directory(_,'../../private/'),	
	open_file_s("../Time_Machine/analogy_sentence_n.txt",[D2,M2,Y2,n=SN2]),
	
	((D1=D2,M1=M2,Y1=Y2)->(%SN3=SN2,
	SN4 is SN2+N);
	(SN4 = 0%,SN3=SN4
	)),
	save_file_s("../Time_Machine/analogy_sentence_n.txt",[D1,M1,Y1,n=SN4]),
		working_directory(_,WD)	

	%foldr(string_concat,["Generator ",AGN,"'s sentence ",SN3," on ",D1,".",M1,".",Y1," is: "],_S_text),
	
	%string_concat(S_text,A1,A10),
	%working_directory(_,WD)
	.
