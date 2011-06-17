
type card =
  | CardI | CardZero | CardSucc | CardDbl | CardGet | CardPut | CardS | CardK | CardInc | CardDec
  | CardAttack | CardHelp | CardCopy | CardRevive | CardZombie

type value =
  | ValNum of int
  | ValI
  | ValSucc
  | ValDbl
  | ValGet
  | ValPut
  | ValS
  | ValSf of value
  | ValSfg of value * value
  | ValK
  | ValKx of value
  | ValInc
  | ValDec
  | ValAttack
  | ValAttacki of value
  | ValAttackij of value * value
  | ValHelp
  | ValHelpi of value
  | ValHelpij of value
  | ValCopy
  | ValRevive
  | ValZombie
  | ValZombiei of value

type slot = {
  mutable field : value;
  mutable vitality : int;
}

type slots = slot array
type board = slots array

let value_of_card c =
  match c with
    | CardI -> ValI
    | CardZero -> ValNum 0
    | CardSucc -> ValSucc
    | CardDbl -> ValDbl
    | CardGet -> ValGet
    | CardPut -> ValPut
    | CardS -> ValS
    | CardK -> ValK
    | CardInc -> ValInc
    | CardDec -> ValDec
    | CardAttack -> ValAttack
    | CardHelp -> ValHelp
    | CardCopy -> ValCopy
    | CardRevive -> ValRevive
    | CardZombie -> ValZombie

let rec eval_app player zombie board n v w :=
    let n = n + 1 in
    if n > 1000 then raise AppLimit;
    let result x = n, x in
    let eval_succ v = ValNum (limit_int (int_of_value v + 1)) in
    let eval_dbl  v = ValNum (limit_int (int_of_value v * 2)) in
    let eval_get  v = (read_slot_alive (slot_index_of_value v) player board).field in
    let exec_inc  v =
      let s = read_slot (slot_index_of_value v) player board in
      if alive s then s.vitality <- limit_vitality (s.vitality + 1)
    in
    let exec_dec v =
      let s = read_slot (slot_index_of_value v) (opponent player) board in
      if alive s then s.vitality <- limit_vitality (s.vitality - 1)
    in
    let exec_attack i j v =
      let s0 = read_slot (slot_index_of_value i) player board in
      let n  = int_of_value v in
      if s0.vitality < n then raise ExecFailed;
      s0.vitality <- s0.vitality - n;
      let s1 = read_slot_rev (slot_index_of_value j) (opponent player) board in
      if alive s1 then
	s1.vitality <- s1.vitality - n * 9 / 10
    in
    let exec_help i j v =
      let s0 = read_slot (slot_index_of_value i) player board in
      let n  = int_of_value v in
      if s0.vitality < n then raise ExecFailed;
      s0.vitality <- s0.vitality - n;
      let s1 = read_slot (slot_index_of_value j) player board in
      if alive s1 then
	s1.vitality <- s1.vitality + n * 11 / 10
    in
    let eval_copy v =
      let s = read_slot (slot_index_of_value i) (opponent player) board in
      s.field
    in
    let exec_revive v =
      let s = read_slot (slot_index_of_value i) player board in
      if s.vitality <= 0 then
	s.vitality <- 1
    in
    let exec_zombie i v =
      let s = read_slot_rev (slot_index_of_value i) (opponent player) board in
      if alive s.vitality then raise ExecFailed;
      s.field <- v;
      s.vitality <- -1
    in
    match v with
      | ValNum i -> raise NotFun
      | ValI     -> result w
      | ValSucc  -> result (eval_succ w)
      | ValDbl   -> result (eval_dbl w)
      | ValGet   -> result (eval_get w)
      | ValPut   -> result ValI
      | ValS     -> result (ValSf w)
      | ValSf(f) -> result (ValSfg(f, w))
      | ValSfg(f, g) ->
	let eval_app' = eval_app player board zombie in
	let (n, h) = eval_app' n f w in
	let (n, y) = eval_app' n g w in
	eval_app' n h y
      | ValK             -> result (ValKx w)
      | ValKx(x)         -> prue x
      | ValInc           -> exec_inc w; result ValI
      | ValDec           -> exec_dec w; result ValI
      | ValAttack        -> result (ValAttacki w)
      | ValAttacki(i)    -> result (ValAttackij(i, w))
      | ValAttackij(i,j) -> exec_attack w; result ValI
      | ValHelp          -> result (ValHelpi w)
      | ValHelpi(i)      -> result (ValHelpj(i, w))
      | ValHelpij        -> exec_help w; result ValI
      | ValCopy          -> result (eval_copy w)
      | ValRevive        -> exec_revive w; result ValI
      | ValZombie        -> result (ValZombiei w)
      | ValZombiei(i)    -> exec_zombie i w; result ValI
	
