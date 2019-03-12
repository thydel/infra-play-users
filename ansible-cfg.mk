#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

repo != git config remote.origin.url

stone := ansible-cfg/.stone
$(stone): ansible-cfg.jsonnet; mkdir -p $(@D); jsonnet -m $(@D) -S -V repo=$(repo) $< && touch $@

confs := mini full simple median nodes_groups
$(confs): $(stone); ln -sf ansible-cfg/$@.cfg ansible.cfg
main: full

.PHONY: top $(confs) main
