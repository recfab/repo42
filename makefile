SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

lint: cspell shellcheck
.PHONY: lint

cspell:
> cspell lint --no-progress "**/*"
.PHONY: cspell

shellcheck:
> shellcheck ./**/*.sh
.PHONY: shellcheck

.tmp/sentinels/cspell.json: cspell.json
> jq 'select(.words | sort) | select(.dictionaries | sort)' $< > $@
> cp $@ $<
