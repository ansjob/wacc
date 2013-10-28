compile(skip:1 ; skip:2, C)
	:: C = [noop:1, noop:2].

phrase(stmt(S), [var(x), =, 5, +, 7]), add_control_points(S, Sp), compile(Sp, C)
	:: C = [push(7), push(5), add, store(x):_, eop:_].

phrase(stmt(S), [var(x), =, 5, *, 3, -, 2]), add_control_points(S, Sp), compile(Sp, C)
	:: C = [push(2), push(3), push(5), mult, sub | _].

phrase(stmt(S), [var(_), =, var(X)]), add_control_points(S, Sp), compile(Sp, C)
	:: C = [fetch(X), store(_):_, eop:_].

phrase(stmt(S), [while, l_paren, 5, '<=', 3, r_paren, ^, !, l_paren, false, r_paren, do, skip]),
	add_control_points(S, Sp),
	compile(Sp, C)
	:: C = [loop([false, neg, push(3), push(5), le, and], [noop:_]):_ , eop:_].

phrase(stmt(S), [while, true, ^, var(x), eq, 3, do, skip]),
	add_control_points(S, Sp),
	compile(Sp, C)
	:: C = [loop([push(3), fetch(x), eq, true, and], [noop:_]):_, eop:_].

compile(ass(var(y), 2 + 4):_, C)
	:: C = [push(4), push(2), add, store(y):_].

compile(cond(true, skip:_, skip:_):_, C)
	:: C = [true, branch([noop:_], [noop:_]):_].

compile(while(true, skip:_):_, C)
	:: C = [loop([true], [noop:_]):_].

compile((((5) / (0))), C)
	:: C = [push(0), push(5), div].

phrase(stmt(S), [try, var(z), =, 7, catch, l_paren, skip, semicolon, skip, r_paren]),
	add_control_points(S, Sp),
	compile(Sp, C)
	:: C = [try([push(7), store(z):_]):_, catch([noop:_, noop:_]):_, eop:_].
