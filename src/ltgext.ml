open Ltg

type slot_id = int

type statei = {
  sti_player: int;
  sti_board : board;
  sti_i : slot_id
}

type cmdex =
  | ExNop
  | ExLeft of card
  | ExRight of card
  | ExBind of cmdex * (statei -> cmdex)

let (>>=.) c0 c1 = ExBind(c0, c1)
let (>>.) c0 c1 = ExBind(c0, fun _ -> c1)

let nop = ExNop
let l c = ExLeft(c)
let r c = ExRight(c)

let if_sti f g h =
  nop >>=. (fun st -> if f st then g else h)

let is x st =
  let i = st.sti_i in
  let p = st.sti_player in
  let b = st.sti_board in
  let f = b.(p).(i).field in
  f = x

let is_I = is ValI
let is_zero = is (ValNum 0)

(* X <- S X *)
let sl = l CardS
(* X <- K X *)
let kl = l CardK
(* X <- S (K X) *)
let sk = kl >>. sl
(* X <- fun x -> X (c x) *)
let comp c = sk >>. r c
(* X <- X (c0 c1) *)
let appapp c0 c1 = comp c0 >>. r c1

(* X <- I *)
let clear =
  if_sti is_I nop (l CardZero)

(* X <- 0 *)
let zero =
  if_st is_zero nop (clear >>. r CardZero)

(* X <- 1 *)
let one =
  if_st (is (ValNum 1)) nop (zero >>. r CardSucc)

(* X <- n *)
let num n = match n with
  | 0 -> zero
  | 1 -> one
  | _ -> assert false (* TODO *)

(* X <- X (get 0) *)
let rreg0 = appapp CardGet CardZero
(* X <- X (get 1) *)
let rreg1 = comp CardGet >>. appapp CardSucc CardZero
(* X <- X (get (get 0)) *)
let rind  = comp CardGet >>. appapp CardGet CardZero
(* X <- lazy X *)
let laz = kl
(* X <- fun (lazy y) -> lazy (x y) / lazy x = X *)
let lapX = sl
(* X <- lazy (x 0) / lazy x = X *)
let lap0 = lapX >>. appapp CardK CardZero
(* X <- lazy (x 1) / lazy x = X *)
let lap1 = lapX >>. comp CardK >>. appapp CardSucc CardZero
(* X <- lazy (x y) / lazy x = X; y = get 0 *)
let lapreg0 = lapX >>. comp CardK >>. rreg0
(* X <- lazy (x y) / lazy x = X; lazy y = get 0 *)
let laplreg0 = lapX >>. rreg0
(* X <- lazy (x y) / lazy x = X; y = get (get 0) *)
let lapind = lapX >>. comp CardK >>. rind
(* X <- lazy (x y) / lazy x = X; lazy y = get (get 0) *)
let laplind = lapX >>. rind


type state = {
  st_player: int;
  st_board: board;
  st_turn: int
}

type aicmd =
  | AiNop
  | AiRunAt of slot_id * cmdex
  | AiBind of aicmd * (state -> aicmd)

let (>>=) c0 c1 = AiBind(c0, c1)
let (>>) c0 c1 = AiBind(c0, fun _ -> c1)
let ainop = AiNop

let if_st f g h =
  ainop >>= (fun st -> if f st then g else h)


let run_monad_main ai_main =
  let last_ai = ref ai_main in
  run_simple_main (fun player board turn ->
    let st = { st_player = player; st_board = board; st_turn = turn } in
    let rec hnf_cmd i cmd =
      match cmd with
	| ExBind(c, f) ->
	  let c' = hnf i c in
	  if c' = ExNop then
	    f { sti_player = player; sti_board = board; sti_i = i }
	  else
	    ExBind(c', f)
	| _ -> cmd
    in
    let rec hnf_ai ai =
      match ai with
	| AiBind(ai', f) ->
	  let ai'' = hnf_ai ai' in
	  if ai'' = AiNop then
	    f { st_player = player; st_board = board; st_turn = turn }
	  else
	    AiBind(ai'', f)
	| AiRunAt(i, c) ->
	  let c' = hnf_cmd i c in
	  if c' = ExNop then
	    AiNop
	  else
	    AiRunAt(i, c')
	| _ -> ai
    in
    let rec run_cmd i cmd =
      match cmd with
	| ExNop -> assert false
	| ExLeft(c) -> LeftApp(c, i), ExNop
	| ExRight(c) -> RightApp(i, c), ExNop
	| ExBind(cmd', f) ->
	  let (c, cmd'') = run_cmd i c in
	  c, ExBind(cmd'', f)
    in
    let rec run_ai ai =
      match ai with
	| AiNop -> LeftApp(CardI, 0), AiNop
	| AiRunAt(i, cmd) ->
	  let (c, cmd') = run_cmd i cmd in
	  c, AiRunAt(i, cmd')
	| AiBind(ai', f) ->
	  let (c, ai'') = run_ai ai'' in
	  c, AiBind(ai'', f)
    in

    let ai = !last_ai in
    let (c, ai') = run_ai ai in
    last_ai := ai';
    c)

