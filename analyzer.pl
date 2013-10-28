/**
	Analyzer:
	Module to perform symbolic execution of a given program in a given domain.

	Notable predicates:
		* analyze_code/4

	Notable data structures:
	The analysis "Map" is a prolog associative structure created using the assoc_* predicates.
	The first key is a control point, and it maps to a tuple A:B,
	where A is again a map from variable to least upper bound value,
	and B is also a map holding arbitrary information used for the analysis
	(such as wether the control point has been visited or not).

	In C++ the type for Map would be something like
		map<int, pair<map<atom, atom>, map<atom, atom> >
*/

/**
	analyze_code(+Domain, +Code, +Vars, -Analysis)

	Performs analysis in the given domain on the provided code.
	The result of the analysis is a map from control points to the possible
	value (in the domain) of every variable.
	(Analysis is a map from control point and variable to value.)

	Vars is a list of all variables occuring in the program (code).
*/
analyze_code(Domain, C, Vars, Map):-
	empty_assoc(E),
	ord_empty(EmptySet),
	generate_all_initial_values(Domain, Vars, States),
	append(_, [_:LastCP], C),
	put_assoc('abnormal termination', E, impossible, InnerMap),
	put_assoc(LastCP, E, E:InnerMap, InitialMap),
	analyze_code_loop(Domain, C, States, EmptySet, InitialMap, Map).

/**
	analyze_step(+Domain, +Config, -NextConfig, +Visited)

	Succeeds when there is a configuration NextConfig
	that is reachable from the current Config, and is not in the
	set of Visited configurations, with respect to a given Domain.
*/
analyze_step(Domain, Config, NextConfig, Visited):-
	step(Domain, Config, NextConfig),
	\+ ord_memberchk(NextConfig, Visited).

/**
	analyze(+Domain, +Configuration, +VisitedList, -VisitedList, +Analysis, -Analysis)

	Performs the analysis on the given configuration,
	updating the visited list and conclusions when necessary.
*/
analyze(_, X, Visited, Visited, Analysis, Analysis):-
	(X = config([], _, _)) ;
	(X = e_config([], _, _)).

analyze(Domain, StartConfig, VisitedIn, VisitedOut, AnalysisIn, AnalysisOut):-
	analyze_instr(Domain, StartConfig, AnalysisIn, TmpAnalysis),
	ord_add_element(VisitedIn, StartConfig, NextVisited),
	findall(NextConfig, analyze_step(Domain, StartConfig, NextConfig, NextVisited), NextConfigs),
	analyze_list(Domain, NextConfigs, NextVisited, VisitedOut, TmpAnalysis, AnalysisOut).

/**
	analyze_list(+Domain, +ConfigurationList, +VisitedList, -VisitedList, +Analysis, -Analysis)

	Analyzes the list of configurations one by one,
	updating the visited list and conclusions when necessary.
*/
analyze_list(_, [], Visited, Visited, Analysis, Analysis).

analyze_list(Domain, [Config | Configs], VisitedIn, VisitedOut, AnalysisIn, AnalysisOut):-
	analyze(Domain, Config, VisitedIn, NextVisited, AnalysisIn, TmpAnalysis),
	analyze_list(Domain, Configs, NextVisited, VisitedOut, TmpAnalysis, AnalysisOut).

/**
	analyze_code_loop(+Domain, +Code, +StateList, +VisitedList, +Analysis, -Analysis)

	Helper predicate to iterate over all possible starting configurations for the
	given program (code).
*/
analyze_code_loop(_, _, [], _, Map, Map).

analyze_code_loop(Domain, C, [State|States], Vis, MapIn, MapOut):-
	analyze(Domain, config(C, [], State), Vis, NextVis, MapIn, NextMap),
	analyze_code_loop(Domain, C, States, NextVis, NextMap, MapOut).

/**
	analyze_instr(+Domain, +Configuration, +Analysis, -Analysis)

	Performs analysis on the next instruction and updates the conclusions.
*/
analyze_instr(_, config([X|_], _, _), Map, Map):-
	X \= _ : _.

