/**
	Compiler:
	Compiles a "decorated" AST (Abstract Syntax Tree with Control Points added)
	into a list of AM instructions.

	Notable predicates:
	compile/2

*/


/**
	compile(+Statement, -Code)

	Compiles the given Statement into a list of Abstract Machine instructions.
	The Statement should have control points added, which are also attached to the
	relevant compiled insutrctions.

	Code is a standard prolog list of AM instructions.
*/
compile(true, [true]).
compile(false, [false]).
compile(var(X), [fetch(X)]).
compile(X, [push(X)]):- integer(X).

compile(end_of_program:CP, [eop:CP]).

compile((A1 + A2), Output):-
	compile(A1, C1),
	compile(A2, C2),
	append([C2, C1, [add]], Output).

compile((A1 * A2), Output):-
	compile(A1, C1),
	compile(A2, C2),
	append([C2, C1, [mult]], Output).

compile((A1 - A2), Output):-
	compile(A1, C1),
	compile(A2, C2),
	append([C2, C1, [sub]], Output).

compile((A1 / A2), Output):-
	compile(A1, C1),
	compile(A2, C2),
	append([C2, C1, [div]], Output).

compile((A1 = A2), Output):-
	compile(A1, C1),
	compile(A2, C2),
	append([C2, C1, [eq]], Output).

compile('<='(A1, A2), Output):-
	compile(A1, C1),
	compile(A2, C2),
	append([C2, C1, [le]], Output).

compile((!(B)), Out):-
	compile(B, C),
	append([C, [neg]], Out).

compile((B1 ^ B2), Out):-
	compile(B1, C1),
	compile(B2, C2),
	append([C2, C1, [and]], Out).

compile(skip:CP, [noop:CP]).

compile(ass(var(X), A):CP, Out):-
	compile(A, C),
	append([C, [store(X):CP]], Out).

compile(cond(B1, S1, S2):CP, Out):-
	compile(B1, C0),
	compile(S1, C1),
	compile(S2, C2),
	append([C0, [branch(C1, C2):CP]], Out).

compile(while(B, S):CP, Out):-
	compile(B, CB),
	compile(S, CS),
	Out = [loop(CB, CS):CP].

compile(trycatch(S1, S2):CP, Out):-
	compile(S1, C1),
	compile(S2, C2),
	Out = [try(C1):CP, catch(C2):CP].

compile(S1 ; S2, Output):-
	compile(S1, First),
	compile(S2, Second),
	append(First, Second, Output).
