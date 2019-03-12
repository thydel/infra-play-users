#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

oxa := inventory/oxa.yml
data-node := ext/data-nodes
nodes-oxa := $(data-node)/nodes-oxa.jsonnet

libsonnets-bases := admin admin2 s1adm
libsonnets := $(libsonnets-bases:%=$(data-node)/nodes-%.libsonnet)

$(oxa): $(nodes-oxa) $(libsonnets); $< -S > $@

main: $(oxa)

.PHONY: top main
