% needs t2b repository

:-include('../listprologinterpreter/listprolog.pl').

time_machine_prepare :-

K=["../Lucian-Academy/Time Travel/",
"../Lucian-Academy/Fundamentals of Pedagogy and Pedagogy Indicators/",
"../Lucian-Academy/Medicine/",
"../Lucian-Academy/Fundamentals of Meditation and Meditation Indicators/",
"../Lucian-Academy/Lecturer/",
"../Lucian-Academy/Delegate workloads, Lecturer, Recordings/",
"../Lucian-Academy/Mind Reading/"
],


findall(J,(member(K1,K),	directory_files(K1,F),
	delete_invisibles_etc(F,G),

findall([File_term,"\n"],(member(H,G),open_file_s(H,File_term)),J)),J3),

flatten(J3,J1),
foldr(string_concat,J1,"",J2),


N=1,M=u,texttobr2(N,u,J2,M,false,false,false,false,false,false).


N=1,M=u,texttobr(N,u,J2,M).

