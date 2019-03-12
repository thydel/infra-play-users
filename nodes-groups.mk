#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

self := inventory/nodes-groups.INI
$(self): ext/nodes-groups/out/static_groups.ini; install $< $@

main: $(self)
.PHONY: main
