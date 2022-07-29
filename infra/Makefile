SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

PYTHON := python3
DIAGRAMS_SRC = $(wildcard diagrams/src/*.py)
DIAGRAMS := $(shell echo $(DIAGRAMS_SRC) | sed -r 's|/src/(\w+)\.py|/img/\1.png|g')

.PHONY: build meta

build: $(DIAGRAMS)

meta:
	@echo "DIAGRAMS_SRC : $(DIAGRAMS_SRC)"
	@echo "DIAGRAMS     : $(DIAGRAMS)"

diagrams/img/%.png: diagrams/src/%.py
	cd $(@D)
	$(PYTHON) ../src/$(<F)

