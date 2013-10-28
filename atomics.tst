% Tests for the variable name grammar

phrase(variable(Var), "x"), Var=x :: s.
phrase(variable(Var), "y"), Var=y :: s.
phrase(variable(Var), "angle"), Var=angle :: s.
phrase(variable(Var), "skip") :: f.
phrase(variable(Var), "if") :: f.
phrase(variable(Var), "while") :: f.
phrase(variable(Var), "do") :: f.
phrase(variable(Var), "try") :: f.
phrase(variable(Var), "catch") :: f.

phrase(variable(_), "5x") :: f.
phrase(variable(_), "") :: f.

% White space tests
phrase(white_space, "") :: s.
phrase(white_space, "   ") :: s.
phrase(white_space, "	 	  	") :: s.
