Require Import Ax Ltg Ltgmonad.

Definition lsucc := l CardSucc.
Definition ldbl := l CardDbl.

Definition kamaboko : aicmd unit :=
  arun 0 (
    zero >>
    succ >> (* 1 *)
    dbl >>  (* 2 *)
    dbl >>  (* 4 *)
    dbl >>  (* 8 1000 *)
    succ >> (* 9 1001 *)
    dbl >>  (* 18 *)
    succ >> (* 19 10011 *)
    dbl >>  (* 38 *)
    succ >> (* 39 100111 *)
    dbl >>  (* 78 *)
  ) >>
  arun 12 reg0 >>
  arun 13 reg0 >>
  arun 14 reg0 >>
  arun  0 (
    dbl >> dbl >> dbl >> succ >> dbl >> dbl >> dbl
  ) >>
  arun 2 reg0 >>
  arun 13 succ >>
  arun 14 (succ >> succ) >>
  arun 12 (attackl >> zeror >> rreg0) >>
  arun 13 (attackl >> zeror >> rreg0) >>
  arun 14 (attackl >> zeror >> rreg0) >>
  arun 0  (dbll >> laz) >>
  arun 1  (zero >> attackl >> zeror >> laz >> laplreg0) >>
  arun 15 (zero >> zombiel >> rreg1) >>
