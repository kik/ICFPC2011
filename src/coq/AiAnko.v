Require Import LtgAll.

Definition mk_const_tbl_1 : aicmd unit :=
  let ds := dbll; succl in
  arun 0 (
    zerop; succl; (* 1 *)
    ds;  (* 3 *)
    ds;  (* 7 *)
    ds;  (* 15 *)
    ds;  (* 31 *)
    dbll (* 62 *)
  );
  arun 124 reg0p;
  arun 0 dbll; (* 124 *)
  arun 248 reg0p;
  arun 0 dbll; (* 248 *)
  arun 252 reg0p;
  arun 0 (succl; succl; succl; succl); (* 252 *)
  arun 255 reg0p;
  arun 0 (succl; succl; succl);
  (*
   * s[255] = 252
   * s[252] = 248
   * s[248] = 124
   * s[124] = 62
   *
   *)
  ret tt.

Definition anko : aicmd unit :=
  mk_const_tbl_1.

Definition anko_main := run_ai_main anko.

