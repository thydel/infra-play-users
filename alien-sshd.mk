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
json := $(sshd)/json
$(json):; mkdir -p $@

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

~ := $(tmp)/sshd_config-keywords.json
$~: jq := [inputs] | map({ (. | ascii_downcase): . }) | add
$~: $~ := man sshd_config
$~: $~ += | sed -rn '/^ {5}AcceptEnv/,/^ {5}XAuthLocation/p'
$~: $~ += | sed -rn '/^ {5}([^ ]+)/p'
$~: $~ += | sed -r 's/^ +([^ ]+).*$$/\1/'
$~: $~ += | jq -Rn '$(jq)'
$~: $(self); $($@) > $@
keywords: $~

~ := $(json)/%.json
$~: jq.2json := [ inputs ] | map(split(" ")) | reduce .[] as $$i ({}; .[$$i[0]] += $$i[1:])
$~: jq.rename := .[0] as $$m | .[1] | with_entries(.key = ($$m[.key] // .key))
$~: $(sshd)/% $(tmp)/sshd_config-keywords.json $(self) | $(json); jq -Rn '$(jq.2json)' $< | jq -s '$(jq.rename)' $(word 2, $^) - > $@
alien.nodes.fqnd.config.json:=$(foreach _,$(alien.nodes.fqnd.config),$(dir $_)json/$(notdir $_).json)
json: $(alien.nodes.fqnd.config.json)

~ := $(json)/sshd_config-debian.txt
$~ : jq := map([ "\# " + .comment] + (.conf | to_entries | map([ .key ] + .value | join(" ")))) | add[]
$~ : $(notdir $(~:%.txt=%.json)); jq -r '$(jq)' $< > $@
debian: $~

changed.json := $(filter %.changed.json, $(alien.nodes.fqnd.config.json))
changed.txt := $(changed.json:%.json=%.txt)
~ := $(json)/%.changed.txt
$~: jq := .[0].changed.conf as $$d | .[1] | with_entries(.key as $$k | select($$d | has($$k) | not))
$~: $(~:%.txt=%.json) sshd_config-debian.json $(self); jq -s '$(jq)' $(word 2, $^) $< > $@
txt: $(changed.txt)

main: phony json debian
