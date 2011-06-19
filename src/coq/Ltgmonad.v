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

Definition nop := ExNop.
Definition l c := ExLeft c.
Definition r c := ExRight c.

Definition if_sti {A} (f : statei -> bool) (g h : cmdex A) :=
  ExState >>= (fun st => if f st then g else h).

Definition is x st :=
  eqvalue (getf (sti_board st) (sti_player st) (sti_i st)) x.

Definition is_I := is ValI.
Definition is_zero := is (ValNum 0).

Definition il		:= l CardI.
Definition zerol	:= l CardZero.
Definition succl	:= l CardSucc.
Definition dbll		:= l CardDbl.
Definition getl		:= l CardGet.
Definition putl		:= l CardPut.
Definition sl		:= l CardS.
Definition kl		:= l CardK.
Definition incl		:= l CardInc.
Definition decl		:= l CardDec.
Definition attackl	:= l CardAttack.
Definition helpl	:= l CardHelp.
Definition copyl	:= l CardCopy.
Definition revivel	:= l CardRevive.
Definition zombiel	:= l CardZombie.

Definition ir		:= r CardI.
Definition zeror	:= r CardZero.
Definition succr	:= r CardSucc.
Definition dblr		:= r CardDbl.
Definition getr		:= r CardGet.
Definition putr		:= r CardPut.
Definition sr		:= r CardS.
Definition kr		:= r CardK.
Definition incr		:= r CardInc.
Definition decr		:= r CardDec.
Definition attackr	:= r CardAttack.
Definition helpr	:= r CardHelp.
Definition copyr	:= r CardCopy.
Definition reviver	:= r CardRevive.
Definition zombier	:= r CardZombie.

(* X <- I *)
Definition clear :=
  if_sti is_I nop (zerol).

Definition p c :=
  if_sti (is (value_of_card c)) nop (clear >> r c).

Definition ip		:= p CardI.
Definition zerop	:= p CardZero.
Definition succp	:= p CardSucc.
Definition dblp		:= p CardDbl.
Definition getp		:= p CardGet.
Definition putp		:= p CardPut.
Definition sp		:= p CardS.
Definition kp		:= p CardK.
Definition incp		:= p CardInc.
Definition decp		:= p CardDec.
Definition attackp	:= p CardAttack.
Definition helpp	:= p CardHelp.
Definition copyp	:= p CardCopy.
Definition revivep	:= p CardRevive.
Definition zombiep	:= p CardZombie.

(* X <- S (K X) *)
Definition sk := kl >> sl.
(* X <- fun x -> X (c x) *)
Definition comp c := sk >> r c.

Definition ic		:= comp CardI.
Definition zeroc	:= comp CardZero.
Definition succc	:= comp CardSucc.
Definition dblc		:= comp CardDbl.
Definition getc		:= comp CardGet.
Definition putc		:= comp CardPut.
Definition sc		:= comp CardS.
Definition kc		:= comp CardK.
Definition incc		:= comp CardInc.
Definition decc		:= comp CardDec.
Definition attackc	:= comp CardAttack.
Definition helpc	:= comp CardHelp.
Definition copyc	:= comp CardCopy.
Definition revivec	:= comp CardRevive.
Definition zombiec	:= comp CardZombie.

(* X <- 1 *)
Definition onep :=
  if_sti (is (ValNum 1)) nop (zerop >> succr).

(* X <- n *)
(*
Definition num n := match n with
  | 0 -> zero
  | 1 -> one
  | _ -> assert false (* TODO *)
*)

Definition reg0p := zerop >> l CardGet.

(* X <- X (get 0) *)
Definition reg0r := getc >> zeror.
(* X <- X (get 1) *)
Definition reg1r := getc >> succc >> zeror.
(* X <- X (get (get 0)) *)
Definition indr  := getc >> getc >> zeror.
(* X <- lazy X *)
Definition lazl := kl.
(* X <- fun (lazy y) -> lazy (x y) / lazy x := X *)
Definition lapp := sl.

Definition laz0r := kc >> zeror.
Definition laz1r := kc >> succc >> zeror.
Definition lazreg0r := kc >> reg0r.
Definition lapindr := kc >> indr.
Definition lseq := sk.

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

Definition ainop := AiNop.
Definition arun := AiRunAt.

Definition if_st {A} (f : state -> bool) (g h : aicmd A) :=
  AiState >>= (fun st => if f st then g else h).

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
          | AiRunAt si cmd =>
            let sti := Build_statei (st_player st) (st_board st) si in
              let cmd' :=  hnf_cmd sti cmd in
                let nop := match cmd with
                             | ExNop => true
                             | _ => false
                           end in
                fun f f' =>
                  if nop then f tt else AiRunAt si cmd >>= f'
          | AiBind _ _ c g => fun _ f => AiBind c g >>= f
        end (fun x => hnf_ai st (f x)) f
    | AiNop => AiNop
    | AiRunAt si cmd => AiRunAt si cmd
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
