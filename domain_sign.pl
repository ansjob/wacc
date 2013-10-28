% Sign domain (-, 0, +), (Domain = sign)

sign_all_values([neg, zero, pos]).

sign_abs(0, zero).
sign_abs(tt, tt).
sign_abs(ff, ff).

sign_abs(X, neg):- integer(X), X < 0.
sign_abs(X, pos):- integer(X), X > 0.

% Add
sign_add(cont, _, cont):- !.
sign_add(_, cont, cont):- !.

sign_add(zero, X, X).
sign_add(X, zero, X).

sign_add(pos, pos, pos).
sign_add(neg, neg, neg).

sign_add(pos, neg, X):-
	member(X, [pos, zero, neg]).

sign_add(neg, pos, X):-
	member(X, [pos, zero, neg]).

% Sub
sign_sub(cont, _, cont):- !.
sign_sub(_, cont, cont):- !.

sign_sub(X, zero, X).
sign_sub(zero, pos, neg).
sign_sub(zero, neg, pos).

sign_sub(pos, pos, X):-
	member(X, [pos, zero, neg]).
sign_sub(pos, neg, pos).

sign_sub(neg, neg, X):-
	member(X, [pos, zero, neg]).
sign_sub(neg, pos, neg).

% Mult
sign_mult(cont, _, cont):- !.
sign_mult(_, cont, cont):- !.

sign_mult(zero, _, zero).
sign_mult(_, zero, zero).

sign_mult(pos, pos, pos).
sign_mult(neg, neg, pos).
sign_mult(neg, pos, neg).
sign_mult(pos, neg, neg).

% Div
sign_div(cont, _, cont):- !.
sign_div(_, cont, cont):- !.

sign_div(_, zero, cont).

sign_div(zero, pos, zero).
sign_div(zero, neg, zero).

sign_div(pos, pos, X):-
	member(X, [zero, pos]).

sign_div(neg, neg, X):-
	member(X, [zero, pos]).

sign_div(pos, neg, X):-
	member(X, [zero, neg]).

sign_div(neg, pos, X):-
	member(X, [zero, neg]).

% Eq
sign_eq(cont, _, cont):- !.
sign_eq(_, cont, cont):- !.

sign_eq(pos, pos, X):-
	member(X, [tt, ff]).

sign_eq(neg, neg, X):-
	member(X, [tt, ff]).

sign_eq(zero, zero, tt).
sign_eq(zero, pos, ff).
sign_eq(zero, neg, ff).

% Leq
sign_leq(cont, _, cont):- !.
sign_leq(_, cont, cont):- !.

sign_leq(pos, neg, ff).
sign_leq(pos, zero, ff).
sign_leq(pos, pos, X):-
	member(X, [tt, ff]).

sign_leq(zero, zero, tt).
sign_leq(zero, pos, tt).
sign_leq(zero, neg, ff).

sign_leq(neg, pos, tt).
sign_leq(neg, zero, tt).
sign_leq(neg, neg, X):-
	member(X, [tt, ff]).

% Neg
sign_neg(tt, ff).
sign_neg(ff, tt).
sign_neg(cont, cont).

% And
sign_and(tt, tt, tt).
sign_and(ff, _, ff).
sign_and(_, ff, ff).

