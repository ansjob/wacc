
abs(int, 4, X) :: X == 4.
abs(int, -1, X) :: X == -1.
abs(int, tt, X) :: X == tt.
abs(int, ff, X) :: X == ff.

and(int, tt, tt, Res) :: Res == tt.
and(int, ff, tt, Res) :: Res == ff.
and(int, ff, ff, Res) :: Res == ff.

eq(int, 4, 5, Res) :: Res == ff.
eq(int, 4, 4, Res) :: Res == tt.
leq(int, 4, 5, Res) :: Res == tt.

neg(int, tt, Res) :: Res == ff.

sub(int, 5, 4, Res) :: Res == 1.
add(int, 1, 1, Res) :: Res == 2.
mult(int, 3, 5, Res) :: Res == 15.
div(int, 1, 0, Res) :: Res == cont.
div(int, 1, 2, Res) :: Res == 0.
