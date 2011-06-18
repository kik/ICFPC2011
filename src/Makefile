
LIB_SOURCES = ltg.ml ltgext.ml

SOURCES = $(LIB_SOURCES) play.ml
RESULT = play

define PROJ_qb
SOURCES = $(LIB_SOURCES) qb.ml
RESULT = qb
endef
export PROJ_qb

define PROJ_kamaboko
SOURCES = $(LIB_SOURCES) kamaboko.ml
RESULT = kamaboko
endef
export PROJ_kamaboko

ifndef SUBPROJS
export SUBPROJS = play qb kamaboko
endif

all: bc

-include OCamlMakefile


%:
	@make -f $(OCAMLMAKEFILE) subprojs SUBTARGET=$@


