[domain_int].
[domain_sign].
[domain_oddeven].

domain_call(Domain, Method, X):-
	atom_codes(Domain, C),
	append([C, "_", Method], Name),
	atom_codes(Aname, Name),
	functor(F, Aname, 1),
	arg(1, F, X),
	call(F).

domain_call(Domain, Method, X, Y):-
	atom_codes(Domain, C),
	append([C, "_", Method], Name),
	atom_codes(Aname, Name),
	functor(F, Aname, 2),
	arg(1, F, X),
	arg(2, F, Y),
	call(F).

domain_call(Domain, Method, X, Y, Z):-
	atom_codes(Domain, C),
	append([C, "_", Method], Name),
	atom_codes(Aname, Name),
	functor(F, Aname, 3),
	arg(1, F, X),
	arg(2, F, Y),
	arg(3, F, Z),
	call(F).

all_values(Domain, X):-
	domain_call(Domain, "all_values", X).

abs(Domain, X, Y):-
	domain_call(Domain, "abs", X, Y).

add(Domain, X, Y, Z):-
	domain_call(Domain, "add", X, Y, Z).

sub(Domain, X, Y, Z):-
	domain_call(Domain, "sub", X, Y, Z).

mult(Domain, X, Y, Z):-
	domain_call(Domain, "mult", X, Y, Z).

div(Domain, X, Y, Z):-
	domain_call(Domain, "div", X, Y, Z).

eq(Domain, X, Y, Z):-
	domain_call(Domain, "eq", X, Y, Z).

leq(Domain, X, Y, Z):-
	domain_call(Domain, "leq", X, Y, Z).

and(Domain, X, Y, Z):-
	domain_call(Domain, "and", X, Y, Z).

neg(Domain, X, Y):-
	domain_call(Domain, "neg", X, Y).

lub(Domain, X, Y, Z):-
	domain_call(Domain, "lub", X, Y, Z).
