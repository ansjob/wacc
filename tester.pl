%A main file that runs all the tests

:-[autotest].
:-[grammar].
:-[lexer].
:-[compiler].
:-[runtime].
:-[analyzer].
:-[code_printer].
:-[variable_extractor].
:-[domains].
:-[domain_int].
:-[domain_sign].
:-[domain_oddeven].

test_main:-
	catch(
	(
		'$run_test'('grammar.tst'),
		'$run_test'('lexer.tst'),
		'$run_test'('compiler.tst'),
		'$run_test'('runtime.tst'),
		'$run_test'('integration.tst'),
		'$run_test'('code_printer.tst'),
		'$run_test'('domain_int.tst'),
		'$run_test'('analyzer.tst'),
		format("Tests run"), nl
	), 
	halt, halt).
