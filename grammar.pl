:-op(700, xfy, '<=').

% Grammar for statements (stmt) of a While-program
stmt(S) --> basic_stmt(S).
stmt(S) --> basic_stmt(S1), [semicolon], stmt(S2), {S = ';'(S1, S2)}.

basic_stmt(skip) --> [skip].

basic_stmt(ass(var(X), AExp)) -->
	[var(X)],
	[=],
	aexp(AExp).

basic_stmt(cond(BExp, ThenBody, ElseBody)) -->
	[if],
	bexp(BExp),
	[then],
	basic_stmt(ThenBody),
	[else],
	basic_stmt(ElseBody).

basic_stmt(while(Guard, LoopBody)) -->
	[while],
	bexp(Guard),
	[do],
	basic_stmt(LoopBody).

basic_stmt(trycatch(TryBody, CatchBody)) -->
	[try],
	basic_stmt(TryBody),
	[catch],
	basic_stmt(CatchBody).

basic_stmt(S) --> [l_paren], stmt(S), [r_paren].

% Grammar for boolean expressions
bexp(X) --> primary_bexp(X).
bexp(A ^ B) --> primary_bexp(A), [^], bexp(B).

primary_bexp(true) --> [true].
primary_bexp(false) --> [false].

primary_bexp(A <= B) --> aexp(A), [<=], aexp(B).
primary_bexp(A = B) --> aexp(A), [eq], aexp(B).
primary_bexp(BExp) --> [l_paren], bexp(BExp), [r_paren].
primary_bexp('!'(BExp)) --> [!], primary_bexp(BExp).

% Grammar for arithmetic expressions (with implicit priorites)
aexp(X)		-->	term(X).
aexp(X)		-->	term(Y), [+], aexp(Z), { X = Y + Z }.
aexp(X)		-->	term(Y), [-], aexp(Z), { X = Y - Z }.

term(X)		-->	factor(X).
term(X)		-->	factor(Y), [*], term(Z), { X = Y * Z }.
term(X)		-->	factor(Y), [/], term(Z), { X = Y / Z }.

factor(X)	-->	[X], {integer(X)}.
factor(X)	-->	[X], {X = var(_)}.
factor(X)	-->	[l_paren], aexp(X), [r_paren].

% Functions for annotating the AST with control point numbers and end of program statement
add_control_points(AST, AAST):-
	add_control_points(AST, TAST, 1, Next),
	AAST = ';'(TAST, (end_of_program:Next)).

add_control_points(';'(A, B), ';'(Ap, Bp), Nin, Nout):-
	add_control_points(A, Ap, Nin, Ntmp),
	add_control_points(B, Bp, Ntmp, Nout).

add_control_points(skip, skip:Nin, Nin, Nout):-
	Nout is Nin + 1.

add_control_points(ass(var(X), Exp), ass(var(X), Exp):Nin, Nin, Nout):-
	Nout is Nin + 1.

add_control_points(cond(Guard, If, Else), cond(Guard, Nif, Nelse):Nin, Nin, Nout):-
	N1 is Nin + 1,
	add_control_points(If, Nif, N1, N2),
	add_control_points(Else, Nelse, N2, Nout).

add_control_points(while(Guard, Body), while(Guard, Nbody):Nin, Nin, Nout):-
	Ntmp is Nin + 1,
	add_control_points(Body, Nbody, Ntmp, Nout).

add_control_points(trycatch(Try, Catch), trycatch(Ntry, Ncatch):Nin, Nin, Nout):-
	N1 is Nin + 1,
	add_control_points(Try, Ntry, N1, N2),
	add_control_points(Catch, Ncatch, N2, Nout).
