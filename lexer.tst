phrase(lex(L), "skip ;"), L = [skip, semicolon] :: s.
phrase(lex(L), " skip	;  "), L = [skip, semicolon] :: s.
phrase(lex(L), "skip ; x ; angle "), L = [skip, semicolon, var(x), semicolon, var(angle)] :: s.
phrase(lex(L), "//Stupid comment"), append(_, [Token], L) :: Token = error(_).

phrase(lex(L), "try x := 5 catch x := 33"), L = [try, var(x), =, 5, catch, var(x), =, 33] :: s.
phrase(lex(L), "try try try 5 5") :: L = [ try, try, try, 5, 5].
phrase(lex(L), "while do if then else") :: L = [while, do, if, then, else].
phrase(lex(L), "	( while do (	 ) 	") :: L = [ l_paren, while, do, l_paren, r_paren].
phrase(lex(L), "+ - * /	 <=") :: L = [+, -, *, /, <=].
phrase(lex(L), "! ^") :: L = [!, ^].
phrase(lex(L), "true ^ false  	") :: L = [true, ^, false].
phrase(lex(L), "(5+5)*3") :: L = [l_paren, 5, +, 5, r_paren, *, 3].

phrase(lex(L), "try") , L = [var(t), var(r), var(y)] :: f.

phrase(lex(L), "iftrue:=5elseskip") :: L = [var(iftrue), =, 5, var(elseskip)].

phrase(lex(L), "while (true) do #this is a comment\n # \nskip\n") :: L == [while, l_paren, true, r_paren, do, skip].
