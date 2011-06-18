Require Import List.
Require Import Ax.
Require Import Ltg.


Extraction Language Ocaml.
Extract Inductive nat => "Ax.nat" [ "Ax.O" "Ax.S" ].
Extract Inductive bool => "bool" [ "true" "false" ].
Extract Inductive option => "option" [ "Some" "None" ].
Extract Inductive list => "list" [ "[]" "(::)" ].

Extraction Constant intl => 'Ax.intl'.
Extraction Constant intl_0 => 'Ax.intl_0'.
Extraction Constant intl_1 => 'Ax.intl_1'.
Extraction Constant intl_max => 'Ax.intl_max'.
Extraction Constant intl_255 => 'Ax.intl_255'.
Extraction Constant intl_256 => 'Ax.intl_256'.
Extraction Constant intl_of_nat => 'Ax.intl_of_nat'.
Extraction Constant intl_add => 'Ax.intl_add'.
Extraction Constant intl_sub => 'Ax.intl_sub'.
Extraction Constant intl_mul => 'Ax.intl_mul'.
Extraction Constant intl_div => 'Ax.intl_div'.
Extraction Constant intl_eq => 'Ax.intl_eq'.
Extraction Constant intl_le => 'Ax.intl_le'.
Extraction Constant intl_ge => 'Ax.intl_ge'.
Extraction Constant intl_lt => 'Ax.intl_lt'.
Extraction Constant intl_gt => 'Ax.intl_gt'.

Extraction "test.ml" eval_app.
