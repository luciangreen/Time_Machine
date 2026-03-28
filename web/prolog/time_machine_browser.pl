% time_machine_browser.pl - Tau Prolog browser entrypoint for Time Machine
%
% This file provides UI-friendly wrapper predicates that the web app can call.
% It is designed to be loaded after bc12_subset.pl has been consulted, so that
% bc12/0 and bc12_subset/1 are already available.
%
% Predicates exported:
%   tm_prepare/0  - run one cycle of the bc12 computation as a demo
%   tm_run/1      - run N cycles of the bc12 computation
%   tm_info/0     - print information about the computation

% tm_prepare/0: demo equivalent of time_machine_prepare
%   Runs one bc12_subset cycle and reports success/failure.
tm_prepare :-
    write('Time Machine browser preparation started.'), nl,
    (   bc12_subset(1)
    ->  write('bc12_subset(1) succeeded.'), nl,
        write('Time Machine preparation complete.'), nl
    ;   write('bc12_subset(1) failed.'), nl
    ).

% tm_run(N): run N bc12_subset cycles.
%   Each cycle activates a/0 exactly 21 times (14 via b1 + 7 via b2).
tm_run(N) :-
    (   integer(N), N > 0
    ->  bc12_subset(N),
        write('bc12_subset('), write(N), write(') done.'), nl
    ;   write('Error: tm_run/1 requires a positive integer argument.'), nl,
        fail
    ).

% tm_info/0: display information about the computation.
tm_info :-
    write('Time Machine Browser (Tau Prolog edition)'), nl,
    write('  bc12_subset(N): runs N bc12 cycles'), nl,
    write('  Each cycle: b1 (14 x a) + b2 (7 x a) + c1 + c2 = 21 a activations'), nl,
    write('  tm_prepare/0 : run 1 cycle (demo)'), nl,
    write('  tm_run/1     : run N cycles'), nl.
