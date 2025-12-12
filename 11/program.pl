% runs on SWI-Prolog / Gorkem Pacaci AoC2025 Day 11 part 1
:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).

file([]) --> [].
file([From-Tos|Ls]) --> str(From), ":", tos(Tos), eol, !, file(Ls).

tos([]) --> [].
tos([To|Tos]) --> " ", str(To), tos(Tos).

str(S) --> string(Codes), { string_codes(S, Codes) }.

main :-
    phrase_from_file(file(Map), 'input.txt'),
    write(Map), nl,
    % insert every mapping in Map in a dynamic predicate map using maplist, but insert every member of Tos individually
    maplist([From-Tos]>>maplist([To]>>assertz(map(From, To)), Tos), Map),
    countPaths("you", "out", [], Count1),
    countPaths("svr", "out", ["dac", "fft"], Count2),
    write(part1:Count1), nl,
    write(part1:Count2), nl,
    write(done), nl.

:- table countPaths/4.
countPaths(From, To, [], Count) :- map(From, To), !, Count is 1.
countPaths(From, To, Must, Count) :-
    From \= To,
    findall(SubCount, (map(From, Mid), Mid \= To, delete(Must, Mid, NewMust), countPaths(Mid, To, NewMust, SubCount)), SubCounts),
    sum_list(SubCounts, Count).

:- main.