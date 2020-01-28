#!/usr/bin/make -f

MAKEFLAGS += -Rr 
MAKEFLAGS += --warn-undefined-variables
SHELL := $(shell which bash)
.SHELLFLAGS := -euo pipefail -c

.ONESHELL:
.DELETE_ON_ERROR:

.RECIPEPREFIX :=
.RECIPEPREFIX +=

.DEFAULT_GOAL := help

MIN_VERSION := 4.1
VERSION_ERROR :=  make $(MAKE_VERSION) < $(MIN_VERSION)
$(and $(or $(filter $(MIN_VERSION),$(firstword $(sort $(MAKE_VERSION) $(MIN_VERSION)))),$(error $(VERSION_ERROR))),)

self := $(lastword $(MAKEFILE_LIST))
$(self):;

top:; @date

%/.stone:; mkdir -p $(@D); touch $@

.PHONY: top main help

################

user ?= TDE

# git@github.com:Epiconcept-Paris/infra-password-store.git
password-store := ext/password-store/password-store

# git@github.com:Epiconcept-Paris/infra-data-users.git
data := /usr/local/etc/epi/repo
users := $(data)/infra-data-users/epi_user.js

# Do not use amin keys in user authorized key list
exclude[$(user)] := select((test("t.delamare") or test("cedric")) | not)
# No exclusion for admin key list
exclude[TDE] := .
exclude[CGD] := .

# Default private key
private[$(user)] := ~/.ssh/id_rsa
# My key was generated using
#   $(keys):; $(eval export p := $(shell pass key/$@)) ssh-keygen -o -a 64 -N $$p -C $@ -f $@
# Convert OpenSSH to PEM (keeping same password)
#   cp ~/.ssh/t.delamare@epiconcept.fr tmp/t.delamare@epiconcept.fr.pem
#   ssh-keygen -f tmp/t.delamare@epiconcept.fr.pem -m pem -p
private[TDE] := tmp/t.delamare@epiconcept.fr.pem

# Get first non excluded key
jq = [.users.trigram.$(strip $1).ssh_keys.present[].key | $(exclude[$(user)])][0]
tmp/$(user)-id_rsa.pub: $(users) tmp/.stone $(self); jq -r '$(call jq, $(user))' $< > $@

# Convert the public key into PEM format
tmp/$(user)-id_rsa.pub.pem: tmp/$(user)-id_rsa.pub; ssh-keygen -f $< -e -m PKCS8 > $@

# Use the public pem file to encrypt a the user password
export PASSWORD_STORE_DIR := $(abspath $(password-store))
~  := tmp/$(user)-mdp.txt
$~  =   pass users/linux/$(user) | head -1
$~ += | openssl rsautl -encrypt -pubin -inkey $<
$~ += | openssl base64 > $@
$~: tmp/$(user)-id_rsa.pub.pem; $($@)

main: tmp/$(user)-mdp.txt

decrypt.help := Show how to decrypt using the private key
decrypt := openssl base64 -d | openssl rsautl -decrypt -inkey $(private[$(user)])
# Will ask the private key password
decrypt: tmp/$(user)-mdp.txt; @echo '< $< $($@)'

define help +=
$(self)                          | # default to help (this help)
$(self) main user=$$trigram      | # generates a base64 tmp/$$user-mdp.txt
__                               | # contains the $$user password
__                               | # encrypted using his public ssh key
$(self) decrypt user=$$trigram   | # $(decrypt.help)
endef

help: $(self); @echo; echo '$($@)' | column -ts '|' | tr _ ' '

# https://gist.github.com/phrfpeixoto/8b04a2516ec559eddbfe7520ddde9ad2
