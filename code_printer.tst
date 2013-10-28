
empty_assoc(E), print_code(skip : 5, E, Str) ::
	Str = "skip".

empty_assoc(E), put_assoc(1, E, "here there be a message", Assoc),
	print_code(skip : 1, Assoc, Str) ::
	Str == "here there be a message\nskip".

indents(3, L) :: L = "\t\t\t".

empty_assoc(E), print_code( (skip : 5) ; skip : 6 , E, Str) ::
	Str = "skip;\nskip".

empty_assoc(E), put_assoc(5, E, "msg", Assoc), 
	print_code( (skip : 5) ; skip : 6 , Assoc, Str) 
	::
	Str = "msg\nskip;\nskip".

empty_assoc(E), put_assoc(6, E, "msg", Assoc), 
	print_code( (skip : 5) ; skip : 6 , Assoc, Str) 
	::
	Str = "skip;\nmsg\nskip".

empty_assoc(E), 
	put_assoc(1, E, "msg", AssocTmp), 
	put_assoc(3, AssocTmp, "msg2 hello", Assoc),
	print_code( cond(true, skip : 3, skip : 4) : 1 , Assoc, Str) 
	::
	Str ==
"msg
if (true) then (
	msg2 hello
	skip
) else (
	skip
)".

empty_assoc(E),
	ControlPoint = 42,
	put_assoc(ControlPoint, E, "mymessage", Assoc),
	print_code( ass(var(x), 5 + var(y)) : ControlPoint, Assoc, Str)
	:: 
	Str ==
"mymessage
x := 5 + y".

empty_assoc(E),
	CP = 512,
	put_assoc(CP, E, "msg 123", Assoc),
	print_code( trycatch(skip : 2, skip : 3) : CP, Assoc, Str)
	::
	Str ==
"msg 123
try (
	skip
) catch (
	skip
)".

print_exp(false, Str) :: Str == "false".

print_exp('!'(false), Str) :: Str == "!(false)".

print_exp('<='(5, 3), Str) :: Str == "5 <= 3".

print_exp(true ^ false, Str) :: Str == "true ^ false".

print_exp(true ^ '<='(5, 3), Str) :: Str = "true ^ 5 <= 3".

empty_assoc(E),
	CP = 512,
	put_assoc(CP, E, "msg 123", Assoc),
	Stm = while(false, skip : 2) : CP,
	print_code( Stm, Assoc, Str)
	::
	Str ==
"msg 123
while (false) do (
	skip
)".


% Assignment, nestling test
empty_assoc(E),
	Stm = while(var(x) = 5, cond(true, skip : 3, skip : 4) : 2) : 1,
	print_code(Stm, E, Str)
	::
	Str ==
"while (x = 5) do (
	if (true) then (
		skip
	) else (
		skip
	)
)".

print_exp(5 + var(x), Str) :: Str == "5 + x".

% Integration test!
phrase(lex(L), "while (true ^ 5 <= 3) do x := x + 1"), 
	phrase(stmt(S), L),
	add_control_points(S, SP),
	empty_assoc(Empty),
	print_code(SP, Empty, Str),
	phrase(lex(Lp), Str),
	phrase(stmt(Sp), Lp)
	:: Sp == S.
