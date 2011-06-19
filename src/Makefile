
OCAMLBCFLAGS = -g
OCAMLBLDFLAGS = -g

SOURCES = ax.ml ltg.mli ltg.ml ltgmonad.mli ltgmonad.ml \
	ltgmonadlib.mli ltgmonadlib.ml \
	ltgextra.mli ltgextra.ml \
	wf_nat.mli wf_nat.ml \
	ltglib.ml interpreter.ml

RESULT = libltg

all: coqdir bcl ncl aidir

coqdir:
	make -C coq

AIDIRS = monadKamaboko anko

aidir:
	for i in $(AIDIRS); do \
		make -C ai/$$i; \
	done

-include OCamlMakefile

clean::
	make -C coq clean
	for i in $(AIDIRS); do \
		make -C ai/$$i clean; \
	done

