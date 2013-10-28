/**
 	Variable Extractor:
 	This module contains the extract_vars/2 predicate,
 	used to find all variables occuring in a given AST.
 */

/**
 	extract_vars(+AST, -Set):
 	Extracts the variables occuring in AST into Set.
 	Parameters:
 		AST - The abstract syntax tree without control points.
 		Set - A list where each unique element occurs only once.
 */
extract_vars(AST, Set):-
	extract_vars(AST, [], List),
	list_to_set(List, Set).

/* */
extract_vars(skip, In, In).
extract_vars(true, In, In).
extract_vars(false, In, In).

extract_vars(var(X), In, [X|In]).

extract_vars(ass(var(X), Exp), In, Out):-
	extract_vars(Exp, [X|In], Out).

extract_vars(X, In, In):-
	integer(X).

extract_vars(';'(X, Y), In, Out):-
	extract_vars(X, In, Tmp),
	extract_vars(Y, Tmp, Out).

extract_vars('+'(X, Y), In, Out):-
	extract_vars(X, In, Tmp),
	extract_vars(Y, Tmp, Out).

extract_vars(X - Y, In, Out):-
	extract_vars(X, In, Tmp),
	extract_vars(Y, Tmp, Out).

extract_vars(X * Y, In, Out):-
	extract_vars(X, In, Tmp),
	extract_vars(Y, Tmp, Out).

extract_vars(X / Y, In, Out):-
	extract_vars(X, In, Tmp),
	extract_vars(Y, Tmp, Out).

extract_vars(cond(Guard, IfBody, ElseBody), In, Out):-
	extract_vars(Guard, In, Tmp1),
	extract_vars(IfBody, Tmp1, Tmp2),
	extract_vars(ElseBody, Tmp2, Out).

extract_vars('<='(X, Y), In, Out):-
	extract_vars(X, In, Tmp),
	extract_vars(Y, Tmp, Out).

extract_vars('^'(X, Y), In, Out):-
	extract_vars(X, In, Tmp),
	extract_vars(Y, Tmp, Out).

extract_vars('!'(X), In, Out):-
	extract_vars(X, In, Out).

extract_vars('='(X, Y), In, Out):-
	extract_vars(X, In, Tmp),
	extract_vars(Y, Tmp, Out).

extract_vars(while(Condition, Body), In, Out):-
	extract_vars(Condition, In, Tmp),
	extract_vars(Body, Tmp, Out).

extract_vars(trycatch(TryBody, CatchBody), In, Out):-
	extract_vars(TryBody, In, Tmp),
	extract_vars(CatchBody, Tmp, Out).
