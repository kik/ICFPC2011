open Printf
open Ltg
open Ltglib


let kamaboko_solitaire_main =
  let lis = ref [] in
  let l c i = lis := LeftApp(c, i)::!lis in
  let r i c = lis := RightApp(i, c)::!lis in
  (* @0 <- 5000 (1001110001000) *)
  r 0 CardZero;
  l CardSucc 0; (* 1 *)
  l CardDbl 0;  (* 2 *)
  l CardDbl 0;  (* 4 *)
  l CardDbl 0;  (* 8 1000 *)
  l CardSucc 0; (* 9 1001 *)
  l CardDbl 0;  (* 18 *)
  l CardSucc 0; (* 19 10011 *)
  l CardDbl 0;  (* 38 *)
  l CardSucc 0; (* 39 100111 *)
  l CardDbl 0;  (* 78 *)
  r 12 CardZero; l CardGet 12;
  r 13 CardZero; l CardGet 13;
  r 14 CardZero; l CardGet 14;
  l CardDbl 0;  (* 156 *)
  l CardDbl 0;  (* 312 *)
  l CardDbl 0;  (* 624 *)
  l CardSucc 0; (* 625 100110001 *)
  l CardDbl 0;  (* 1250 *)
  l CardDbl 0;  (* 2500 *)
  l CardDbl 0;  (* 5000 *)
  r 2 CardZero;
  l CardGet 2;  (* @2 <- 5000 *)
  l CardSucc 13;
  l CardSucc 14;
  l CardSucc 14;
  (* @12 <- attack 78 0 5000 *)
  l CardAttack 12; r 12 CardZero;
  l CardK 12; l CardS 12;
  r 12 CardGet; r 12 CardZero;
  (* @13 <- attack 79 0 5000 *)
  l CardAttack 13; r 13 CardZero;
  l CardK 13; l CardS 13;
  r 13 CardGet; r 13 CardZero;
  (* @14 <- attack 80 0 5000 *)
  l CardAttack 14; r 14 CardZero;
  l CardK 14; l CardS 14;
  r 14 CardGet; r 14 CardZero;
  (* @1 <- lazy (attack 0 0 10000) *)
  l CardDbl 0; (* 10000 *)
  l CardK 0;   (* K 10000 *)
  r 1 CardZero;
  l CardAttack 1;
  r 1 CardZero;
  l CardK 1;
  l CardS 1; l CardK 1; l CardS 1; r 1 CardGet; r 1 CardZero;
  (* @15 <- zombie 0 @1 *)
  r 15 CardZero;
  l CardZombie 15;
  l CardK 15; l CardS 15; r 15 CardGet;
  l CardK 15; l CardS 15; r 15 CardSucc;
  r 15 CardZero;
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
  l CardZero 1;
  r 1 CardCopy; l CardK 1; l CardS 1;
  l CardK 1; l CardS 1; r 1 CardK; r 1 CardZero;
  (* @2 <- X *)
  l CardZero 2;
  r 2 CardAttack; l CardK 2; l CardS 2;
  l CardK 2; l CardS 2; r 2 CardGet;
  l CardK 2; l CardS 2; r 2 CardSucc; r 2 CardZero;
  (* @2 <- X' *)
  l CardS 2;
  l CardK 2; l CardS 2; r 2 CardGet;
  l CardK 2; l CardS 2; r 2 CardSucc; r 2 CardZero;
  (* @2 <- X'' *)
  l CardS 2;
  l CardK 2; l CardS 2; r 2 CardGet; r 2 CardZero;

  (*
   * X = S (K (lazy (get 1))) Y
   *
   * Y = lazy (zombie 0 @2)
   *
   *)
  l CardZero 0; r 0 CardZero; l CardSucc 0; l CardSucc 0;
  l CardGet 0; l CardK 0;
  l CardZero 1;
  r 1 CardZombie; r 1 CardZero;
  l CardK 1; l CardS 1;
  l CardK 1; l CardS 1; r 1 CardGet; r 1 CardZero;

  l CardZero 2; r 2 CardGet;
  l CardK 2; l CardS 2;
  l CardK 2; l CardS 2; r 2 CardK;
  l CardK 2; l CardS 2; r 2 CardSucc; r 2 CardZero;

  l CardK 2; l CardS 2;
  l CardK 2; l CardS 2; r 2 CardGet;
  l CardK 2; l CardS 2; r 2 CardSucc; r 2 CardZero;

  l CardZero 1; r 1 CardZero ; l CardSucc 1; l CardSucc 1;
  l CardGet 1;

  l CardZero 0; r 0 CardZero; l CardSucc 0;

  for i = 0 to 500 do
    r 1 CardI; l CardSucc 0;
  done;

  List.rev !lis


let _ = run_solitaire_main kamaboko_solitaire_main


