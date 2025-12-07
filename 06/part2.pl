% runs on SWI-Prolog / Gorkem Pacaci AoC2025 Day 6 part 2
:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).

file([]) --> [].
file([L|Ls]) --> string_without("\n", C), eol, {C\=[], maplist(char_code, L, C)}, file(Ls).

list_last([X], [], X).
list_last([X|Xs], [X|List], Last) :- 
    list_last(Xs, List, Last).

cephaToStack([[]|_], []).
cephaToStack(Lines, Stack) :-
    maplist([[H|T],H,T]>>true, Lines, Heads, Tails),
    list_last(Heads, HeadsRest, Op),
    delete(HeadsRest, ' ', NumberCodes),
    (
        NumberCodes == []
        ->
            cephaToStack(Tails, Stack)
        ;
            number_codes(Number, NumberCodes),
            ( Op == ' ' -> Stack=[Number|Rest];  Stack=[Op,Number|Rest] ),
            cephaToStack(Tails, Rest)
    ).

subStack([], RunningResult, _, RunningResult, []).
subStack([E|Stack], RunningResult, RunningOperator, SubResult, RemStack) :-
    number(E)
    -> 
        ( RunningOperator = '+' -> MidResult is RunningResult + E, subStack(Stack, MidResult, RunningOperator, SubResult, RemStack)
        ; RunningOperator = '*' -> MidResult is RunningResult * E, subStack(Stack, MidResult, RunningOperator, SubResult, RemStack)
        )
    ;
        RunningResult=SubResult, RemStack=[E|Stack].

sumStack([], 0).
sumStack([E|Stack], Result) :-
    ( E = '+' -> subStack(Stack, 0, '+', SubResult, RestStack) 
    ; E = '*' -> subStack(Stack, 1, '*', SubResult, RestStack)
    ; write('error in sumStack'), nl, fail),
    sumStack(RestStack, RestResult),
    Result is SubResult + RestResult.

main :-
    phrase_from_file(file(Ls), 'input.txt'),
    cephaToStack(Ls, Stack),
    sumStack(Stack, Result),
    write(part2:Result), nl.

:- main.