Require Import Ax Ltg.

Class monad (M : Type -> Type) := {
  mreturn : forall {A}, A -> M A;
  mbind : forall {A B}, M A -> (A -> M B) -> M B
}.

Notation "x >>= f" := (mbind x f) (at level 42, left associativity) : monad_scope.
Notation "x >> y" := (mbind x (fun _ => y)) (at level 42, left associativity) : monad_scope.

Open Scope monad_scope.
Delimit Scope monad_scope with m.

Record statei : Set := {
  sti_player : player;
  sti_board : board;
  sti_i : intl
}.

Inductive cmdex : Type -> Type :=
| ExNop : cmdex unit
| ExLeft : card -> cmdex unit
| ExRight : card -> cmdex unit
| ExState : cmdex statei
| ExReturn {A} : A -> cmdex A
| ExBind {A B} : cmdex A -> (A -> cmdex B) -> cmdex B.

Bind Scope monad_scope with cmdex.

Instance cmdex_monad : monad cmdex := {
  mreturn := @ExReturn;
  mbind := @ExBind
}.

Record state : Set := {
  st_player : player;
  st_board : board
}.

Inductive aicmd : Type -> Type :=
| AiNop : aicmd unit
| AiRunAt : intl -> cmdex unit -> aicmd unit
| AiState : aicmd state
| AiReturn {A} : A -> aicmd A
| AiBind {A B} : aicmd A -> (A -> aicmd B) -> aicmd B.

Instance aicmd_monad : monad aicmd := {
  mreturn := @AiReturn;
  mbind := @AiBind
}.

Bind Scope monad_scope with aicmd.

Fixpoint hnf_cmd {A} sti (cmd : cmdex A) : cmdex A :=
  match cmd in cmdex A' return cmdex A' with
    | ExBind A B c f =>
      let c' := hnf_cmd sti c in
        match c' in cmdex B' return (B'-> cmdex B) -> (B' -> cmdex B) -> cmdex B with
          | ExNop => fun f _ => f tt
          | ExState => fun f _ => f sti
          | ExReturn _ v => fun f _ => f v
          | ExLeft c => fun _ f => ExLeft c >>= f
          | ExRight c => fun _ f => ExRight c >>= f
          | ExBind _ _ c g => fun _ f => ExBind c g >>= f
        end (fun x => hnf_cmd sti (f x)) f
    | ExNop => ExNop
    | ExLeft c => ExLeft c
    | ExRight c => ExRight c
    | ExState => ExState
    | ExReturn _ v => ExReturn v
  end.

Fixpoint hnf_ai {A} st ai : aicmd A :=
  match ai in aicmd A' return aicmd A' with
    | AiBind A B ai' f =>
      let ai' := hnf_ai st ai' in
        match ai' in aicmd B' return (B' -> aicmd B) -> (B' -> aicmd B) -> aicmd B with
          | AiNop => fun f _ => f tt
          | AiState => fun f _ => f st
          | AiReturn _ v => fun f _ => f v
          | AiRunAt si cmd => fun _ f => AiRunAt si cmd >>= f
          | AiBind _ _ c g => fun _ f => AiBind c g >>= f
        end (fun x => hnf_ai st (f x)) f
    | AiNop => AiNop
    | AiRunAt si cmd =>
      let sti := Build_statei (st_player st) (st_board st) si in
      let cmd :=  hnf_cmd sti cmd in
        match cmd with
          | ExNop => AiNop
          | _ => AiRunAt si cmd
        end
    | AiState => AiState
    | AiReturn _ v => AiReturn v
  end.

Inductive run_cmd_result_aux (A : Type) : Type :=
| RCResultAux : cmd -> cmdex A -> run_cmd_result_aux A.

Fixpoint run_cmd_aux {A} si (cmd : cmdex A) : run_cmd_result_aux A :=
  let junk := LeftApp CardI si in
  match cmd in cmdex A' return run_cmd_result_aux A' with
    | ExLeft c  => RCResultAux _ (LeftApp c si) ExNop
    | ExRight c => RCResultAux _ (RightApp si c) ExNop
    | ExBind _ _ c f =>
      match run_cmd_aux si c with
        | RCResultAux c' cmd' => RCResultAux _ c' (cmd' >>= f)
      end
    | ExNop        => RCResultAux _ junk ExNop
    | ExState      => RCResultAux _ junk ExState
    | ExReturn B v => RCResultAux _ junk (ExReturn v)
  end.

Inductive run_ai_resut_aux (A : Type) : Type :=
| RAIResult : cmd -> aicmd A -> run_ai_resut_aux A.

Fixpoint run_ai_aux {A} (ai : aicmd A) : run_ai_resut_aux A :=
  let junk := LeftApp CardI 0 in
  match ai in aicmd A' return run_ai_resut_aux A' with
    | AiRunAt si cmds =>
      match run_cmd_aux si cmds with
        | RCResultAux c cmds' =>
          RAIResult _ c (AiRunAt si cmds')
      end
    | AiBind _ _ ai' f =>
      match run_ai_aux ai' with
        | RAIResult c ai'' => RAIResult _ c (ai'' >>= f)
      end
        
    | AiNop => RAIResult _ junk AiNop
    | AiState => RAIResult _ junk AiState
    | AiReturn B v => RAIResult _ junk (AiReturn v)
  end.

Definition run_ai_result := run_ai_resut_aux unit.

Definition run_ai p bd (ai : aicmd unit) : run_ai_result :=
  let st := Build_state p bd in
  run_ai_aux (hnf_ai st ai).
