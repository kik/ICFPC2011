
OCAMLBCFLAGS = -g
OCAMLBLDFLAGS = -g

SOURCES = ax.ml ltg.mli ltg.ml ltgmonad.mli ltgmonad.ml ltglib.ml interpreter.ml
RESULT = libltg

all: coqdir bcl ncl aidir

coqdir:
	make -C coq

aidir:
	make -C ai/monadkamaboko

-include OCamlMakefile

clean::
	make -C coq clean
	make -C ai/monadkamaboko clean
