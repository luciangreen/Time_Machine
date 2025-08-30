% SSI Prolog Interpreter
% Implements a Prolog interpreter in Prolog for list-based syntax
% Specifically designed to handle only_ssi_test/3 predicate

% Main predicate for SSI testing
only_ssi_test(Depth, Query, Database, Result) :-
    % Convert list-based database to regular Prolog facts and rules
    convert_database(Database),
    
    % Execute the query
    Query = [[n, QueryPred], QueryArgs],
    call_ssi_predicate(QueryPred, QueryArgs, Solutions),
    
    % Format result according to expected structure
    QueryArgs = [[v, VarName]],
    Result = [[[[v, VarName], Solutions]]].

% Convert database items to regular Prolog predicates
convert_database([]).
convert_database([Item|Rest]) :-
    convert_item(Item),
    convert_database(Rest).

% Convert facts and rules
convert_item([[n, Predicate], Args]) :-
    % Convert fact - handle variables in arguments
    convert_args(Args, PrologArgs),
    Term =.. [Predicate|PrologArgs], 
    assertz(Term).

convert_item([[n, Head], HeadArgs, ":-", Body]) :-
    % Convert rule - create a clause with proper variable handling
    convert_args(HeadArgs, PrologHeadArgs),
    HeadTerm =.. [Head|PrologHeadArgs],
    convert_body_to_prolog(Body, PrologBody),
    assertz((HeadTerm :- PrologBody)).

% Convert arguments, handling variables
convert_args([], []).
convert_args([Arg|Rest], [PrologArg|PrologRest]) :-
    convert_arg(Arg, PrologArg),
    convert_args(Rest, PrologRest).

% Convert individual argument
convert_arg([v, VarName], Var) :-
    % Create a Prolog variable - we use a unique variable for each occurrence
    % This is a simplified approach - in a full interpreter we'd need variable scoping
    atom_concat('_', VarName, Var).

convert_arg(Atom, Atom) :-
    % Keep constants as is
    Atom \= [v, _].

% Convert body goals to Prolog
convert_body_to_prolog([], true).
convert_body_to_prolog([Goal], PrologGoal) :-
    convert_goal_to_prolog(Goal, PrologGoal).
convert_body_to_prolog([Goal|Goals], (PrologGoal, RestGoals)) :-
    Goals \= [],
    convert_goal_to_prolog(Goal, PrologGoal),
    convert_body_to_prolog(Goals, RestGoals).

% Convert individual goals
convert_goal_to_prolog([[n, findall], [Template, GoalList, [v, ResultVar]]], 
                       findall(PrologTemplate, GoalsPredicate, PrologResultVar)) :-
    convert_arg(Template, PrologTemplate),
    convert_arg([v, ResultVar], PrologResultVar),
    convert_body_to_prolog(GoalList, GoalsPredicate).

convert_goal_to_prolog([[n, Predicate], Args], Goal) :-
    convert_args(Args, PrologArgs),
    Goal =.. [Predicate|PrologArgs].

convert_goal_to_prolog([[n, '='], [X, Y]], (PrologX = PrologY)) :-
    convert_arg(X, PrologX),
    convert_arg(Y, PrologY).

convert_goal_to_prolog([[n, not], [SubGoal]], \+ PrologSubGoal) :-
    convert_goal_to_prolog(SubGoal, PrologSubGoal).

convert_goal_to_prolog([[n, '>'], [X, Y]], (PrologX > PrologY)) :-
    convert_arg(X, PrologX),
    convert_arg(Y, PrologY).

% Call SSI predicate and collect solutions
call_ssi_predicate(Predicate, Args, Solutions) :-
    Goal =.. [Predicate|Args],
    findall(Args, Goal, Solutions).

% Simplified test for debugging
test_simple :-
    % Clear previous facts
    retractall(parent(_, _)),
    retractall(male(_)),
    retractall(yearofbirth(_, _)),
    
    % Load some simple facts with siblings
    assertz(parent(albert, jim)),
    assertz(parent(albert, peter)),    % jim and peter are siblings
    assertz(parent(peter, james)),
    assertz(parent(peter, lee)),       % james and lee are siblings  
    assertz(male(peter)),
    assertz(male(james)),
    assertz(male(jim)),
    assertz(yearofbirth(peter, 1945)),
    assertz(yearofbirth(jim, 1949)),
    assertz(yearofbirth(james, 1969)),
    assertz(yearofbirth(lee, 1970)),
    
    % Test simple query for older brothers
    findall([A,B], (parent(X, A), parent(X, B), male(A), A \= B, 
                    yearofbirth(A, Y1), yearofbirth(B, Y2), Y2 > Y1), Results),
    writeln('Simple Results (older brothers):'),
    writeln(Results).

% Testing predicate
test_ssi :-
    % Clear all previous predicates
    retractall(parent(_, _)),
    retractall(male(_)),
    retractall(yearofbirth(_, _)),
    retractall(siblings(_, _)),
    retractall(older(_, _)),
    retractall(older_brother(_)),
    
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

% Test just the conversion
test_convert :-
    retractall(parent(_, _)),
    retractall(male(_)),
    
    % Test converting a simple fact
    convert_item([[n,parent],[albert, jim]]),
    convert_item([[n,male],[albert]]),
    
    % Check if they were asserted
    (parent(albert, jim) -> writeln('parent fact OK') ; writeln('parent fact FAILED')),
    (male(albert) -> writeln('male fact OK') ; writeln('male fact FAILED')).

% Test converting a simple rule
test_convert_rule :-
    retractall(siblings(_, _)),
    
    % Convert siblings rule
    convert_item([[n,siblings],[[v,a],[v,b]],":-",
        [
            [[n,parent],[[v,x],[v,a]]],
            [[n,parent],[[v,x],[v,b]]],
            [[n,not],[[[n,'='],[[v,a],[v,b]]]]]
        ]]),
    
    % Test if it works
    assertz(parent(albert, jim)),
    assertz(parent(albert, peter)),
    
    (siblings(jim, peter) -> writeln('siblings rule OK') ; writeln('siblings rule FAILED')),
    (siblings(peter, jim) -> writeln('siblings rule OK (reverse)') ; writeln('siblings rule FAILED (reverse)')).