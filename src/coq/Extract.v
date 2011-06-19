Require Import List.
Require Import LtgAll.
Require Import Wf_nat.

Extraction Language Ocaml.
Extract Inductive unit => "unit" [ "()" ].
Extract Inductive nat => "Ax.nat" [ "Ax.O" "Ax.S" ].
Extract Inductive bool => "bool" [ "true" "false" ].
Extract Inductive sumbool => "bool" [ "true" "false" ].
Extract Inductive option => "option" [ "Some" "None" ].
Extract Inductive list => "list" [ "[]" "(::)" ].

Extract Constant intl => "Ax.intl".
Extract Constant arr "t" => " 't array ".
Require Import ExtractInts.
Extract Constant intl_max => "Ax.intl_max".
Extract Constant intl_eq_dec => "Ax.intl_eq_dec".
Extract Constant intl_of_nat => "Ax.intl_of_nat".
Extract Constant intl_add => "Ax.intl_add".
Extract Constant intl_sub => "Ax.intl_sub".
Extract Constant intl_mul => "Ax.intl_mul".
Extract Constant intl_div => "Ax.intl_div".
Extract Constant intl_eq => "Ax.intl_eq".
Extract Constant intl_le => "Ax.intl_le".
Extract Constant intl_ge => "Ax.intl_ge".
Extract Constant intl_lt => "Ax.intl_lt".
Extract Constant intl_gt => "Ax.intl_gt".
Extract Constant make_arr => "Array.init".
Extract Constant aref => "Array.get".

Extract Constant run_ai_main => "Interpreter.run_ai_main".

Require Import MonadKamaboko.
Require Import AiAnko.

Cd "..".
Extraction Library Ltg.
Extraction Library Ltgmonad.
Extraction Library Ltgmonadlib.
Extraction Library Ltgextra.
Extraction "wf_nat.ml" iter_nat.

Cd "ai/monadkamaboko".

Extraction Library MonadKamaboko.

Cd "../anko".

Extraction Library AiAnko.

Cd "../../coq".
