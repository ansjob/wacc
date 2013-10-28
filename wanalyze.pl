/**
	Wanalyze - the While analysis tool
	Contains the bootstrapping predicates for running the
	analysis on a given while program.
  
	Notable predicates:
		* wanalyze_main
*/


/**
	wanalyze_main()

	wanalyze_main is the goal executed by the wanalyze binary.
	It will compile and analyze the program given on the command line.
*/
wanalyze_main:-
	on_signal(int, _, abort_handler),
	current_prolog_flag(argv, Argv),
	length(Argv, Argc),
	catch(wanalyze_main(Argc, Argv), E,
		(E = abort ->
			(format("aborted by signal\n"));
			(print_message(error, E)),
		!, fail)
	).

wanalyze_main(2, [Prog, File]):-
	!,
	wanalyze_main(3, [Prog, sign, File]).

wanalyze_main(3, Argv):-
	!,
	nth0(1, Argv, Domain),
	nth0(2, Argv, File),
	run_lexer(File, Tokens),
	run_parser(Tokens, AST),
	add_control_points(AST, ASTCP),
	run_compiler(ASTCP, Code),
	append(_, [eop:LastCP], Code),
	extract_vars(AST, Vars),
	run_analyzer(Domain, Code, Vars, Map),
	maps_to_strings(Map, LastCP, StringMap),
	print_code(ASTCP, StringMap, PrintThis),
	atom_codes(Atom, PrintThis),
	print(Atom), nl.

wanalyze_main(1, _):-
	!,
	format("no input file specified\n"),
	fail.

wanalyze_main(_, _):-
	format("invalid number of arguments given\n"),
	!,
	fail.


/**
	run_analyzer(+Domain, +Code, +Vars, -Map)

	runs the analyze_code predicate,
	and prints an error if it fails. 
*/
run_analyzer(Domain, Code, Vars, Map):-
	format("Analyzing...\n"),
	analyze_code(Domain, Code, Vars, Map),
	!.

run_analyzer(_, _, _, _):-
	format("error during symbolic execution\n"),
	!, fail.

