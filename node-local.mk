#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

repo != git config remote.origin.url

local := inventory/local.yml
$(local): node-local.jsonnet; jsonnet -m $(@D) -S -V repo=$(repo) $< && touch -r $< $@

main: $(local)
.PHONY: top main