analyze_instr(_, e_config([eop:CP], _, _), MapIn, MapOut):-
	get_assoc(CP, MapIn, LubMap:AnalysisIn), 
	put_assoc('abnormal termination', AnalysisIn, maybe, AnalysisOut),
	put_assoc(CP, MapIn, LubMap:AnalysisOut, MapOut).

analyze_instr(_, e_config([eop:CP], _, _), MapIn, MapOut):-
	\+ get_assoc(CP, MapIn, _),
	empty_assoc(E),
	put_assoc('abnormal termination', E, maybe, AnalysisOut),
	put_assoc(CP, MapIn, E:AnalysisOut, MapOut).

analyze_instr(_, e_config(C, _, _), Map, Map):- C \= [eop:_].

analyze_instr(Domain, Config, MapIn, MapOut):-
	Config = config([_:CP|_], _, Store),  
	get_assoc(CP, MapIn, CPInfoBefore:ExtraInfo),
	set_lub(Domain, Store, CPInfoBefore, NewCPInfo),
	put_assoc(visited, ExtraInfo, yes, NewExtraInfo),
	put_assoc(CP, MapIn, NewCPInfo:NewExtraInfo, MapOut).

analyze_instr(_, Config, MapIn, MapOut):-
	Config = config([_:CP|_], _, Store),
	\+ get_assoc(CP, MapIn, _),
	empty_assoc(E),
	put_assoc(visited, E, yes, ExtraInfo),
	put_assoc(CP, MapIn, Store:ExtraInfo, MapOut).

analyze_instr(_, Config, MapIn, MapOut):-
	Config = config([_:CP|_], _, Store),
	empty_assoc(E),
	get_assoc(CP, MapIn, E:X),
	put_assoc(visited, X, yes, ExtraInfo),
	put_assoc(CP, MapIn, Store:ExtraInfo, MapOut).

/**
	set_lub(+Domain, +Map1, +Map2, -ResultMap)

	Computes the least upper bound (lub) between each variable in the two maps.
*/
set_lub(Domain, A, B, Out):-
	assoc_to_list(A, List),
	set_lub_help(Domain, List, B, Out).

/**
	set_lub_help(+Domain, +Map1List, +Map2, -ResultMap)

	Helper predicate to iterate over the first maps variables,
	performing the lub operation one by one.
*/
set_lub_help(_, [], B, B).

set_lub_help(Domain, [Key-Val|T], B, Out):-
	get_assoc(Key, B, BVal),
	lub(Domain, Val, BVal, LubVal),
	put_assoc(Key, B, LubVal, Tmp),
	set_lub_help(Domain, T, Tmp, Out).

/**
	generate_all_initial_values(+Domain, +VariableList, -StateList)

	Generates all possible assignments of variables in the given domain,
	and return the result as the list of such states.
*/
generate_all_initial_values(Domain, Vars, Configs):-
	length(Vars, L),
	all_values(Domain, Values),
	findall(X, (
		length(X, L), all_members(X, Values)
	), Permuts),
	make_maps(Vars, Permuts, Configs).

/**
	make_maps(+VariableList, +AssignmentList, -StateList)

	Converts the implicit assignments into actual states,
	ready to be inserted in a real configuration.
*/
make_maps(_, [], []).

make_maps(Vars, [Perm|Perms], [State|States]):-
	make_map(Vars, Perm, State),
	make_maps(Vars, Perms, States).

/**
	make_map(+KeyList, +ValueList, -State)

	Helper predicate for make_maps to convert a single
	implicit assignment into an actual state.

	KeyList is the list of variables.
	ValueList is the values to be assigned to each variable.
*/
make_map([], [], E):-
	empty_assoc(E).

make_map([K|Keys], [V|Vals], State):-
	make_map(Keys, Vals, Map),
	put_assoc(K, Map, V, State).

/**
	all_members(+List, +Values)

	Unifies each element in List to a member in Values.
*/
all_members([], _).

all_members([H|T], Members):-
	member(H, Members),
	all_members(T, Members).
