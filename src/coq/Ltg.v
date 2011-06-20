Require Import List.
Require Import Bool.
Require Import Ax.

Open Scope intl_scope.

Inductive card : Set :=
  | CardI | CardZero | CardSucc | CardDbl | CardGet | CardPut | CardS | CardK | CardInc | CardDec
  | CardAttack | CardHelp | CardCopy | CardRevive | CardZombie.

Inductive value : Set :=
  | ValNum : intl -> value
  | ValI
  | ValSucc
  | ValDbl
  | ValGet
  | ValPut
  | ValS
  | ValSf : value -> value
  | ValSfg : value -> value -> value
  | ValK
  | ValKx : value -> value
  | ValInc
  | ValDec
  | ValAttack
  | ValAttacki : value -> value
  | ValAttackij : value -> value -> value
  | ValHelp
  | ValHelpi : value -> value
  | ValHelpij : value -> value -> value
  | ValCopy
  | ValRevive
  | ValZombie
  | ValZombiei : value -> value.

Definition value_eq_dec (x y: value) : { x = y } + { x <> y }.
Proof.
  decide equality.
  apply intl_eq_dec.
Defined.

Definition eqvalue x y :=
  if value_eq_dec x y then true else false.

Inductive trace : Set :=
  | TraceInc : bool -> intl -> trace
  | TraceDec : bool -> intl -> trace
  | TraceAttackDec : intl -> intl -> trace
  | TraceAttack : bool -> intl -> intl -> trace
  | TraceHelpDec : intl -> intl -> trace
  | TraceHelp : bool -> intl -> intl -> trace
  | TraceRevive : intl -> trace
  | TraceZombie : intl -> value -> trace.

Inductive player : Set := Player0 | Player1.

Definition eqp p p' :=
  match p, p' with
    | Player0, Player0 => true
    | Player1, Player1 => true
    | _, _ => false
  end.

Definition oppp p :=
  match p with
    | Player0 => Player1
    | Player1 => Player0
  end.

Definition oppsi si : intl := 255 - si.

Record board : Set := {
  getf : player -> intl -> value;
  getv : player -> intl -> option intl
}.

Inductive alivep : Set :=
| Alive : intl -> alivep
| Dead : alivep.

Definition alive bd p si :=
  match getv bd p si with
    | Some v => if v > 0 then Alive v else Dead
    | None => Dead
  end.

Definition update_f bd p si f :=
  Build_board (fun p' si' =>
    if (eqp p p') && (si == si') then f else getf bd p' si')
    (getv bd).

Definition update_v bd p si v :=
  Build_board (getf bd) (fun p' si' =>
    if (eqp p p') && (si == si') then v else getv bd p' si').

