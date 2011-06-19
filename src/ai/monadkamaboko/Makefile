
INCDIRS = ../..
LIBDIRS = ../..

OCAMLBCFLAGS = -g
OCAMLBLDFLAGS = -g

SOURCES = wf_nat.mli wf_nat.ml monadKamaboko.mli monadKamaboko.ml
LIBS = libltg
RESULT = monadKamaboko

BCSUFFIX = _bc
NCSUFFIX = _nc

all: bc nc

$(RESULT)_bc : ../../libltg.cma
$(RESULT)_nc : ../../libltg.cmxa

include OCamlMakefile
