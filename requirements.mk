#!/usr/bin/make -f

MAKEFLAGS += -Rr
SHELL := $(shell which bash)

top:; @date

main:; ansible-galaxy install $(FORCE) -r requirements.yml
.PHONY: main top

FORCE :=
force := FORCE := -f
vartar := force
$(vartar):; @: $(eval $($@))