Section eval_fun.
  Variable p : player.
  Variable zombie : bool.

  Inductive evalue : Set :=
  | EValue : value -> evalue
  | EApp : evalue -> evalue -> evalue.

  Inductive eresult : Set :=
  | EDone : value -> list trace -> board -> eresult
  | EFound : evalue -> list trace -> board -> eresult
  | EFail : list trace -> board -> eresult.

  Section step0_def.
    Variable vfun v : value.
    Variable tr : list trace.
    Variable bd : board.

    Let done x := EDone x nil bd.

    Let intl_limit si :=
      if si < 0 then 0 else if si > intl_max then intl_max else si.

    Let exec_intl_chk v tr bd f :=
      match v with
        | ValNum i => f i
        | _ => EFail tr bd
      end.

    Let eval_intl_chk v f :=
      exec_intl_chk v tr bd f.

    Let exec_slot_chk v tr bd f :=
      exec_intl_chk v tr bd (fun x =>
        if x < 256 then f x else EFail tr bd).

    Let eval_slot_chk v f :=
      exec_slot_chk v tr bd f.

    Let inc1 x : intl := x + 1.
    Let dec1 x : intl := x - 1.

    Let exec_alive_chk bd p si tr (f : intl -> eresult) :=
      alivep_rec (fun _ => _) f (EFail tr bd) (alive bd p si).

    Let exec_inc :=
      eval_slot_chk v (fun si =>
      exec_alive_chk bd p si tr (fun v =>
      EDone ValI (TraceInc zombie si::tr) (
        update_v bd p si (Some (intl_limit (if zombie then dec1 v else inc1 v)))))).

    Let exec_dec :=
      eval_slot_chk v (fun si' =>
      let si := oppsi si' in
      let p' := oppp p in
      exec_alive_chk bd p' si tr (fun v =>
      EDone ValI (TraceDec zombie si::tr) (
        update_v bd p' si (Some (intl_limit (if zombie then inc1 v else dec1 v)))))).

    Let exec_attack i j :=
      eval_slot_chk i (fun si =>
      eval_intl_chk v (fun n =>
      exec_alive_chk bd p si tr
        (fun vi => if vi < n then EFail nil bd else
        let bd := update_v bd p si (Some (intl_limit (vi - n))) in
        let tr := TraceAttackDec si n :: tr in
        exec_slot_chk j tr bd (fun sj =>
        let n' := n * 9 / 10 in
        let p' := oppp p in
        let sj' := oppsi si in
        exec_alive_chk bd p' sj' tr
          (fun vj =>
          let bd := update_v bd p' sj'
            (Some (intl_limit (if zombie then vj + n' else vj - n'))) in
          let tr := TraceAttack zombie sj' n :: tr in
          EDone ValI tr bd))))).

    Let exec_help i j :=
      eval_slot_chk i (fun si =>
      eval_intl_chk v (fun n =>
      exec_alive_chk bd p si tr
        (fun vi => if vi < n then EFail nil bd else
        let bd := update_v bd p si (Some (vi - n)) in
        let tr := TraceHelpDec si n :: tr in
        exec_slot_chk j tr bd (fun sj =>
        let n' := n * 11 / 10 in
        exec_alive_chk bd p sj tr
          (fun vj =>
          let bd := update_v bd p sj
            (Some (intl_limit (if zombie then vj - n' else vj + n'))) in
          let tr := TraceHelp zombie sj n :: tr in
          EDone ValI tr bd))))).

    Let exec_revive :=
      eval_slot_chk v (fun si =>
      alivep_rec (fun _ => _)
        (fun _ => EDone ValI nil bd)
        (let bd := update_v bd p si (Some 1) in
        let tr := TraceRevive si :: tr in
        EDone ValI tr bd)
        (alive bd p si)).

    Let exec_zombie i :=
      eval_slot_chk i (fun si' =>
      let si := oppsi si' in
      let p' := oppp p in
      alivep_rec (fun _ => _)
        (fun _ => EFail nil bd)
        (let bd := update_f bd p si v in
        let tr := TraceZombie si v :: tr in
        EDone ValI tr bd)
        (alive bd p' si)).


    Definition step0 :=
    match vfun with
      | ValNum i => EFail tr bd
      | ValI     => done v
      | ValSucc  => eval_intl_chk v (fun x => done (ValNum (x + 1)))
      | ValDbl   => eval_intl_chk v (fun x => done (ValNum (x + x)))
      | ValGet   => eval_slot_chk v (fun x => done (getf bd p x))
      | ValPut   => done ValI
      | ValS     => done (ValSf v)
      | ValSf f  => done (ValSfg f v)
      | ValSfg f g => EFound (EApp (EApp (EValue f) (EValue v)) (EApp (EValue g) (EValue v))) tr bd
      | ValK             => done (ValKx v)
      | ValKx x          => done x
      | ValInc           => exec_inc
      | ValDec           => exec_dec
      | ValAttack        => done (ValAttacki v)
      | ValAttacki i     => done (ValAttackij i v)
      | ValAttackij i j  => exec_attack i j
      | ValHelp          => done (ValHelpi v)
      | ValHelpi i       => done (ValHelpij i v)
      | ValHelpij i j    => exec_help i j
      | ValCopy          => eval_slot_chk v (fun x => done (getf bd (oppp p) x))
      | ValRevive        => exec_revive
      | ValZombie        => done (ValZombiei v)
      | ValZombiei(i)    => exec_zombie i
    end.

  End step0_def.

  Fixpoint step ev tr bd :=
    match ev with
      | EValue v => EDone v tr bd
      | EApp (EValue v0) (EValue v1) => step0 v0 v1 tr bd
      | EApp v0 ((EApp _ _) as v1) =>
        match step v1 tr bd with
          | EDone  v1' tr bd' => EFound (EApp v0 (EValue v1')) tr bd'
          | EFound v1' tr bd' => EFound (EApp v0 v1') tr bd'
          | EFail tr bd' as e => e
        end
      | EApp ((EApp _ _) as v0) ((EValue _) as v1) =>
        match step v0 tr bd with
          | EDone  v0' tr bd' => EFound (EApp (EValue v0') v1) tr bd'
          | EFound v0' tr bd' => EFound (EApp v0' v1) tr bd'
          | EFail tr bd' as e => e
        end
    end.

  Inductive eval_result : Set :=
  | EvalResult : value -> list trace -> board -> eval_result.

  Fixpoint eval n ev tr bd :=
    match n with
      | O => EvalResult ValI tr bd
      | S n' =>
        match step ev tr bd with
          | EDone v tr bd as e => EvalResult v tr bd
          | EFound v tr' bd' => eval n' v tr' bd'
          | EFail tr bd as e => EvalResult ValI tr bd
        end
    end.

  Definition v_1000 := 1000.

  Definition eval_app v w bd :=
    eval v_1000 (EApp (EValue v) (EValue w)) nil bd.

End eval_fun.

Definition value_of_card c :=
  match c with
    | CardI => ValI
    | CardZero => ValNum 0
    | CardSucc => ValSucc
    | CardDbl => ValDbl
    | CardGet => ValGet
    | CardPut => ValPut
    | CardS => ValS
    | CardK => ValK
    | CardInc => ValInc
    | CardDec => ValDec
    | CardAttack => ValAttack
    | CardHelp => ValHelp
    | CardCopy => ValCopy
    | CardRevive => ValRevive
    | CardZombie => ValZombie
  end.

Inductive exec_result : Set :=
| ExecResult : list trace -> board -> exec_result.

Definition exec_app p zombie v w bd si :=
  match eval_app p zombie v w bd with
    | EvalResult v tr bd =>
      if zombie
        then
          ExecResult tr (update_f (update_v bd p si None) p si ValI)
        else
          ExecResult tr (update_f bd p si v)
  end.

Definition left_app p bd c si :=
  exec_app p false (value_of_card c) (getf bd p si) bd si.

Definition right_app p bd si c :=
  exec_app p false (getf bd p si) (value_of_card c) bd si.

Definition zombie_app p bd si :=
  exec_app p true (getf bd p si) ValI bd si.

Inductive cmd : Set :=
| LeftApp : card -> intl -> cmd
| RightApp: intl -> card -> cmd.

Definition exec_cmd p bd cmd :=
  match cmd with
    | LeftApp  c si => left_app  p bd c si
    | RightApp si c => right_app p bd si c
  end.
