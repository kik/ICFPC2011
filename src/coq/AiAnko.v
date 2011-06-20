Require Import Bool LtgAll.


Section Anko.
  Let me : aicmd player :=
    s <- AiState;
    ret (st_player s).

  Let vit p i : aicmd intl :=
    s <- AiState;
    match getv (st_board s) p i with
      | Some v => ret v
      | None => ret (0 - 1)
    end.

  Let fld p i : aicmd value :=
    s <- AiState;
    ret (getf (st_board s) p i).

  Let myvit i : aicmd intl := p <- me; vit p i.
  Let myfld i : aicmd value := p <- me; fld p i.

  Let i4095 := Eval simpl in const_intl 4095.
  Let i4096 := Eval simpl in const_intl 4096.
  Let i8190 := Eval simpl in const_intl 8190.
  Let i30000 := Eval simpl in const_intl 30000.


  Definition chkfld i v : aicmd bool :=
    w <- myfld i;
    v' <- AiRead v;
    match v' with
      | Some v'' => ret (eqvalue v'' w)
      | None => ret false
    end.

  Definition updatefld i v (m : aicmd unit) : aicmd unit :=
    ifb chkfld i v then ret tt else
      m;;
      v' <- myfld i;
      AiWrite v (Some v').

  Section EarlyStage.
    Record early_state : Type := {
      heal_4095_at_8 : ptr (option value);
      heal_8190_at_6 : ptr (option value);
      heal256_4095_at_16 : ptr (option value);
      heal256_8190_at_12 : ptr (option value)
    }.

    Definition init_early_state :=
      a <- AiNew None;
      b <- AiNew None;
      c <- AiNew None;
      d <- AiNew None;
      ret (Build_early_state a b c d).


    Variable st : early_state.

    Definition ch2p := kp;; sr;; sl;; kr;; sl;; ir.
    Definition chmulp := kp;; sr;; sl;; kr.

    Definition mk_church_1 : aicmd unit :=
      arun 0 (ch2p);; (* 0 <- [2] *)
      arun 1 (reg0p);; (* 1 <- [2] *)
      arun 1 (reg0r);; (* 1 <- [4] *)
      arun 2 (chmulp;; reg0r;; reg1r);; (* 2 <- [8] *)
      arun 4 (onep;; succl;; getl);; (* 4 <- [8] *)
      arun 2 (reg0r);; (* 2 <- [256] *)
      ret tt.

    Definition mk_const_tbl_1 : aicmd unit :=
      arun 0 (succp;; dblc);;
      arun 4 (reg0r;; zeror);; (* 4 <- 255 *)
      arun 1 (reg0r);;
      arun 0 (onep;; succl;; dbll;; getl);;
      arun 1 (reg0r);; (* 1 <- 4095 *)
      arun 5 (reg1p);; (* 5 <- 4095 *)
      arun 1 (dbll);;
      arun 3 (reg1p);; (* 3 <- 8190 *)
      ret tt.

    Definition make_heal_head n :=
      (* n <- lazy (help (get 0) (get 0)) *)
      (* 0 <- lazy (get 0) *)
      arun 0 (getp;; lazl;; lapp;; laz0r);;
      arun n (helpp;; lazl;; lapp;; reg0r;; lapp;; reg0r).

    Definition make_heal_4095_at_8 : aicmd unit :=
      updatefld 8 (heal_4095_at_8 st) (
        (* 8 <- lazy (help (get 0) (get 0) 4095) *)
        make_heal_head 8;;
        (* 0 <- lazy 4095 *)
        arun 0 (onep;; dbll;; dbll;; succl ;; getl;; lazl);;
        arun 8 (lapp;; reg0r)
      ).

    Definition make_heal_8190_at_6 : aicmd unit :=
      updatefld 6 (heal_8190_at_6 st) (
        (* 6 <- lazy (help (get 0) (get 0) 8190 *)
        make_heal_head 6;;
        arun 0 (onep;; dbll;; succl;; getl;; lazl);;
        arun 6 (lapp;; reg0r)
      ).

    Definition imm_help_0 : aicmd unit := ret tt. (* TODO *)

    Definition dup256_heal n :=
      (* 1 <- [256] reg0 *)
      arun n (onep;; succl;; getl;; reg0r).

    Definition make_heal256_4095_at_16 :=
      make_heal_4095_at_8;;
      updatefld 16 (heal256_4095_at_16 st) (
        arun 0 (onep;; rep 3 dbll;; getl);;
        dup256_heal 16
      ).
        
    Definition make_heal256_8190_at_12 :=
      make_heal_8190_at_6;;
      updatefld 6 (heal256_8190_at_12 st) (
        arun 0 (onep;; dbll;; succl;; dbll;; getl);;
        dup256_heal 12
      ).

    Definition copy_heal256_4095_at_16 n :=
      make_heal256_4095_at_16;;
      ifb chkfld n (heal256_4095_at_16 st) then ret tt else
        arun n (onep;; dbll;; succl;; dbll;; dbll;; getl).
        
    Definition copy_heal256_8190_at_12 n :=
      make_heal256_8190_at_12;;
      ifb chkfld n (heal256_8190_at_12 st) then ret tt else
        arun n (onep;; dbll;; succl;; dbll;; dbll;; getl).

    Definition heal_4095_0 : aicmd unit :=
      copy_heal256_4095_at_16 1;;
      arun 0 (zerop);;
      v <- myvit 0;
      if (v <= i4096)%bool
        then
          imm_help_0
        else
          arun 1 (ir).

    Definition heal_8190_0 : aicmd unit :=
      copy_heal256_8190_at_12 1;;
      arun 0 (zerop);;
      v <- myvit 0;
      if (v <= i4096)%bool
        then
          imm_help_0
        else if (v <= i8190)%bool then
          heal_4095_0
        else
          arun 1 (ir).

    Definition run_first_heal : aicmd unit :=
      v <- myvit 0;
      if (v >= i30000)%bool then
        ret tt
      else if (v <= i4095)%bool then
        imm_help_0
      else if (v <= i8190)%bool then
        heal_4095_0
      else
        heal_8190_0.

    Definition heal_4095_reg0 :=
      copy_heal256_4095_at_16 1;;
      arun 1 (ir).

    Definition heal_8190_reg0 :=
      copy_heal256_8190_at_12 1;;
      arun 1 (ir).

    Definition run_heal_n n :=
      v <- myvit n;
      if (v >= i30000)%bool then
        arun 0 (succl)
      else if (v <= i4095)%bool then
        arun 0 (succl)
      else if (v <= i8190)%bool then
        heal_4095_reg0
      else
        heal_8190_reg0.

    Definition run_second_heal :=
      v <- myfld 0;
      match v with
        | ValNum n =>
          if (n < 0) || (n > 255)
            then
              arun 0 (onep)
            else
              run_heal_n n
        | _ => arun 0 (onep)
      end.

    Definition early_main : aicmd unit :=
      mk_church_1;;
      mk_const_tbl_1;;
      rep 3 run_first_heal;;
      arun 0 (onep);;
      rep 1 run_second_heal;;
      make_heal_8190_at_6;;
      make_heal_4095_at_8.

  End EarlyStage.

  Section MiddleStage.
    Record middle_state : Type := {
      early_st :> early_state
    }.
  
    Definition init_middle_state s := Build_middle_state s.

    Variable st : middle_state.

    Definition mk_church_2 : aicmd unit :=
      arun 0 (ch2p);;
      arun 1 (reg0p);;
      arun 0 (reg0r);;
      arun 1 (chmulp);;
      arun 1 (reg0r);;
      arun 0 (onep;; dbll;; dbll;; getl);;
      arun 1 (reg0r);;
      arun 4 (reg1p);; (* 4 <- [32] *)
      ret tt.

    Definition mk_healers :=
      arun 1 (helpp;; zeror;; zeror;; lazl);;
      arun 0 (onep;; succl;; succl;; getl;; lazl);;
      arun 1 (lapp;; reg0r);;
      arun 0 (onep;; dbll;; dbll;; getl);;
      arun 0 (reg1r);;
      arun 4 (reg0r);; (* 4 <- [32] (lazy (help 0 0 8190)) *)
      arun 1 (attackp;; zeror;; lazl);;
      arun 0 (getp;; lazl;; lapp;; laz0r);;
      arun 1 (lapp;; reg0r);;
      arun 0 (onep;; succl;; succl;; getl;; lazl);;
      arun 1 (lapp;; reg0r);; arun 4 (ir);;
      arun 4 (lseq;; reg1r);;
      arun 0 (zerop);; arun 4 (ir).

    Definition middle_main :=
      mk_church_2;;
      mk_healers;;
      ret tt.
  
  End MiddleStage.

  Definition run_early : aicmd early_state :=
    s <- init_early_state; early_main s;; ret (s : early_state).

  Definition run_middle :=
    middle_main.
    (* s' <- init_middle_state s; middle_main ;; ret s'. *)

  Definition run : aicmd unit :=
    run_early;;
    run_middle;;
    ret tt.

End Anko.

Definition anko : aicmd unit :=
  run.

(*
  mk_large_const;;
  mk_healer_1;;
  arun 0 (zerop);;
  arun 62 (ir).
*)

Definition anko_main := run_ai_main anko.

