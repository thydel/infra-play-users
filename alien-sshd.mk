#!/usr/bin/make -f

MAKEFLAGS += -Rr --warn-undefined-variables
SHELL != which bash
.SHELLFLAGS := -euo pipefail -c

.ONESHELL:
.DELETE_ON_ERROR:
.PHONY: phony
_WS := $(or) $(or)
_comma := ,
.RECIPEPREFIX := $(_WS)
.DEFAULT_GOAL := main

self := $(lastword $(MAKEFILE_LIST))
$(self):;

NPROCS := 4

tmp := tmp
sshd := $(tmp)/sshd
$(sshd):; mkdir -p $@

stone := $(tmp)/.stone
$(stone): | $(tmp); touch $@
stone: phony | $(tmp); touch $(stone)

$(sshd)/%.default: | $(sshd); ssh $* /usr/sbin/sshd -f /dev/null -T > $@
$(sshd)/%.actual: | $(sshd); ssh $* /usr/sbin/sshd -T > $@

~ := $(sshd)/%.changed
$~: cmd = comm -23 <(sort $(word 1, $^)) <(sort $(word 2, $^)) | cut -d' ' -f1 | grep -f - $(word 2, $^)
$~: $(sshd)/%.default $(sshd)/%.actual | $(sshd); $(cmd) > $@

~ := $(sshd)/%.added
$~: cmd = comm -13 <(sort $(word 1, $^)) <(sort $(word 2, $^)) | comm -23 - <(sort $(word 3, $^))
$~: $(sshd)/%.default $(sshd)/%.actual $(sshd)/%.changed | $(sshd); $(cmd) > $@

alien.nodes := esistn2 esistn3
sshd.configs := default actual changed added
alien.nodes.fqnd.config := $(foreach node, $(alien.nodes), $(foreach config, $(sshd.configs), $(sshd)/$(node).esisdmz.$(config)))
ifeq ($(MAKECMDGOALS),nodes)
MAKEFLAGS += -j$(NPROCS)
endif
nodes: phony $(alien.nodes.fqnd.config)

main: phony nodes
