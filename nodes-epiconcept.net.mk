#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

base := epiconcept.net.INI
self := inventory/$(base)
data-node := ext/data-nodes

$(self): $(data-node)/$(base); cp $< $@

main: $(self)

.PHONY: top main
