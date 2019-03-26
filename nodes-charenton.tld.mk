#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

base := charenton.tld.INI
self := inventory/$(base)
data-node := ext/data-nodes

$(self): $(data-node)/$(base); cp $< $@

main: $(self)

.PHONY: top main
