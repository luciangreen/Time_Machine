% needs t2b repository

:-include('../listprologinterpreter/listprolog.pl').
:-include('../Text-to-Breasonings/text_to_breasonings.pl').

time_machine_prepare :-

K=["../Lucian-Academy/Books/Time Travel/",
"../Lucian-Academy/Books/Fundamentals of Pedagogy and Pedagogy Indicators/",
"../Lucian-Academy/Books/Medicine/",
"../Lucian-Academy/Books/Fundamentals of Meditation and Meditation Indicators/",
"../Lucian-Academy/Books/Lecturer/",
"../Lucian-Academy/Books/Delegate workloads, Lecturer, Recordings/",
"../Lucian-Academy/Books/Mind Reading/"
],


findall(J,(member(K1,K),	directory_files(K1,F),
	delete_invisibles_etc(F,G),

findall([File_term,"\n"],(member(H,G),string_concat(K1,H,H1),open_file_s(H1,File_term)),J)),J3),

flatten(J3,J1),
foldr(string_concat,J1,"",J2),


N=1,M=u,texttobr2(N,u,J2,M,false,false,false,false,false,false),


N=1,M=u,texttobr(N,u,J2,M).

