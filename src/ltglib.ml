open List
open Format
open Ltg

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

let format_trace pp t = match t with
  | TraceInc(z, i) -> fprintf pp "TraceInc(%B, %d)" z i
  | TraceDec(z, i) -> fprintf pp "TraceDec(%B, %d)" z i
  | TraceAttackDec(i, n) -> fprintf pp "TraceAttacDec(%d, %d)" i n
  | TraceAttack(z, i, n) -> fprintf pp "TraceAttack(%B, %d, %d)" z i n
  | TraceHelpDec(i, n) -> fprintf pp "TraceHelpDec(%d, %d)" i n
  | TraceHelp(z, i, n) -> fprintf pp "TraceHelp(%B, %d, %d)" z i n
  | TraceRevive(i) -> fprintf pp "TraceRevive(%d)" i
  | TraceZombie(i, v) -> fprintf pp "TraceZombie(%d, %a)" i format_value v

let format_trace_list pp ts =
  List.iter (fun t -> fprintf pp "%a@," format_trace t) ts

type slot = {
  mutable field : value;
  mutable vitality : int option;
}

type slots = slot array
type cboard = slots array

let format_vitality pp v =
  match v with
    | Some v -> fprintf pp "%d" v
    | None -> fprintf pp "-1"

let format_slots pp ss =
  Array.iteri (fun i s ->
    if s.field <> ValI || s.vitality <> Some 10000 then
      fprintf pp "[%d, %a, %a]@," i format_value s.field format_vitality s.vitality) ss

let make_cboard () : cboard =
  Array.init 2 (fun _ ->
    Array.init 256 (fun i ->
      { field = ValI; vitality = Some 10000 }))

let int_of_player p =
  match p with
    | Player0 -> 0
    | Player1 -> 1

let cboard_getf cbd p si =
  cbd.(int_of_player p).(si).field

let cboard_getv cbd p si =
  cbd.(int_of_player p).(si).vitality

let board_of_cboard cbd = { getf = cboard_getf cbd; getv = cboard_getv cbd }

let cboard_update cbd bd =
  for si = 0 to 255 do
    cbd.(0).(si).field    <- getf bd Player0 si;
    cbd.(0).(si).vitality <- getv bd Player0 si;
    cbd.(1).(si).field    <- getf bd Player1 si;
    cbd.(1).(si).vitality <- getv bd Player1 si
  done


(*

type eval_result =
  | ResultValue of int * trace list * value
  | ResultFailure of trace list

let format_result pp r = match r with
  | ResultValue(n, tr, value) ->
    fprintf pp "%d-applications, result = %a@\n@[<hov 2>%a@]@\n" n format_value value format_trace_list tr
  | ResultFailure(tr) ->
    fprintf pp "error@\n@[<hov 2>%a@]@\n" format_trace_list tr

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
      let s = read_slot_rev si (opponent player) board in
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

let update_slot s res =
  let v = match res with
    | ResultValue(n, tr, v) -> v
    | ResultFailure(tr) -> ValI
  in
  s.field <- v;
  res

let left_app player board c x =
  let s = board.(player).(x) in
  let res = eval_app player false board (value_of_card c) s.field in
  update_slot s res

let right_app player board x c =
  let s = board.(player).(x) in
  let res = eval_app player false board s.field (value_of_card c) in
  update_slot s res

*)

let zombie_turn p cbd f =
  for si = 0 to 255 do
    let bd = board_of_cboard cbd in
    if getv bd p si = None then
      match zombie_app p bd si with
	| ExecResult(tr, bd) ->
	  cboard_update cbd bd;
	  f si tr bd
  done

let turn_iter f =
  for t = 1 to 100000 do
    f Player0 t;
    f Player1 t
  done

let format_cmd pp cmd =
  match cmd with
    | LeftApp(c, i) -> fprintf pp "l %s %d" (str_of_card c) i
    | RightApp(i, c) -> fprintf pp "r %d %s" i (str_of_card c)

let exec_cmd player cbd cmd =
  let bd = board_of_cboard cbd in
  let res = exec_cmd player bd cmd in
  match res with
    | ExecResult(tr, bd) ->
      cboard_update cbd bd;
      tr

let write_cmd cmd = match cmd with
  | LeftApp(c, i) -> Printf.printf "1\n%s\n%d\n" (str_of_card c) i; flush_all ()
  | RightApp(i, c) -> Printf.printf "2\n%d\n%s\n" i (str_of_card c); flush_all ()

let read_cmd () =
  let app = read_int () in
  if app = 1 then
    let c = card_of_str (read_line ()) in
    let i = read_int () in
    LeftApp(c, i)
  else
    let i = read_int () in
    let c = card_of_str (read_line ()) in
    RightApp(i, c)

let run_main main =
  let v = Sys.argv.(1) in
  let board = make_cboard () in
  main (if v = "0" then Player0 else Player1) board

let run_simple_main simple_main =
  run_main (fun player board ->
    turn_iter (fun p turn ->
      let c = if player = p then
	  let c = simple_main player board turn in
	  eprintf "** [%a]@." format_cmd c;
	  write_cmd c; c
	else
	  read_cmd ()
      in
      zombie_turn p board (fun _ _ _ -> ());
      exec_cmd p board c))

let run_solitaire_main lis =
  let lis = ref lis in
  run_simple_main (fun p board turn ->
    match !lis with
      | [] -> LeftApp(CardI, 0)
      | c :: lis' ->
	lis := lis'; c)

