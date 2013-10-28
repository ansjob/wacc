% Concrete integer domain (Domain = int)

int_all_values([any]).

int_abs(tt, tt).
int_abs(ff, ff).
int_abs(X, X):-
	integer(X).

int_add(cont, _, cont):- !.
int_add(_, cont, cont):- !.
int_add(any, _, any):- !.
int_add(_, any, any):- !.
int_add(A, B, Res):-
	Res is A + B.

int_sub(cont, _, cont):- !.
int_sub(_, cont, cont):- !.
int_sub(any, _, any):- !.
int_sub(_, any, any):- !.
int_sub(A, B, Res):-
	Res is A - B.

int_mult(cont, _, cont):- !.
int_mult(_, cont, cont):- !.
int_mult(any, _, any):- !.
int_mult(_, any, any):- !.
int_mult(A, B, Res):-
	Res is A * B.

int_div(cont, _, cont):- !.
int_div(_, cont, cont):- !.
int_div(any, _, any):- !.
int_div(_, any, any):- !.
int_div(_, 0, cont).
int_div(A, B, Res):-
	B \= 0,
	Res is A // B.

int_eq(cont, _, cont):- !.
int_eq(_, cont, cont):- !.
int_eq(any, _, any):- !.
int_eq(_, any, any):- !.
int_eq(A, A, tt).
int_eq(A, B, ff):-
	A \= B.

int_leq(cont, _, cont):- !.
int_leq(_, cont, cont):- !.
int_leq(any, _, any):- !.
int_leq(_, any, any):- !.
int_leq(A, B, tt):-
	A =< B.
int_leq(A, B, ff):-
	\+ A =< B.

int_neg(cont, _, cont):- !.
int_neg(_, cont, cont):- !.
int_neg(any, any):- !.
int_neg(tt, ff).
int_neg(ff, tt).

int_and(cont, _, cont):- !.
int_and(_, cont, cont):- !.
int_and(any, _, any):- !.
int_and(_, any, any):- !.
int_and(tt, tt, tt).
int_and(ff, _, ff).
int_and(_, ff, ff).

int_lub(any, _, any):- !.
int_lub(_, any, any):- !.
int_lub(cont, _, cont):- !.
int_lub(_, cont, cont):- !.
int_lub(X, X, X).
int_lub(X, Y, any):- X \= Y.
