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
group.d := $(tmp)/group
$(group.d):; mkdir -p $@

stone := $(tmp)/.stone
$(stone): | $(tmp); touch $@
stone: phony | $(tmp); touch $(stone)

$(tmp)/jc: | $(group.d); test -d $@ || git -C $(@D) clone git@github.com:kellyjonbrazil/jc.git
jc := /usr/local/bin/jc
~ := $(jc)
$~: | $(tmp)/jc; (cd $|; pip3 install --no-color --upgrade --user -e .)
jc: phony $~

~ := $(group.d)/%
$~: jq := map(select(.group_name == ("sudo", "ssh")) | {(.group_name): .members}) | add | { ($$node): . }
$~: $(jc) $(stone) | $(group.d); ssh $(@F) cat /etc/group | jc --group | jq --arg node $(@F) '$(jq)' > $@

alien.nodes := esistn2 esistn3
alien.nodes.fqnd := $(alien.nodes:%=$(group.d)/%.esisdmz)
ifeq ($(MAKECMDGOALS),nodes)
MAKEFLAGS += -j$(NPROCS)
endif
nodes: phony $(alien.nodes.fqnd)

~ := $(tmp)/nodes.json
$~: $(alien.nodes.fqnd); cat $^ | jq -s add > $@
nodes: phony $~
- := $~

alien-groups := repo/infra-data-users/alien-groups.js

~ := $(tmp)/all.json
$~: data := $$users, $$nodes
$~: jq := . as [ $(data) ] | { $(data) }
$~: $(alien-groups) $-; jq -s '$(jq)' $^ > $@
all: phony $~
- := $~

~ := $(tmp)/todo.json
$~: alien-group.jq $-; jq -f $^ > $@
todo: phony $~
- := $~

~ := $(tmp)/todo.sh
$~: alien-group-shell.jq $-; jq -rf $^ | install /dev/stdin $@
sh: phony $~

yq := /usr/local/bin/yq

~ := $(tmp)/todo.yml
$~: head := \#!/usr/bin/env ansible-playbook
$~: start = $(wordlist $1, $(words $2), $2)
$~: jq = $(call start, 4, $^)
$~: $~ = jq -sf $(jq) | yq e -P - | { echo -e '$(head)\n'; cat; } | install /dev/stdin $@
$~: $(yq) $(self) $(stone) alien-group-ansible.jq $-; $($@)
ansible: phony $~

~ := $(yq)
$~: arch != uname -m
$~: x86_64 := amd64
$~: version := v4.9.5
$~: binary = yq_linux_$($(arch))
$~: url = https://github.com/mikefarah/yq/releases/download/$(version)/$(binary)
$~:; wget $(url) -O - | install /dev/stdin $@
yq: phony $~

main: phony sh ansible
