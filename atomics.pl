/**
	Atomics - DCG primitives that are not all specific to while, 
	and could potentially be reused by other systems.

*/

/**
	Anything//1 matches literally anything.
*/
anything([H|T])--> [H], anything(T).
anything([])	--> [].

/**
	variable//1 matches a variable name primitive,
	for example "x" or "angle", but not while keywords such as "try".
*/
variable(Var) --> at_least_one_letter(L),
	{
		atom_codes(Var, L),
		\+ member(Var, [skip, if, then, else, while, do, try, catch])
	}.

at_least_one_letter([H|T]) --> letter(H), letters(T).

letter(X) --> [X], {member(X, "abcdefghijklmnopqrstuvwxyz")}.

/**
	letters//1 matches a list of zero or more letters.
*/
letters([X|T]) --> letter(X), letters(T).
letters([]) --> [].

/**
	white_space//0 matches zero or more whitespace characters.
*/
white_space --> [].
white_space --> wchar, white_space.

wchar --> " ".
wchar --> "\t".
wchar --> "\n".

integer(I) -->
	digit(D0),
	digits(D),
	{ number_codes(I, [D0|D]) }.

digits([D|T]) -->
	digit(D),
	digits(T).
digits([]) -->
	[].

digit(D) -->
	[D],
	{ code_type(D, digit) }.
