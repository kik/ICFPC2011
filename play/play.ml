open List
open Format

type card =
  | CardI | CardZero | CardSucc | CardDbl | CardGet | CardPut | CardS | CardK | CardInc | CardDec
  | CardAttack | CardHelp | CardCopy | CardRevive | CardZombie

let strof_card_alist = [
  CardI, "I";
  CardZero, "zero";
  CardSucc, "succ";
  CardDbl, "dbl";
  CardGet, "get";
  CardPut, "put";
  CardS, "S";
  CardK, "K";
  CardInc, "inc";
  CardDec, "dec";
  CardAttack, "attack";
  CardHelp, "help";
  CardCopy, "copy";
  CardRevive, "revive";
  CardZombie, "zombie";
]

let str_of_card c =
  assoc c strof_card_alist

let card_of_str s =
  let x = find (fun (_, t) -> s = t) strof_card_alist in
  fst x

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
  | ValHelpij of value * value
  | ValCopy
  | ValRevive
  | ValZombie
  | ValZombiei of value

let rec format_value pp v = match v with
  | ValNum(n) -> fprintf pp "(%d)" n
  | ValI -> fprintf pp "I"
  | ValSucc -> fprintf pp "succ"
  | ValDbl -> fprintf pp "dbl"
  | ValGet -> fprintf pp "get"
  | ValPut -> fprintf pp "put"
  | ValS   -> fprintf pp "S"
  | ValSf(f) -> fprintf pp "S(%a)" format_value f
  | ValSfg(f, g) -> fprintf pp "S(%a)(%a)" format_value f format_value g
  | ValK -> fprintf pp "K"
  | ValKx(x) -> fprintf pp "K(%a)" format_value x
  | ValInc -> fprintf pp "inc"
  | ValDec -> fprintf pp "dec"
  | ValAttack -> fprintf pp "attack"
  | ValAttacki(i) -> fprintf pp "attack(%a)" format_value i
  | ValAttackij(i,j) -> fprintf pp "attack(%a)(%a)" format_value i format_value j
  | ValHelp -> fprintf pp "help"
  | ValHelpi(i) -> fprintf pp "help(%a)" format_value i
  | ValHelpij(i, j) -> fprintf pp "help(%a)(%a)" format_value i format_value j
  | ValCopy -> fprintf pp "copy"
  | ValRevive -> fprintf pp "revive"
  | ValZombie -> fprintf pp "zombie"
  | ValZombiei(i) -> fprintf pp "zombie(%a)" format_value i

type trace =
  | TraceInc of bool * int
  | TraceDec of bool * int
  | TraceAttackDec of int * int
  | TraceAttack of bool * int * int
  | TraceHelpDec of int * int
  | TraceHelp of bool * int * int
  | TraceRevive of int
  | TraceZombie of int * value

type slot = {
  mutable field : value;
  mutable vitality : int;
}

type slots = slot array
type board = slots array

let make_board () =
  Array.init 2 (fun _ ->
    Array.init 256 (fun _ ->
      { field = ValI; vitality = 10000 }))

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

type eval_result =
  | ResultValue of int * trace list * value
  | ResultFailure of trace list

exception EvalFail of eval_result

let limit_int n =
  if n < 0 then 0 else
    if n <= 65535 then n else 65535

let set_vitality s n =
  s.vitality <- limit_int n

let add_vitality s n =
  set_vitality s (s.vitality + n)

