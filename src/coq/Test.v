Require Import Ax Ltg Ltgmonad Interpreter.

Definition sample_boad :=
  Build_board (fun _ _ => ValI) (fun _ _ => Some intl_max).

Definition sample_sti :=
  Build_statei Player0 sample_boad 0.

Definition sample_st :=
  Build_state Player0 sample_boad.

Eval hnf in hnf_cmd sample_sti (nop).
Eval hnf in hnf_cmd sample_sti (zerop).
Eval hnf in hnf_cmd sample_sti (nop >> zerop).
Eval hnf in hnf_cmd sample_sti (nop >> onep).

Definition sample_run_cmd (x : cmdex unit) := run_cmd_aux 0 (hnf_cmd sample_sti x).

Eval hnf in sample_run_cmd (nop).
Eval hnf in sample_run_cmd (zerop).
Eval hnf in sample_run_cmd (nop >> zerop).
Eval hnf in sample_run_cmd (nop >> onep).

Eval hnf in hnf_ai sample_st (ainop).
Eval hnf in hnf_ai sample_st (arun 0 nop).
Eval hnf in hnf_ai sample_st (ainop >> arun 0 nop).
Eval hnf in hnf_ai sample_st (ainop >> arun 0 zerop).
Eval hnf in hnf_ai sample_st (arun 0 nop >> arun 0 zerop).

Definition sample_run_ai x := run_ai Player0 sample_boad x.

Eval hnf in sample_run_ai (ainop).
Eval hnf in sample_run_ai (arun 0 nop).
Eval hnf in sample_run_ai (ainop >> arun 0 nop).
Eval hnf in sample_run_ai (ainop >> arun 0 zerop).
Eval hnf in sample_run_ai (arun 0 zerop >> arun 0 zerop).





