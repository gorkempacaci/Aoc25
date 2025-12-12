% runs on SWI-Prolog / Gorkem Pacaci AoC2025 Day 9 part 1
:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).

file([]) --> [].
file([(X,Y)|Ls]) --> number(X), ",", number(Y), eol, file(Ls).

main :-
    phrase_from_file(file(Coords), 'input.txt'),
    maplist([(X1,Y1), MaxPerPoint]>>
        (maplist([(X2,Y2), Area]>>(Area is abs(X2 - X1 + 1) * abs(Y2 - Y1 + 1)), Coords, Areas), max_list(Areas, MaxPerPoint)),
        Coords,
        AllMaxes),
    max_list(AllMaxes, Largest),
    write(part1:Largest).

:- main.