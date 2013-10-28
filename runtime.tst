empty_assoc(S), step(int, config([push(5)], [], S), NextConfig)
	:: NextConfig = config([], [5], S).

empty_assoc(S), step(int, config([add], [5, 7], S), NextConfig)
	:: NextConfig = config([], [12], S).

empty_assoc(S), step(int, config([sub], [5, 7], S), NextConfig)
	:: NextConfig = config([], [-2], S).

empty_assoc(S), step(int, config([mult], [5, 7], S), NextConfig)
	:: NextConfig = config([], [35], S).

empty_assoc(S), step(int, config([true], [7], S), NextConfig)
	:: NextConfig = config([], [tt, 7], S).

empty_assoc(S), step(int, config([false], [7], S), NextConfig)
	:: NextConfig = config([], [ff, 7], S).

empty_assoc(S), step(int, config([eq], [7, 7], S), NextConfig)
	:: NextConfig = config([], [tt], S).

empty_assoc(S), step(int, config([eq], [7, 5], S), NextConfig)
	:: NextConfig = config([], [ff], S).

empty_assoc(S), step(int, config([eq], [7, 5], S), NextConfig)
	, NextConfig = config([], [tt], S) :: f.

empty_assoc(S), step(int, config([eq], [7, 7], X), config([], [ff], X)) :: f.

empty_assoc(S), step(int, config([le], [7, 7], X), config([], [tt], X)) :: s.
empty_assoc(S), step(int, config([le], [7, 7], X), config([], [ff], X)) :: f.
empty_assoc(S), step(int, config([le], [7, -3], X), config([], [ff], X)) :: s.
empty_assoc(S), step(int, config([and], [ff, ff], X), config([], [ff], X)) :: s.
empty_assoc(S), step(int, config([and], [ff, tt], X), config([], [ff], X)) :: s.
empty_assoc(S), step(int, config([and], [tt, ff], X), config([], [ff], X)) :: s.
empty_assoc(S), step(int, config([and], [tt, tt], X), config([], [tt], X)) :: s.

empty_assoc(S), step(int, config([neg], [tt], X), config([], [ff], X)) :: s.
empty_assoc(S), step(int, config([neg], [ff], X), config([], [tt], X)) :: s.

empty_assoc(E), put_assoc(x, E, 4711, State),
	step(int, config([fetch(x)], Stack, State), NextConfig)
	:: NextConfig = config([], [4711], State).

empty_assoc(E), step(int, config([store(x):1], [7], E), NextConfig),
	NextConfig = config([], [], Assoc),
	get_assoc(x, Assoc, X):: X = 7.

empty_assoc(E), step(int, config([branch([noop:2], _):1], [tt], E), NextConfig)
	:: NextConfig = config([noop:2], [], E).

empty_assoc(E), step(int, config([branch(_, [noop:2]):1], [ff], E), NextConfig)
	:: NextConfig = config([noop:2], [], E).

empty_assoc(E), step(int, config([div], [10, 7], E), NextConfig)
	:: NextConfig = config([], [1], E).

empty_assoc(E), step(int, config([div], [10, 0], E), NextConfig)
	:: NextConfig = config([], [cont], E).

empty_assoc(E), step(int, config([store(x):1], [cont], E), NextConfig)
	:: NextConfig = e_config([], [], E).

empty_assoc(E), step(int, e_config([catch([noop:2]):1], S, E), NextConfig)
	:: NextConfig = config([noop:2], S, E).

empty_assoc(E), step(int, config([catch([noop:2]):1, add], S, E), NextConfig)
	:: NextConfig = config([add], S, E).

empty_assoc(E), step(int, config([catch([noop:2]):1, add], S, E), NextConfig)
	:: NextConfig = config([add], S, E).

empty_assoc(E), step(int, e_config([add], [cont, 4], E), NextConfig)
	:: NextConfig = e_config([], [cont], E).

empty_assoc(E), step(int, e_config([sub], [cont, 4], E), NextConfig)
	:: NextConfig = e_config([], [cont], E).

empty_assoc(E), step(int, e_config([mult], [cont, 4], E), NextConfig)
	:: NextConfig = e_config([], [cont], E).

empty_assoc(E), step(int, e_config([div], [cont, 4], E), NextConfig)
	:: NextConfig = e_config([], [cont], E).

empty_assoc(E), step(int, e_config([le], [cont, 4], E), NextConfig)
	:: NextConfig = e_config([], [cont], E).

empty_assoc(E), step(int, e_config([eq], [cont, 4], E), NextConfig)
	:: NextConfig = e_config([], [cont], E).

empty_assoc(E), step(int, e_config([and], [cont, 4], E), NextConfig)
	:: NextConfig = e_config([], [cont], E).

empty_assoc(E), step(int, e_config([neg], [cont], E), NextConfig)
	:: NextConfig = e_config([], [cont], E).

empty_assoc(E), step(int, e_config([store(x):1, noop:2], [cont], E), NextConfig)
	:: NextConfig = e_config([noop:2], [], E).

empty_assoc(E), step(int, e_config([branch(_, _):1, noop:2], [cont], E), NextConfig)
	:: NextConfig = e_config([noop:2], [], E).

empty_assoc(E), step(int, e_config([loop(_, _):1, noop:2], [cont], E), NextConfig)
	:: NextConfig == e_config([noop:2], [], E).

empty_assoc(E), step(int, config([try([noop:2]):1 | C], [], E), NextConfig)
	:: NextConfig = config([noop:2 | C], [], E).

empty_assoc(E), step(int, e_config([try([noop:2]):1, catch(_):1 | C], [], E), NextConfig)
	:: NextConfig = e_config(C, [], E).

empty_assoc(E), step(int, e_config([true | C], [], E), NextConfig)
	:: NextConfig = e_config(C, [cont], E).

empty_assoc(E), step(int, e_config([fetch(x) | C], [], E), NextConfig)
	:: NextConfig = e_config(C, [cont], E).

empty_assoc(E), step(int, e_config([push(43) | C], [], E), NextConfig)
	:: NextConfig = e_config(C, [cont], E).

empty_assoc(E), step(int, e_config([noop:1 | C], [], E), NextConfig)
	:: NextConfig = e_config(C, [], E).

empty_assoc(E), step(int, config([loop([true], [noop:2]):1], [], E), NextConfig)
	:: NextConfig = config(
		[true, branch(
			[noop:2, loop([true], [noop:2]):1], [noop:0]):1], [], E).

empty_assoc(E), run_code(int, [noop:1, noop:2], FinalConfig)
	:: FinalConfig = config([], [], E).

empty_assoc(E), run_code(int, [push(5), push(42), add, store(myvariable):1], FinalConfig),
	FinalConfig = config([], [], M),
	get_assoc(myvariable, M, X)
	:: X = 47.
