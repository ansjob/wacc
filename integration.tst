%Integration tests for the while compile chain


%Step 1 and 2, lexer and parser tests below
phrase(lex(L), "while true do skip"), phrase(stmt(S), L)
	:: S = while(true, skip).

phrase(lex(L), "while 5<=x^x=y do x:=x+5 ; y:=3"), phrase(stmt(S), L)
	:: S = 
		(
		while((5<=var(x)) ^ (var(x)=var(y)), 
			(ass(var(x), var(x) + 5 ))
		);  
		ass(var(y), 3)
		).
