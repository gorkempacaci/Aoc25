% runs on SWI-Prolog / Gorkem Pacaci AoC2025 Day 7 part 1
:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).

file([]) --> [].
file([L|Ls]) --> string_without("\n", C), eol, {C\=[], maplist(char_code, L, C)}, file(Ls).

replace_all(_, _, [], []).
replace_all(Old, New, [Old|T], [New|R]) :- replace_all(Old, New, T, R).
replace_all(Old, New, [H|T], [H|R]) :- H \= Old, replace_all(Old, New, T, R).

countReflects([], L, L).
countReflects([S|SplitterIndices], LightCountsIn, LightCountsOut) :-
    nth0(S, LightCountsIn, CountAtSplitter, RestCounts),
    CountAtSplitter > 0
    -> 
            Left is S-1, Right is S+1,
            nth0(S, CountsWithLRemoved, 0, RestCounts),
            nth0(Left, CountsWithLRemoved, LcLeft, RestWithoutLeft), LcLeftNew is LcLeft + CountAtSplitter, nth0(Left, CountsWithLeftUpdated, LcLeftNew, RestWithoutLeft),
            nth0(Right, CountsWithLeftUpdated, LcRight, RestWithoutRight), LcRightNew is LcRight + CountAtSplitter, nth0(Right, LightCountsThisStep, LcRightNew, RestWithoutRight),
            countReflects(SplitterIndices, LightCountsThisStep, LightCountsOut), !
    ;
            countReflects(SplitterIndices, LightCountsIn, LightCountsOut).

foldLights([], L, L).
foldLights([SIs|SplitterIndicesList], LightCountsIn, LightCountsOut) :-
    countReflects(SIs, LightCountsIn, LightCountsThisStep),
    foldLights(SplitterIndicesList, LightCountsThisStep, LightCountsOut).

main :-
    phrase_from_file(file([SLine|SplitterLines]), 'input.txt'),
    replace_all('S', 1, SLine, LightCounts_),
    replace_all('.', 0, LightCounts_, LightCounts),
    maplist([L]>>findall(Index, nth0(Index, L, '^')), SplitterLines, SplitterIndicesList),
    foldLights(SplitterIndicesList, LightCounts, LightCountsEnd),
    sum_list(LightCountsEnd, Part2),
    write(part2:Part2), nl.

:- main.