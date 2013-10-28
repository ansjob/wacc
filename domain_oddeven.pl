% Odd-Even domain (odd, even, any), (Domain = oddeven)

oddeven_all_values([odd, even]).

oddeven_abs(0, even):- !.
oddeven_abs(tt, tt).
oddeven_abs(ff, ff).

oddeven_abs(X, even):-
	integer(X),
	Xp is X // 2,
	Xpp is Xp * 2,
	Xpp = X,
	!.

oddeven_abs(X, odd):- integer(X),
	\+ oddeven_abs(X, even).

% Add
oddeven_add(cont, _, cont):- !.
oddeven_add(_, cont, cont):- !.

oddeven_add(odd, odd, even).
oddeven_add(even, even, even).
oddeven_add(even, odd, odd).
oddeven_add(odd, even, odd).

% Sub
oddeven_sub(cont, _, cont):- !.
oddeven_sub(_, cont, cont):- !.

oddeven_sub(X, Y, Z):- oddeven_add(X, Y, Z).

% Mult
oddeven_mult(cont, _, cont):- !.
oddeven_mult(_, cont, cont):- !.

oddeven_mult(even, even, even).
oddeven_mult(odd, odd, odd).
oddeven_mult(even, odd, even).
oddeven_mult(odd, even, even).

% Div
oddeven_div(cont, _, cont):- !.
oddeven_div(_, cont, cont):- !.

oddeven_div(even, even, even).
oddeven_div(even, even, odd).
oddeven_div(odd, odd, odd).
oddeven_div(odd, odd, even).
oddeven_div(even, odd, even).
oddeven_div(even, odd, odd).
oddeven_div(odd, even, even).
oddeven_div(odd, even, odd).

oddeven_div(_, even, cont).

% Eq
oddeven_eq(cont, _, cont):- !.
oddeven_eq(_, cont, cont):- !.

oddeven_eq(even, even, tt).
oddeven_eq(even, even, ff).
oddeven_eq(odd, odd, tt).
oddeven_eq(odd, odd, ff).
oddeven_eq(even, odd, ff).
oddeven_eq(odd, even, ff).

% Leq
oddeven_leq(cont, _, cont):- !.
oddeven_leq(_, cont, cont):- !.

oddeven_leq(_, _, tt).
oddeven_leq(_, _, ff).

% Neg
oddeven_neg(tt, ff).
oddeven_neg(ff, tt).
oddeven_neg(cont, cont).

% And
oddeven_and(cont, _, cont):- !.
oddeven_and(_, cont, cont):- !.
oddeven_and(tt, tt, tt).
oddeven_and(ff, _, ff).
oddeven_and(_, ff, ff).

% LUB
oddeven_lub(any, _, any).
oddeven_lub(_, any, any).

oddeven_lub(odd, odd, odd).
oddeven_lub(even, even, even).
oddeven_lub(odd, even, any).
oddeven_lub(even, odd, any).
