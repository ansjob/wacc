extract_vars(skip, Vars) :: Vars = [].

extract_vars(ass(var(x), var(y)), Vars) :: 
	memberchk(x, Vars),
	memberchk(y, Vars).

extract_vars(ass(var(x), 7), Vars) :: 
	memberchk(x, Vars).

extract_vars(ass(var(x), 7 + var(y)), Vars) :: 
	memberchk(x, Vars),
	memberchk(y, Vars).

extract_vars(ass(var(x), 7 - var(y) / var(z) * var(x)), Vars), 
	findall(X, nth0(X, Vars, x), T),
	length(T, C)
	::
	C = 1.

extract_vars(ass(var(x), 7 - var(y) / var(z) * var(x)), Vars)::
	memberchk(y, Vars).

extract_vars(ass(var(x), 7 - var(y) / var(z) * var(x)), Vars)::
	memberchk(z, Vars).

extract_vars(cond( '<='(var(x) , var(y)), skip, skip), Vars) ::
	memberchk(x, Vars).

extract_vars(cond(true, skip, skip), Vars) ::
	Vars = [].

extract_vars(cond(var(x) = var(y) ^ !('<='(var(w), var(z))), skip, skip), Vars) ::
	memberchk(x, Vars),
	memberchk(y, Vars),
	memberchk(w, Vars),
	memberchk(z, Vars).

extract_vars(trycatch(ass(var(x), 5), ass(var(y), 3)), Vars) ::
	memberchk(x, Vars),
	memberchk(y, Vars).

extract_vars(while(var(z) = var(w), ass(var(x), 5)), Vars) ::
	memberchk(z, Vars),
	memberchk(x, Vars),
	memberchk(w, Vars).

analyze_code(sign, [push(5), store(x):1, push(4), store(y):2], [x,y], Map),
	get_assoc(2, Map, ControlPointInfo:_),
	get_assoc(x, ControlPointInfo, Val) ::
	Val == pos.

analyze_code(sign, [fetch(y), fetch(z), add, store(x):1, noop:2], [x,y, z], Map),
	get_assoc(2, Map, ControlPointInfo:_),
	get_assoc(x, ControlPointInfo, Val) ::
	Val == z.

analyze_code(sign, [fetch(x), push(0), le, branch([push(5), store(y):2], [push(-5), store(y):3]):1, noop:4], [x,y], Map),
	get_assoc(2, Map, ControlPointInfo:_),
	get_assoc(x, ControlPointInfo, Val) ::
	Val == non_neg.

empty_assoc(E),
	ConfigIn = config([push(5), store(x):1], [], E),
	analyze_instr(sign, ConfigIn, E, MapOut)
	::
	MapOut == E.

empty_assoc(E),
	put_assoc(x, E, pos, Memory),
	put_assoc(1, E, Memory, MapIn),
	ConfigIn = config([store(y) : 2], [neg], Memory),
	analyze_instr(sign, ConfigIn, MapIn, MapOut) ::
	get_assoc(2, MapOut, CP2Info:_),
	get_assoc(x, CP2Info, Val),
	Val == pos.

empty_assoc(E),
	put_assoc(x, E, pos, Memory),
	put_assoc(1, E, Memory:E, MapIn),
	put_assoc(x, E, zero, CurMemory),
	ConfigIn = config([store(z):1], [_], CurMemory),
	analyze_instr(sign, ConfigIn, MapIn, MapOut) ::
	get_assoc(1, MapOut, CPInfo:_),
	get_assoc(x, CPInfo, XVal),
	XVal == non_neg.

generate_all_initial_values(sign, [x], InitialConfigs),
	length(InitialConfigs, Len)
	::
	Len == 3.

generate_all_initial_values(sign, [x, y, z], InitialConfigs),
	length(InitialConfigs, Len)
	::
	Len == 27.

make_map([1,2,3], [5,6,7], Map),
	get_assoc(1, Map, Val)
	::
	Val == 5.

make_map([1,2,3], [5,6,7], Map),
	get_assoc(2, Map, Val)
	::
	Val == 6.

make_maps([x], [[pos], [zero], [neg]], States),
	nth0(2, States, Map)
	::
	get_assoc(x, Map, neg).

make_maps([x], [[pos], [zero], [neg]], States),
	nth0(1, States, Map)
	::
	get_assoc(x, Map, zero).

make_maps([x], [[pos], [zero], [neg]], States),
	nth0(0, States, Map)
	::
	get_assoc(x, Map, pos).


CP = 5, empty_assoc(E), E_Config = e_config([eop:CP], [], E),
analyze_instr(sign, E_Config, E, AnalysisOut) :: 
	get_assoc(CP, AnalysisOut, _:FinalAnalysis),
	get_assoc('abnormal termination', FinalAnalysis, Value),
	Value == maybe.
