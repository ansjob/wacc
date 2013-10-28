phrase(stmt(S), [skip, semicolon, skip]) :: s.
phrase(lex(Tokens), "skip ; "), phrase(stmt(S), Tokens), print(S) :: f.
phrase(stmt(S), [if, true, do, skip, else, skip]) :: f.
phrase(stmt(S), [if, true, then, skip, else, skip]) :: S = cond(true, skip, skip).
phrase(stmt(S), [if, l_paren, true, r_paren, then, skip, else, skip])
	:: S = cond(true, skip, skip).

phrase(stmt(S), [while, true, do, skip])
	:: S = while(true, skip).

phrase(stmt(S), [while, true, do, skip, semicolon, skip])
	:: S = ';'(while(true, skip) , skip).

phrase(stmt(S), [while, true, do, l_paren, skip, semicolon, skip, r_paren])
	:: S = while(true, ';'(skip, skip)).

phrase(stmt(S), [var(x), =, 5]) :: S = ass(var(x), 5).


phrase(bexp(BExp), [false]) :: BExp = false.
phrase(bexp(BExp), [12, <=, var(x)]) :: BExp = (12 <= var(x)).
phrase(bexp(BExp), [12, eq, var(x)]) :: BExp = '='(12, var(x)).
phrase(bexp(BExp), [!, true]) :: BExp = '!'(true).
phrase(bexp(BExp), [!, l_paren, true , r_paren]) :: BExp = '!'(true).
phrase(bexp(BExp), ['!', true, ^, false]) :: 
	BExp = 
		'^'(
			'!'(true), 
			false
		).

phrase(bexp(B), [!, l_paren, true, ^, false, r_paren]) ::
	B = '!'(true ^ false).

phrase(bexp(B), [!, 5, eq, var(x), ^, !, !, 7, +, 4, <=, var(y)]) ::
	B = !(5 = var(x)) ^ !(!(7+4 <= var(y))).
phrase(bexp(B), [5, eq, 5]) :: B = '='(5, 5).
phrase(bexp(B), [!, 5, eq, 5, + , 7, ^, false]) :: 
	B = '^'(
			'!'(
				'='(5, '+'(5,7))
			),
		 false).
phrase(bexp(B), [!, !, false]) :: B = !(!(false)).

phrase(aexp(X), [25]) :: X = 25.
phrase(aexp(X), [var(y)]) :: X = var(y).

phrase(aexp(X), [25, +, 37]) :: X = 25 + 37.
phrase(aexp(X), [25, +]) :: f.
phrase(aexp(X), [25, +, 27, *, 5]) :: X = 25 + (27 * 5).
phrase(aexp(X), [var(x), *, 27, +, 5]) :: X = (var(x) * 27) + 5.
phrase(lex(L), "(5+7)*10 - x"), phrase(aexp(A), L) :: s.

phrase(stmt(S), [try, skip, catch, var(x), =, 5])
	:: S = trycatch(skip, ass(var(x), 5)).

phrase(stmt(S), [if, true, then, skip, else, skip, semicolon, skip])
	:: S = ';'(cond(true, skip, skip), skip).

phrase(stmt(S), [try, skip, catch, skip, semicolon, skip])
	:: S = ';'(trycatch(skip, skip), skip).

