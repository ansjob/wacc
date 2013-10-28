
% No-op
step(_, config([noop:_|C], Stack, Assoc), NextConfig):-
	NextConfig = config(C, Stack, Assoc).

% End of program
step(_, config([eop:_], [], Assoc), config([], [], Assoc)).

% End of program e_config
step(_, e_config([eop:_], [], Assoc), e_config([], [], Assoc)).

% Store
step(_, config([store(X):_|C], [Val|Stack], Assoc), NextConfig):-
	Val \= cont,
	put_assoc(X, Assoc, Val, NewAssoc),
	NextConfig = config(C, Stack, NewAssoc).

step(_, config([store(_):_|C], [cont|Stack], Assoc), NextConfig):-
	NextConfig = e_config(C, Stack, Assoc).

% Fetch
step(_, config([fetch(X)|C], Stack, Assoc), NextConfig):-
	get_assoc(X, Assoc, Val),
	NextConfig = config(C, [Val|Stack], Assoc).

% Branch
step(_, config([branch(C1, _):_|C], [tt|Stack], Assoc), NextConfig):-
	append([C1, C], Code),
	NextConfig = config(Code, Stack, Assoc).

step(_, config([branch(_, C2):_|C], [ff|Stack], Assoc), NextConfig):-
	append([C2, C], Code),
	NextConfig = config(Code, Stack, Assoc).

step(_, config([branch(_, _):_|C], [cont|Stack], Assoc), NextConfig):-
	NextConfig = e_config(C, Stack, Assoc).

% Push
step(Domain, config([push(X)|C], Stack, Assoc), NextConfig):-
	abs(Domain, X, Abs),
	NextConfig = config(C, [Abs|Stack], Assoc).

% Loop
step(_, config([loop(Condition, Body):CP|C], Stack, Assoc), NextConfig):-
	append([Body, [loop(Condition, Body):CP]], BranchBody),
	append([Condition, [branch(BranchBody, [noop:0]):CP ], C], NextCode),
	NextConfig = config(NextCode, Stack, Assoc).

% Add
step(Domain, config([add | C], [A, B | Stack], Assoc), NextConfig):-
	add(Domain, A, B, Sum),
	NextConfig = config(C, [Sum | Stack], Assoc).

% Sub
step(Domain, config([sub | C], [A, B | Stack], Assoc), NextConfig):-
	sub(Domain, A, B, Diff),
	NextConfig = config(C, [Diff | Stack], Assoc).

% Mult
step(Domain, config([mult | C], [A, B | Stack], Assoc), NextConfig):-
	mult(Domain, A, B, Product),
	NextConfig = config(C, [Product | Stack], Assoc).

% True (instruction)
step(Domain, config([true | C], Stack, Assoc), NextConfig):-
	abs(Domain, tt, True),
	NextConfig = config(C, [True | Stack], Assoc).

% False (instruction)
step(Domain, config([false | C], Stack, Assoc), NextConfig):-
	abs(Domain, ff, False),
	NextConfig = config(C, [False | Stack], Assoc).

% Eq (equal)
step(Domain, config([eq | C], [A, B | Stack], Assoc), config(C, [Res | Stack], Assoc)):-
	eq(Domain, A, B, Res).

% Le (less than equal)
step(Domain, config([le | C], [A, B | Stack], Assoc), config(C, [Res | Stack], Assoc)):-
	leq(Domain, A, B, Res).

% And
step(Domain, config([and | C], [A, B | Stack], Assoc), config(C, [Res | Stack], Assoc)):-
	and(Domain, A, B, Res).

% Neg (negation/not)
step(Domain, config([neg | C], [E | Stack], Assoc), config(C, [Res | Stack], Assoc)):-
	neg(Domain, E, Res).

% Additions for supporting division and exception handling below

% Div
step(Domain, config([div | C], [Z1, Z2 | Stack], Assoc), NextConfig):-
	div(Domain, Z1, Z2, Val),
	NextConfig = config(C, [Val|Stack], Assoc).

% Catch
step(_, e_config([catch(C1):_ | C], Stack, Assoc), NextConfig):-
	append(C1, C, NextCode),
	NextConfig = config(NextCode, Stack, Assoc).

step(_, config([catch(_):_ | C], S, A), config(C,S,A) ).

% Rules for exceptional configurations (e_config)
step(_, e_config([Inst | C], [_, _ | S], A), Next):-
	member(Inst, [add, sub, mult, div, eq, le, and]),
	Next = e_config(C, [cont | S], A).

step(_, e_config([neg | C], [_ | S], A), e_config(C, [cont|S], A)).

step(_, e_config([store(_):_ | C], [_ | S], A), e_config(C, S, A)).

step(_, e_config([branch(_, _):_ | C], [_ | S], A), e_config(C,S,A)).

step(_, e_config([loop(_, _):_ | C], [_ | S], A), e_config(C,S,A)).

step(_, config([try(C1):_ | C], S, A), NextConfig):-
	append(C1, C, NextCode),
	NextConfig = config(NextCode, S, A).

step(_, e_config([try(_):_, catch(_):_ | C], S, A), e_config(C,S,A)).

step(_, e_config([Inst | C], Stack, Assoc), NextConfig):-
	member(Inst, [push(_), true, false, fetch(_)]),
	NextConfig = e_config(C, [cont | Stack], Assoc).

step(_, e_config([noop:_ | C], Stack, Assoc), NextConfig):-
	NextConfig = e_config(C, Stack, Assoc).

%Auxiliary methods below
run_code(Domain, C, FinalConfig):-
	empty_assoc(E), 
	run_config(Domain, config(C, [], E), FinalConfig).

run_config(_, C, C):-
	C = config([], _, _).

run_config(Domain, C, Final):-
	step(Domain, C, Next),
	!,
	run_config(Domain, Next, Final).

/**
	config_to_format(+Config, -Atom)

	Converts a config into an atom that is printable (not a proper String)
	and represents the associative memory, not the stack or code to be executed.
*/
config_to_format(config(_, _, State), String) :-
	assoc_to_list(State, List),
	config_to_format(List, [], String).

config_to_format([], String, String).
config_to_format([H|T], Acc, [Z|String]) :-
	H = X-Y,
	Z = '='(X,Y),
	config_to_format(T, Acc, String).
