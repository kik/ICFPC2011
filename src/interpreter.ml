open Ltg
open Ltgmonad
open Ltglib

let run_ai_main (cmd : unit aicmd) =
  let cmd = ref cmd in
  run_simple_main (fun p bd turn ->
    match run_ai p (board_of_cboard bd) !cmd with
      | RAIResult(c, cmd') ->
	cmd := cmd'; c)
