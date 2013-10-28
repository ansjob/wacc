
abort_handler(_) :-
	nl, throw(abort).

main:-
	on_signal(int, _, abort_handler),
	current_prolog_flag(argv, Argv),
	length(Argv, Argc),
	catch(main(Argc, Argv), E,
		(E = abort ->
			(format("aborted by signal\n"));
			(print_message(error, E)),
		!, fail)
	).

main(2, Argv):-
	!,
	nth0(1, Argv, File),
	print_file_details(File),
	run_lexer(File, Tokens),
	run_parser(Tokens, AST),
	add_control_points(AST, ASTCP),
	run_compiler(ASTCP, Code),
	execute(Code, FinalConfig),
	config_to_format(FinalConfig, EndState),
	format("State at termination: ~w\n", [EndState]).

main(1, _):-
	!,
	format("no input file specified\n"),
	fail.

main(_, _):-
	format("invalid number of arguments given\n"),
	!,
	fail.

execute(Code, FinalConfig) :-
	format("Running...\n"),
	run_code(int, Code, FinalConfig),
	!.

execute(_, _) :-
	format("runtime error\n"),
	!,
	fail.

run_compiler(AST, Code) :-
	format("Compiling...\n"),
	compile(AST, Code),
	format("~w\n", [Code]),
	!.

run_compiler(_, _) :-
	format("error while compiling\n"),
	!,
	fail.

run_parser(Tokens, AST) :-
	format("Parsing...\n"),
	phrase(stmt(AST), Tokens),
	format("~w\n", [AST]),
	!.

run_parser(_, _) :-
	format("error while parsing\n"),
	!,
	fail.

run_lexer(File, Tokens) :-
	format("Lexing...\n"),
	phrase_from_file(lex(Tokens), File),
	!,
	append(_, [X], Tokens),
	functor(X, Name, _),
	(Name == error -> (
		X = error([BadToken | _]),
		format("invalid syntax '~c'\n", [BadToken]),
		!,
		fail
	);(
		format("~w\n", [Tokens]),
		!
	)).

run_lexer(_, _) :-
	format("unknown error while lexing\n"),
	!,
	fail.

print_file_details(File) :-
	catch(read_file(File, C), error(F, _), (functor(F, E, _), format("unable to open '~w': ~w\n", [File, E]), fail)),
	atom_codes(L, C),
	format("Working on '~w':\n---\n~w\n---\n", [File, L]),
	!.

read_file(File, Content) :-
	open(File, read, Stream, [buffer(full)]),
	read_lines(Stream, [], Content),
	close(Stream),
	!.

read_lines(Stream, Lines, Lines) :-
	at_end_of_stream(Stream).

read_lines(Stream, Acc, Lines) :-
	\+ at_end_of_stream(Stream),
	read_line_to_codes(Stream, Line, _),
	read_lines(Stream, Acc, Tmp),
	append(Line, Tmp, Lines).
