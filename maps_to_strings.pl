/**
	Maps To Strings

	Module to turn a map of maps into a map of strings.

	Notable predicates:
		* maps_to_strings/2
*/


/**
	maps_to_strings(+Maps, +FinalControlPoint, -StringMap)

	Will convert a map of maps into a map of strings
	where each string is a printable representation of the original map.
*/
maps_to_strings(_, 0, _):- !.

maps_to_strings(Map, CP, MapOut):-
	\+ get_assoc(CP, Map, _),
	String = "{ code=dead, }",
	PrevCP is CP -1,
	maps_to_strings(Map, PrevCP, TmpMap),
	put_assoc(CP, TmpMap, String, MapOut).

maps_to_strings(Map, CP, MapOut):-
	empty_assoc(E),
	get_assoc(CP, Map, E:Extra),
	(get_assoc(visited, Extra, yes) -> 
		(put_assoc(visited, NextExtra, yes, Extra)) ; 
		(put_assoc(code, Extra, dead, NextExtra))),
	PrevCP is CP - 1,
	map_to_string(NextExtra, String),
	maps_to_strings(Map, PrevCP, TmpMap),
	put_assoc(CP, TmpMap, String, MapOut).

maps_to_strings(Map, CP, MapOut):-
	get_assoc(CP, Map, Store:Extra),
	map_to_string(Store, StoreString),
	(get_assoc(visited, Extra, yes) -> 
		(put_assoc(visited, NextExtra, yes, Extra)) ; 
		(put_assoc(code, Extra, dead, NextExtra))),
	map_to_string(NextExtra, ExtraString),
	append([StoreString, ExtraString], String),
	PrevCP is CP -1,
	maps_to_strings(Map, PrevCP, X),
	put_assoc(CP, X, String, MapOut).

map_to_string(E, ""):- empty_assoc(E), !.

map_to_string(Map, String):-
	assoc_to_list(Map, List),
	map_to_string(List, "{ ", String).

map_to_string([], In, Out):-
	append(In, " }", Out).

map_to_string([K-V|T], In, Out):-
	atom_codes(K, KC),
	atom_codes(V, VC),
	append([In, KC, "=", VC, ", "], Tmp),
	map_to_string(T, Tmp, Out).

