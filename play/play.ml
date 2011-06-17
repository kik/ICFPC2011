
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
  field : value ref;
  vitality : int ref;
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

let rec eval_app player board n v w :=
    let eval_app' = eval_app player board in
    let pure x = n + 1, x in
    match v with
      | ValNum i -> raise NotFun
      | ValI -> pure w
      | ValSucc -> pure (eval_succ w)
      | ValDbl -> pure (eval_dbl w)
      | ValGet -> pure (eval_get w player board)
      | ValPut -> pure ValI
      | ValS -> pure (ValSf w)
      | ValSf(f) -> pure (ValSfg(f, w))
      | ValSfg(f, g) ->
	let n = n + 1 in
	let (n, h) = eval_app' n f w in
	let (n, y) = eval_app' n g w in
	eval_app' n h y
      | ValK -> pure (ValKx w)
      | ValKx(x) -> prue x
      | ValInc -> exec_inc w player board; pure ValI
      | ValDec -> exec_dec w player board; pure ValI
      | ValAttack -> pure (ValAttacki w)
      | ValAttacki(i) -> pure (ValAttackij(i, w))
      | ValAttackij(i,j) -> exec_attack w player board; pure ValI
      | ValHelp -> pure (ValHelpi w)
      | ValHelpi(i) -> pure (ValHelpj(i, w))
      | ValHelpij -> exec_help w player board; pure ValI
      | ValCopy -> eval_copy w player board
      | ValRevive -> exec_revive w player board; pure ValI
      | ValZombie -> pure (ValZombiei w)
      | ValZombiei(i) -> exec_zombie i w player board; pure ValI

and eval_succ v = ValNum (limit_int (int_of_value v + 1))
and eval_dbl  v = ValNum (limit_int (int_of_value v * 2))
and eval_get v player board = (read_slot_alive (slot_of_value v) player board).field
