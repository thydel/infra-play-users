#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

repo != git config remote.origin.url

ini := inventory/poweredoff.INI
dir := ext/data-nodes
deps := nodes-poweredoff loc
$(ini): $(dir)/nodes-poweredoff.jsonnet $(deps:%=$(dir)/%.libsonnet); $< -V repo=$(repo) -S > $@

main: $(ini)
.PHONY: top main
