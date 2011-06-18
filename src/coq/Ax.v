Axiom intl : Set.

Axiom intl_0 : intl.
Axiom intl_1 : intl.
Axiom intl_max : intl.
Axiom intl_255 : intl.
Axiom intl_256 : intl.
Axiom intl_of_nat : nat -> intl.
Axiom intl_add : intl -> intl -> intl.
Axiom intl_sub : intl -> intl -> intl.
Axiom intl_mul : intl -> intl -> intl.
Axiom intl_div : intl -> intl -> intl.
Axiom intl_eq : intl -> intl -> bool.
Axiom intl_le : intl -> intl -> bool.
Axiom intl_ge : intl -> intl -> bool.
Axiom intl_lt : intl -> intl -> bool.
Axiom intl_gt : intl -> intl -> bool.

Infix "+" := intl_add : intl_scope.
Infix "-" := intl_sub : intl_scope.
Infix "*" := intl_mul : intl_scope.
Infix "/" := intl_div : intl_scope.
Infix "==" := intl_eq (at level 70, no associativity) : intl_scope.
Infix "<=" := intl_le : intl_scope.
Infix ">=" := intl_ge : intl_scope.
Infix "<"  := intl_lt : intl_scope.
Infix ">"  := intl_gt : intl_scope.


