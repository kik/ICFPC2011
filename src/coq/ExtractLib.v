Require Import Extract.

Cd "..".
Extraction Library Ltg.
Extraction Library Ltgmonad.
Extraction Library Ltgmonadlib.
Extraction Library Ltgextra.
Extraction "wf_nat.ml" Wf_nat.iter_nat.
Recursive Extraction Library BinInt.

Cd "coq".
