% runs on SWI-Prolog / Gorkem Pacaci AoC2025 Day 1
:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).

file(kitchen(F, I)) --> ranges(F), blanks, ingredients(I).
ranges(Fresh) --> [], {empty_fdset(Fresh)}.
ranges(Fresh) --> integer(L), "-", integer(U), eol, ranges(FreshRest),
    {range_to_fdset((L..U), NewFresh), fdset_union(NewFresh, FreshRest, Fresh)}.
ingredients([]) --> [].
ingredients([I|Rest]) --> integer(I), eol, ingredients(Rest).

main :-
    write("hello"), nl,
    phrase_from_file(file(kitchen(Fresh,Ingredients)), 'input.txt'),
    include([E]>>fdset_member(E, Fresh), Ingredients, FreshIngredients),
    %write(FreshIngredients), nl,
    length(FreshIngredients, L),
    write(part1:L), nl,
    fdset_size(Fresh, Size),
    write(part2:Size), nl.


:- main.