% LUB
sign_lub(none_a, none_a, none_a).
sign_lub(none_a, neg, neg).
sign_lub(none_a, zero, zero).
sign_lub(none_a, pos, pos).
sign_lub(none_a, err_a, err_a).
sign_lub(none_a, non_pos, non_pos).
sign_lub(none_a, non_zero, non_zero).
sign_lub(none_a, non_neg, non_neg).
sign_lub(none_a, z, z).
sign_lub(none_a, any_a, any_a).
sign_lub(neg, none_a, neg).
sign_lub(neg, neg, neg).
sign_lub(neg, zero, non_pos).
sign_lub(neg, pos, non_zero).
sign_lub(neg, err_a, any_a).
sign_lub(neg, non_pos, non_pos).
sign_lub(neg, non_zero, non_zero).
sign_lub(neg, non_neg, z).
sign_lub(neg, z, z).
sign_lub(neg, any_a, any_a).
sign_lub(zero, none_a, zero).
sign_lub(zero, neg, non_pos).
sign_lub(zero, zero, zero).
sign_lub(zero, pos, non_neg).
sign_lub(zero, err_a, any_a).
sign_lub(zero, non_pos, non_pos).
sign_lub(zero, non_zero, z).
sign_lub(zero, non_neg, non_neg).
sign_lub(zero, z, z).
sign_lub(zero, any_a, any_a).
sign_lub(pos, none_a, pos).
sign_lub(pos, neg, non_zero).
sign_lub(pos, zero, non_neg).
sign_lub(pos, pos, pos).
sign_lub(pos, err_a, any_a).
sign_lub(pos, non_pos, z).
sign_lub(pos, non_zero, non_zero).
sign_lub(pos, non_neg, non_neg).
sign_lub(pos, z, z).
sign_lub(pos, any_a, any_a).
sign_lub(err_a, none_a, err_a).
sign_lub(err_a, neg, any_a).
sign_lub(err_a, zero, any_a).
sign_lub(err_a, pos, any_a).
sign_lub(err_a, err_a, err_a).
sign_lub(err_a, non_pos, any_a).
sign_lub(err_a, non_zero, any_a).
sign_lub(err_a, non_neg, any_a).
sign_lub(err_a, z, any_a).
sign_lub(err_a, any_a, any_a).
sign_lub(non_pos, none_a, non_pos).
sign_lub(non_pos, neg, non_pos).
sign_lub(non_pos, zero, non_pos).
sign_lub(non_pos, pos, z).
sign_lub(non_pos, err_a, any_a).
sign_lub(non_pos, non_pos, non_pos).
sign_lub(non_pos, non_zero, z).
sign_lub(non_pos, non_neg, z).
sign_lub(non_pos, z, z).
sign_lub(non_pos, any_a, any_a).
sign_lub(non_zero, none_a, non_zero).
sign_lub(non_zero, neg, non_zero).
sign_lub(non_zero, zero, z).
sign_lub(non_zero, pos, non_zero).
sign_lub(non_zero, err_a, any_a).
sign_lub(non_zero, non_pos, z).
sign_lub(non_zero, non_zero, non_zero).
sign_lub(non_zero, non_neg, z).
sign_lub(non_zero, z, z).
sign_lub(non_zero, any_a, any_a).
sign_lub(non_neg, none_a, non_neg).
sign_lub(non_neg, neg, z).
sign_lub(non_neg, zero, non_neg).
sign_lub(non_neg, pos, non_neg).
sign_lub(non_neg, err_a, any_a).
sign_lub(non_neg, non_pos, z).
sign_lub(non_neg, non_zero, z).
sign_lub(non_neg, non_neg, non_neg).
sign_lub(non_neg, z, z).
sign_lub(non_neg, any_a, any_a).
sign_lub(z, none_a, z).
sign_lub(z, neg, z).
sign_lub(z, zero, z).
sign_lub(z, pos, z).
sign_lub(z, err_a, any_a).
sign_lub(z, non_pos, z).
sign_lub(z, non_zero, z).
sign_lub(z, non_neg, z).
sign_lub(z, z, z).
sign_lub(z, any_a, any_a).
sign_lub(any_a, none_a, any_a).
sign_lub(any_a, neg, any_a).
sign_lub(any_a, zero, any_a).
sign_lub(any_a, pos, any_a).
sign_lub(any_a, err_a, any_a).
sign_lub(any_a, non_pos, any_a).
sign_lub(any_a, non_zero, any_a).
sign_lub(any_a, non_neg, any_a).
sign_lub(any_a, z, any_a).
sign_lub(any_a, any_a, any_a).

