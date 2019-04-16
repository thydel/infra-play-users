#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

nodes-groups := inventory/nodes-groups.INI
$(nodes-groups): ext/nodes-groups/out/static_groups.ini; install $< $@

cross-domain := inventory/cross-domain.INI
epiconcept.fr := inventory/epiconcept.fr.INI
$(cross-domain) $(epiconcept.fr): inventory/% : ext/nodes-groups/%; install $< $@

main: $(nodes-groups) $(cross-domain) $(epiconcept.fr)
.PHONY: main