let rec eval_app player zombie board tr n v w =
    let n = n + 1 in
    let result_fail tr = raise (EvalFail(ResultFailure tr)) in
    let result_with_trace tr x = ResultValue(n, tr, x) in
    let result x = result_with_trace tr x in

    let int_of_value tr v = match v with
      | ValNum n -> n
      | _ -> result_fail tr
    in
    let slot_index_of_value tr v =
      let n = int_of_value tr v in
      if n < 0 || 256 <= n then
        result_fail tr
      else
        n
    in
    let read_slot si player board = board.(player).(si) in
    let read_slot_rev si = read_slot (255 - si) in
    let alive s = s.vitality >= 1 in
    let dead s = s.vitality <= 0 in
    let opponent x = 1 - x in

    let eval_succ v = ValNum (limit_int (int_of_value tr v + 1)) in
    let eval_dbl  v = ValNum (limit_int (int_of_value tr v * 2)) in
    let eval_get  v =
      let si = slot_index_of_value tr v in
      let s  = read_slot si player board in
      if dead s then result_fail tr;
      s.field
    in

    let exec_inc  v =
      let si = slot_index_of_value tr v in
      let s = read_slot si player board in
      let d = if zombie then -1 else 1 in
      if alive s then add_vitality s d;
      result_with_trace (TraceInc(zombie, si) :: tr) ValI
    in

    let exec_dec v =
      let si = slot_index_of_value tr v in
      let s = read_slot si (opponent player) board in
      let d = if zombie then 1 else -1 in
      if alive s then add_vitality s d;
      result_with_trace (TraceDec(zombie, si) :: tr) ValI
    in

    let exec_attack i j v =
      let si = slot_index_of_value tr i in
      let s0 = read_slot si player board in
      let n  = int_of_value tr v in
      if s0.vitality < n then result_fail tr;
      add_vitality s0 (-n);
      let tr = TraceAttackDec(si, n) :: tr in
      let sj = slot_index_of_value tr j in
      let s1 = read_slot_rev sj (opponent player) board in
      let d = if zombie then 1 else -1 in
      if alive s1 then
        add_vitality s1 (d * (n * 9 / 10));
      let tr = TraceAttack(zombie, sj, n) :: tr in
      result_with_trace tr ValI
    in

    let exec_help i j v =
      let si = slot_index_of_value tr i in
      let s0 = read_slot si player board in
      let n  = int_of_value tr v in
      if s0.vitality < n then result_fail tr;
      add_vitality s0 (-n);
      let tr = TraceHelpDec(si, n) :: tr in
      let sj = slot_index_of_value tr j in
      let s1 = read_slot sj player board in
      let d = if zombie then -1 else 1 in
      if alive s1 then
        add_vitality s1 (d * (n * 11 / 10));
      let tr = TraceHelp(zombie, sj, n) :: tr in
      result_with_trace tr ValI
    in

    let eval_copy v =
      let si = slot_index_of_value tr v in
      let s = read_slot si (opponent player) board in
      s.field
    in

    let exec_revive v =
      let si = slot_index_of_value tr v in
      let s = read_slot si player board in
      if s.vitality <= 0 then
        set_vitality s 1;
      result_with_trace (TraceRevive si::tr) ValI
    in

    let exec_zombie i v =
      let si = slot_index_of_value tr v in
      let s = read_slot_rev si (opponent player) board in
      if alive s then result_fail tr;
      s.field <- v;
      s.vitality <- -1;
      result_with_trace (TraceZombie(si, v) :: tr) ValI
    in

    try
      if n > 1000 then result_fail tr;
      match v with
      | ValNum i -> result_fail tr
      | ValI     -> result w
      | ValSucc  -> result (eval_succ w)
      | ValDbl   -> result (eval_dbl w)
      | ValGet   -> result (eval_get w)
      | ValPut   -> result ValI
      | ValS     -> result (ValSf w)
      | ValSf(f) -> result (ValSfg(f, w))
      | ValSfg(f, g) ->
	let eval_app' tr n v w =
          match eval_app player zombie board tr n v w with
          | ResultValue(n, tr, r) -> n, tr, r
          | ResultFailure _ as f -> raise (EvalFail(f))
        in
	let (n, tr, h) = eval_app' tr n f w in
	let (n, tr, y) = eval_app' tr n g w in
	let (n, tr, r) = eval_app' tr n h y in
        ResultValue(n, tr, r)
      | ValK             -> result (ValKx w)
      | ValKx(x)         -> result x
      | ValInc           -> exec_inc w
      | ValDec           -> exec_dec w
      | ValAttack        -> result (ValAttacki w)
      | ValAttacki(i)    -> result (ValAttackij(i, w))
      | ValAttackij(i,j) -> exec_attack i j w
      | ValHelp          -> result (ValHelpi w)
      | ValHelpi(i)      -> result (ValHelpij(i, w))
      | ValHelpij(i,j)   -> exec_help i j w
      | ValCopy          -> result (eval_copy w)
      | ValRevive        -> exec_revive w
      | ValZombie        -> result (ValZombiei w)
      | ValZombiei(i)    -> exec_zombie i w
    with EvalFail(f) -> f
;;
let eval_app player zombie board v w =
  eval_app player zombie board [] 0 v w

let left_app player board c x =
  eval_app player false board (value_of_card c) board.(player).(x).field

let right_app player board x c =
  eval_app player false board board.(player).(x).field (value_of_card c)

let zombie_turn player board =
  for i = 0 to 255 do
    let s = board.(player).(i) in
    if s.vitality = -1 then begin
      let res = eval_app player true board s.field ValI in
      ignore res
    end
  done
