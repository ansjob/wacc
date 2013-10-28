:-[atomics].

lex([])			--> white_space, [].
% Special case allowing last keyword without trailing whitespace.
lex([A])		--> white_space, keyword(A), [].
lex([H|Tail])	--> white_space, token(H), !, lex(Tail).
lex(Tail)		--> white_space, "#", comment(_), lex(Tail).
lex([error(Here)])	--> anything(Here), !.

keyword(try)	--> "try".
keyword(catch)	--> "catch".
keyword(while)	--> "while".
keyword(do)		--> "do".
keyword(if)		--> "if".
keyword(then)	--> "then".
keyword(else)	--> "else".

% A keyword must be followed by (at least) one whitespace.
token(X) 		--> keyword(X), wchar.

token(skip)		--> "skip".
token(true)		--> "true".
token(false)	--> "false".
token(=)		--> ":=".
token(eq)		--> "=".
token(l_paren)	--> "(".
token(r_paren)	--> ")".
token(semicolon)--> ";".
token(+)		--> "+".
token(-)		--> "-".
token(*)		--> "*".
token(/)		--> "/".
token(<=)		--> "<=".
token(!)		--> "!".
token(^)		--> "^".

token(I)		--> integer(I).
token(var(Var))	--> variable(Var).

comment([])		--> "\n", !.
comment([A|Tail])		--> [A], comment(Tail).
