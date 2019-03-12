#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

sed := /_ansible_verbose_always/s/^/\#/

to := plugins/action/assert.py
from := $(ANSIBLE_HOME)/lib/ansible/plugins/action/assert.py

$(to): $(from); sed -e $(sed) $< > $@

main: $(to)

.PHONY: top main
