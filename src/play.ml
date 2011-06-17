open Format
open Ltg

let board = make_board ()

let () = Printf.printf "hello, world!\n"

let optint_of_str s =
  try
    Some (int_of_string s)
  with Failure _ -> None

let optcard_of_str s =
  try
    Some (card_of_str s)
  with Not_found -> None

let do_left_app player c i =
  printf "APply: %s %d\n@." (str_of_card c) i;
  let res = left_app player board c i in
  printf "Result: %a@." format_result res

let do_right_app player i c =
  printf "APply %d %s\n@." i (str_of_card c);
  let res = right_app player board i c in
  printf "Result: %a@." format_result res

let play_turn turn player =
  printf "turn(%d, %d):\n@." turn player;
  printf "slots=\n@[<hov 2>%a@]@\n@." format_slots board.(player);
  zombie_turn player board (fun i res ->
    printf "zombie(%d)\n  %a@." i format_result res);
  let rec f () =
    try
      printf "?\n@.";
      let line = read_line () in
      Scanf.sscanf line "%s %s" (fun x y ->
        let xi = optint_of_str x in
        let xc = optcard_of_str x in
        let yi = optint_of_str y in
        let yc = optcard_of_str y in
        match xi, xc, yi, yc with
        | Some i, None, None, Some c -> do_right_app player i c
        | None, Some c, Some i, None -> do_left_app player c i
        | _ -> f ())
    with Scanf.Scan_failure _ ->
      f ()
  in
  f ()

let () =
  for turn = 1 to 100000 do
    for player = 0 to 1 do
      play_turn turn player
    done
  done
