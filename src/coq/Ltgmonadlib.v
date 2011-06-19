Require Import Arith Ax Ltg Ltgmonad.

Open Scope intl_scope.
Open Scope monad_scope.

Definition nop := ExNop.
Definition l c := ExLeft c.
Definition r c := ExRight c.

Definition if_sti {A} (f : statei -> bool) (g h : cmdex A) :=
  ExState >>= (fun st => if f st then g else h).

Notation "'ifsti' x 'then' y 'else' z" := (if_sti x y z) (at level 200, right associativity).

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
  ifsti is_I then nop else (zerol).

Definition p c :=
  ifsti (is (value_of_card c)) then nop else (clear >> r c).

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
  if_sti (is (ValNum 1)) nop (zerop >> succl).

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

Definition ainop := AiNop.
Definition arun := AiRunAt.

Definition if_st {A} (f : state -> bool) (g h : aicmd A) :=
  AiState >>= (fun st => if f st then g else h).

Notation "'ifst' x 'then' y 'else' z" := (if_st x y z) (at level 200, right associativity).

Notation "'ret' x" := (mreturn x) (at level 75) : monad_scope.
Notation "x <- y ;; z" := (mbind y (fun x => z)) (right associativity, at level 84, y at next level) : monad_scope.
Notation "x ; y" := (mbind x (fun _ => y)) (right associativity, at level 84) : monad_scope.

Definition rep {M} {H : monad M} n (x : M unit) : M unit :=
  iter_nat n _ (fun y => y >> x) x.
