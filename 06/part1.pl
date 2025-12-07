% runs on SWI-Prolog / Gorkem Pacaci AoC2025 Day 6 part 2
:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).

file([L|Ls], Ops) --> line(L), eol, file(Ls, Ops).
file([], Ops) --> ops(Ops).
line([]) --> [].
line([N|Ns]) --> whites, integer(N), whites, line(Ns).
ops([]) --> [].
ops(['*'|Os]) --> "*", whites, ops(Os).
ops(['+'|Os]) --> "+", whites, ops(Os).

sumAllOps(_, [], 0).
sumAllOps(Ls, [O|Ops], Result) :-
    maplist([[H|T],H,T]>>true, Ls, Lheads, Ltails),
    ( O = '+' -> foldl(plus, Lheads, 0, ThisResult) 
    ; O = '*' -> foldl([X,Y,Z] >> (Z #= X*Y), Lheads, 1, ThisResult)),
    sumAllOps(Ltails, Ops, RestResult),
    Result is RestResult + ThisResult.

main :-
    phrase_from_file(file(Ls, Ops), 'input.txt'),
    sumAllOps(Ls, Ops, Part1),
    write(part1:Part1), nl.

:- main.