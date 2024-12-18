markOffMultiples(PSet, J, _) :- length(PSet, PSetLen), J >= PSetLen, !.
markOffMultiples(PSet, J, Inc) :-
    (nth0(J, PSet, E), var(E) -> E = 0; true),
    NextJ is J + Inc,
    markOffMultiples(PSet, NextJ, Inc).

markOff(_, SqrtN, SqrtN) :- !.
markOff(PSet, I, SqrtN) :-
    (   nth0(I, PSet, E), var(E) ->
        E = 1,
        J is 2 * I * (I + 1),
        Inc is 2 * I + 1,
        markOffMultiples(PSet, J, Inc)
    ;   true
    ),
    NextI is I + 1,
    markOff(PSet, NextI, SqrtN).

clearVars(PSet) :-
    include(var, PSet, VSet),
    maplist(=(1), VSet).

decodeSet(PSet, L) :- decodeSet(PSet, L, [2], 1).
decodeSet([], L, L, _) :- !.
decodeSet([0 | T], L, Ac, N) :- !, NextN is N + 2, decodeSet(T, L, Ac, NextN).
decodeSet([1 | T], L, Ac, N) :-
    append(Ac, [N], Ac2),
    NextN is N + 2,
    decodeSet(T, L, Ac2, NextN).

sieve(N, L) :-
    PrimeSetLen is N // 2,
    length(PrimeSet, PrimeSetLen),
    nth0(0, PrimeSet, 0),
    TSqrtN is 1 + floor(sqrt(N)) // 2,
    markOff(PrimeSet, 1, TSqrtN),
    clearVars(PrimeSet),
    decodeSet(PrimeSet, L).

:- writeln('What is the upper limit for the prime number computations?'),
    read_line_to_string(user_input, UpperLimitStr),
    (   atom_number(UpperLimitStr, UpperLimit), UpperLimit >= 2 ->
        sieve(UpperLimit, L),
        writeln(L),
        length(L, PrimeCount),
        write('There are '), write(PrimeCount), writeln(' primes in this list.')
    ;   writeln('The upper limit for the calculation must be an integer bigger than one.')
    ),
    halt.
