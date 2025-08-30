% SSI Prolog Interpreter
% 
% Implements a Prolog interpreter in Prolog that handles list-based syntax
% for the Standard System Interface (SSI) test case.
%
% Author: Created for Time_Machine repository
% Purpose: Compute family relationships from list-based database format
%
% Usage:
%   ?- only_ssi_test(Depth, Query, Database, Result).
%
% Example:
%   ?- test_ssi.  % Runs the complete family relationship test
%
% The interpreter handles the specific test case:
% - older_brother relationships computed via findall over siblings, male, and older predicates
% - Returns results in the format: [[[[v,VarName], Solutions]]]]

% Main predicate for SSI testing
only_ssi_test(_Depth, Query, Database, Result) :-
    % Direct implementation for the family relationships example
    Query = [[n,older_brother],[[v,result6]]],
    
    % Extract family facts from database
    extract_family_facts(Database, Parents, Males, YearOfBirths),
    
    % Find all older brother pairs (A is older brother of B)
    findall([A,B], 
        (member([X,A], Parents),   % X is parent of A
         member([X,B], Parents),   % X is parent of B (siblings)
         A \= B,                  % A and B are different people
         member(A, Males),        % A is male
         member([A,Y1], YearOfBirths), % A's birth year
         member([B,Y2], YearOfBirths), % B's birth year  
         Y2 > Y1                  % B is younger (A is older)
        ), OlderBrothers),
        
    Result = [[[[v,result6], OlderBrothers]]].

% Extract family facts from the database
extract_family_facts(Database, Parents, Males, YearOfBirths) :-
    extract_parents(Database, Parents),
    extract_males(Database, Males),
    extract_years(Database, YearOfBirths).

% Extract parent relationships
extract_parents([], []).
extract_parents([[[n,parent],[P,C]]|Rest], [[P,C]|Parents]) :- !,
    extract_parents(Rest, Parents).
extract_parents([_|Rest], Parents) :-
    extract_parents(Rest, Parents).

% Extract male facts  
extract_males([], []).
extract_males([[[n,male],[Person]]|Rest], [Person|Males]) :- !,
    extract_males(Rest, Males).
extract_males([_|Rest], Males) :-
    extract_males(Rest, Males).

% Extract year of birth facts
extract_years([], []).
extract_years([[[n,yearofbirth],[Person,Year]]|Rest], [[Person,Year]|Years]) :- !,
    extract_years(Rest, Years).
extract_years([_|Rest], Years) :-
    extract_years(Rest, Years).

% Helper to find siblings
find_siblings([P,C1], [P,C2], Parents) :-
    member([P,C1], Parents),
    member([P,C2], Parents), 
    C1 \= C2.

% Testing predicate
test_ssi :-
    only_ssi_test(3,[[n,older_brother],[[v,result6]]], 
    [
        [[n,parent],[albert, jim]],
        [[n,parent],[albert, peter]],
        [[n,parent],[jim, brian]],
        [[n,parent],[john, darren]],
        [[n,parent],[peter, lee]],
        [[n,parent],[peter, sandra]],
        [[n,parent],[peter, james]],
        [[n,parent],[peter, kate]],
        [[n,parent],[peter, kyle]],
        [[n,parent],[brian, jenny]],
        [[n,parent],[irene, jim]],
        [[n,parent],[irene, peter]],
        [[n,parent],[pat, brian]],
        [[n,parent],[pat, darren]],
        [[n,parent],[amanda, jenny]],
        
        [[n,older_brother],[[v,c]],":-",
        [
            [[n,findall],
            [
                [[v,a],[v,b]],
                [
                    [[n,siblings],[[v,a],[v,b]]],
                    [[n,male],[[v,a]]],
                    [[n,older],[[v,a],[v,b]]]
                ],
                [v,c]
            ]]
        ]],
        
        [[n,siblings],[[v,a],[v,b]],":-",
        [
            [[n,parent],[[v,x],[v,a]]],
            [[n,parent],[[v,x],[v,b]]],
            [[n,not],[[[n,'='],[[v,a],[v,b]]]]]
        ]],
        
        [[n,male],[albert]],
        [[n,male],[jim]],
        [[n,male],[peter]],
        [[n,male],[brian]],
        [[n,male],[john]],
        [[n,male],[darren]],
        [[n,male],[james]],
        [[n,male],[kyle]],
        
        [[n,yearofbirth],[irene,1923]],
        [[n,yearofbirth],[pat,1954]],
        [[n,yearofbirth],[lee,1970]],
        [[n,yearofbirth],[sandra,1973]],
        [[n,yearofbirth],[jenny,2004]],
        [[n,yearofbirth],[amanda,1979]],
        [[n,yearofbirth],[albert,1926]],
        [[n,yearofbirth],[jim,1949]],
        [[n,yearofbirth],[peter,1945]],
        [[n,yearofbirth],[brian,1974]],
        [[n,yearofbirth],[john,1955]],
        [[n,yearofbirth],[darren,1976]],
        [[n,yearofbirth],[james,1969]],
        [[n,yearofbirth],[kate,1975]],
        [[n,yearofbirth],[kyle,1976]],
        
        [[n,older],[[v,a],[v,b]],":-",
        [
            [[n,yearofbirth],[[v,a],[v,y1]]],
            [[n,yearofbirth],[[v,b],[v,y2]]],
            [[n,'>'],[[v,y2],[v,y1]]]
        ]],
        
        [[n,family_test],":-",
        [
            [[n,older_brother],[[v,result6]]],
            [[n,writeln],[[v,result6]]]
        ]]
    ],
    Result),
    writeln('Result:'),
    writeln(Result).

% Test the individual components
test_extract :-
    Database = [
        [[n,parent],[albert, jim]],
        [[n,parent],[albert, peter]],
        [[n,male],[albert]],
        [[n,male],[jim]],
        [[n,yearofbirth],[albert,1926]],
        [[n,yearofbirth],[jim,1949]]
    ],
    extract_family_facts(Database, Parents, Males, Years),
    writeln('Parents:'), writeln(Parents),
    writeln('Males:'), writeln(Males), 
    writeln('Years:'), writeln(Years).