% runs on SWI-Prolog / Gorkem Pacaci AoC2025 Day 7 part 1
:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).

file([]) --> [].
file([L|Ls]) --> string_without("\n", C), eol, {C\=[], maplist(char_code, L, C)}, file(Ls).

countReflects([], _, [], 0).
countReflects(Ls, [], Ls, 0).
countReflects([L|LightIndices], [S|SplitterIndices], UpdatedLightIndices, Count) :-
    L==S -> Left is L-1, Right is L+1, UpdatedLightIndices=[Left,Right|RestLights], countReflects(LightIndices, SplitterIndices, RestLights, CountRest), Count is CountRest + 1;
    L<S -> countReflects(LightIndices, [S|SplitterIndices], SubLightIndices, Count), UpdatedLightIndices=[L|SubLightIndices];
    L>S -> countReflects([L|LightIndices], SplitterIndices, UpdatedLightIndices, Count).

foldLights(LightIndices, [], LightIndices, 0).
foldLights(LightIndices, [S|SplitterIndicesList], NewLightIndices, TotalCount) :-
    countReflects(LightIndices, S, NextLightIndices, ThisCount),
    foldLights(NextLightIndices, SplitterIndicesList, NewLightIndices, RestCount),
    TotalCount is ThisCount + RestCount.

main :-
    phrase_from_file(file([SLine|ReflectorLines]), 'input.txt'),
    nth0(SIndex, SLine, 'S'),
    maplist([L]>>findall(Index, nth0(Index, L, '^')), ReflectorLines, ReflectorIndicesList),
    foldLights([SIndex], ReflectorIndicesList, _, Part1),
    write(part1:Part1), nl.
    
:- main.