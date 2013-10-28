/**
	The Code Printer module is a module to format analysis output into a string
	for printing the analysis.

	Notable predicates:
	 - print_code/3
*/


/**
	print_code(+AbstractSyntaxTree, +AnalysisMap, -String)
	prints the code represented by the AbstractSyntaxTree into
	a String.
*/
print_code(AST, Assoc, Str):-
	print_code(AST, 0, Assoc, Str).

message_line(_, CP, Assoc, []):-
	get_assoc(CP, Assoc, []).

message_line(Indent, CP, Assoc, L1):-
	get_assoc(CP, Assoc, Msg),
	indents(Indent, Indents),
	append([Indents, Msg, "\n"], L1).

message_line(_, CP, Assoc, []):-
	\+ get_assoc(CP, Assoc, _).


print_code(skip : CP, Indent, Assoc, Str):-
	message_line(Indent, CP, Assoc, L1),
	indents(Indent, Indents),
	append(Indents, "skip", L2),
	append(L1, L2, Str).

print_code(S1 ; end_of_program:CP, Indent, Assoc, Str):-
	print_code(S1, Indent, Assoc, Str1),
	print_code(end_of_program:CP, Indent, Assoc, Str2),
	append([Str1, "\n", Str2], Str).

print_code(S1 ; S2, Indent, Assoc, Str):-
	print_code(S1, Indent, Assoc, Str1),
	print_code(S2, Indent, Assoc, Str2),
	append([Str1, ";\n", Str2], Str).


print_code(cond(Guard, IfBody, ElseBody) : CP, Indent, Assoc, Str):-
	indents(Indent, Indents),
	message_line(Indent, CP, Assoc, Msg),
	print_exp(Guard, GuardStr),
	NextIndent is Indent + 1,!,
	print_code(IfBody, NextIndent, Assoc, IfBodyStr),
	print_code(ElseBody, NextIndent, Assoc, ElseBodyStr),
	append([Msg, Indents, "if (", GuardStr, ") then (\n", 
				IfBodyStr, 
			"\n", Indents, ") else (\n",
				ElseBodyStr,
			"\n", Indents, ")"
			],
			Str).

print_code(ass(var(X), Exp) : CP, Indent, Assoc, Str):-
	indents(Indent, Indents),
	message_line(Indent, CP, Assoc, Msg),
	print_exp(Exp, ExpStr),
	atom_codes(X, XStr),
	append([
		Msg,
		Indents, XStr, " := ", ExpStr
	], Str).

print_code(trycatch(TryBody, CatchBody) : CP, Indent, Assoc, Str):-
	indents(Indent, Indents),
	message_line(Indent, CP, Assoc, Msg),
	NextIndent = Indent + 1,
	print_code(TryBody, NextIndent, Assoc, TryStr),
	print_code(CatchBody, NextIndent, Assoc, CatchStr),
	append([
		Msg, 
		Indents, "try (\n",
		TryStr, "\n",
		Indents, ") catch (\n",
		CatchStr, "\n",
		Indents, ")"], Str).

print_code( while(Guard, LoopBody) : CP, Indent, Assoc, Str):-
	indents(Indent, Indents),
	message_line(Indent, CP, Assoc, Msg),
	NextIndent is Indent + 1,
	print_exp(Guard, GuardStr),
	print_code(LoopBody, NextIndent, Assoc, LoopStr),
	append([
		Msg,
		Indents, "while (", GuardStr, ") do (\n",
		LoopStr, "\n",
		")"
	], Str).

print_code( end_of_program:CP, I, Assoc, Str):-
	message_line(I, CP, Assoc, Str).

print_exp(true, "true").
print_exp(false, "false").
print_exp(var(X), Str):-
	atom_codes(X, Str).

print_exp(A = B, Str):-
	print_exp(A, AStr),
	print_exp(B, BStr),
	append([
		AStr, " = ", BStr
	], Str).

print_exp(N, Str):- integer(N), atom_codes(N, Str).

print_exp(A ^ B, Str):-
	print_exp(A, AStr),
	print_exp(B, BStr),
	append([AStr, " ^ ", BStr], Str).

print_exp(A1 + A2, Str):-
	print_exp(A1, A1Str),
	print_exp(A2, A2Str),
	append([A1Str, " + ", A2Str], Str).

print_exp(A1 * A2, Str):-
	print_exp(A1, A1Str),
	print_exp(A2, A2Str),
	append(["(", A1Str, ") * (", A2Str, ")"], Str).

print_exp(A1 - A2, Str):-
	print_exp(A1, A1Str),
	print_exp(A2, A2Str),
	append([A1Str, " - ", A2Str], Str).

print_exp(A1 / A2, Str):-
	print_exp(A1, A1Str),
	print_exp(A2, A2Str),
	append(["(", A1Str, ") / (", A2Str, ")"], Str).

print_exp('!'(Exp), Str):-
	print_exp(Exp, EStr),
	append([ "!(", EStr, ")"], Str).

print_exp('<='(A1, A2), Str):-
	print_exp(A1, A1Str),
	print_exp(A2, A2Str),
	append([A1Str, " <= ", A2Str], Str).

indents(N, L):-
	indents(N, [], L).

indents(0, Final, Final):-!.
indents(N, Acc, Final):-
	N2 is N-1,
	% 9 is the ASCII code for tab
	indents(N2, [9|Acc], Final).
