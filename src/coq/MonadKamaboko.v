Require Import Arith Ax Ltg Ltgmonad Ltgmonadlib Interpreter.

Open Scope intl_scope.
Open Scope monad_scope.

Let n500 : nat := 500.

Definition kamaboko : aicmd unit :=
  arun 0 (
    zerop >>
    succl >> (* 1 *)
    dbll  >> (* 2 *)
    dbll  >> (* 4 *)
    dbll  >> (* 8 1000 *)
    succl >> (* 9 1001 *)
    dbll  >> (* 18 *)
    succl >> (* 19 10011 *)
    dbll  >> (* 38 *)
    succl >> (* 39 100111 *)
    dbll     (* 78 *)
  ) >>
  arun 12 reg0p >>
  arun 13 reg0p >>
  arun 14 reg0p >>
  arun  0 (
    dbll >> dbll >> dbll >> succl >> dbll >> dbll >> dbll
  ) >>
  arun 2 reg0p >>
  arun 13 succl >>
  arun 14 (succl >> succl) >>
  arun 12 (attackl >> zeror >> reg0r) >>
  arun 13 (attackl >> zeror >> reg0r) >>
  arun 14 (attackl >> zeror >> reg0r) >>
  (* @1 <- lazy (attack 0 0 10000) *)
  arun 0  (dbll >> lazl) >>
  arun 1  (zerop >> attackl >> zeror >> lazl >> lapp >> reg0r) >>
  (* @15 <- zombie 0 @1 *)
  arun 15 (zerop >> zombiel >> reg1r) >>
  (* @2 <- lazy (attack (copy 0) (copy 0) 10000) *)
  (*
   * X  = lazy (attack (copy 0))
   *    = S(K(attack))(Y)
   * X' = lazy (attack (copy 0) (copy 0))
   *    = S(K(X))(Y)
   * X''= S(K(X'))(K(10000))
   * Y  = lazy (copy 0) = S(K(copy))(K(0))
   *
   *)
  (* @1 <- Y *)
  arun 1  (copyp >> lazl >> lapp >> laz0r) >>
  (* @2 <- X *)
  arun 2  (attackp >> lazl >> lapp >> reg1r) >>
  (* @2 <- X' *)
  arun 2  (lapp >> reg1r >> lapp >> reg0r) >>
  arun 0  (zerop >> succl >> succl >> getl >> lazl) >>
  arun 1  (zombiep >> zeror >> lazl >> lapp >> reg0r) >>
  arun 2  (getp >> lazl >> lapp >> laz1r >> lseq >> reg1r) >>
  arun 1  (onep >> succl >> getl) >>
  arun 0  (onep) >>
  iter_nat n500 (aicmd unit) (fun x =>
    x >>
    arun 1 ir >>
    arun 0 succl) ainop.

Definition kamaboko_main := run_ai_main kamaboko.
