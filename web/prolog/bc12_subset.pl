% bc12_subset.pl - Mobile-friendly subset for Tau Prolog (browser)
%
% This file replicates the same number of `a` computations as bc12.pl
% but uses a minimal `a` predicate so the browser can run it quickly.
%
% Original bc12.pl:
%   b1 calls a 14 times, b2 calls a 7 times -> 21 `a` calls per bc12/0
%   c1/c2 run texttobr (text-to-Breasoning conversion)
%
% Subset strategy:
%   - Keep b1 (14 a's), b2 (7 a's) -> same 21 `a` calls per bc12/0
%   - Replace the large a1 fact with a minimal succeeding predicate
%   - Replace c1/c2 text processing with lightweight stubs
%   - Expose bc12_subset(N) for the web UI

% --- Core computation wrapper ---
% bc12_subset(N): run bc12 N times, producing 21*N `a` activations total.
bc12_subset(N) :- length(A, N), findall(_, (member(_, A), bc12), _), !.

% bc12/0: mirrors original structure (b1 then b2 then c1 then c2)
bc12 :- b1, b2, c1, c2, !.

% b1: 14 `a` calls (same cardinality as original)
b1 :- a, a, a, a, a, a, a, a, a, a, a, a, a, a.

% b2: 7 `a` calls (same cardinality as original)
b2 :- a, a, a, a, a, a, a.

% a/0: minimal computation that succeeds immediately.
%   In bc12.pl, `a` calls a1/1 with a large list of 3D-coordinate terms.
%   Here we replace that with a direct success to keep mobile performance high
%   while preserving the count of `a` activations.
a.

% c1/0, c2/0: lightweight stubs replacing the original texttobr calls.
%   In bc12.pl these convert large blocks of text to Breasonings.
%   In the browser subset we just succeed so the activation count stays the same.
c1.
c2.
