# Makefiles

- use Bash Strict Mode

The most important variables are:

- `$@` - the name of the target
- `@<` - the name of the first prerequisite
- `$^` - the name of all prerequisites, separated by spaces
- `$*` - the stem that was matched when using `%` patterns
- `$(@D)` - the directory part of the target

## Preamble

```makefile
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
```

## References
- Davis-Hansson, Jacob. “Your Makefiles Are Wrong.” _Jacob Davis-Hansson on Tech_ (blog), December 15, 2019. [https://tech.davis-hansson.com/p/make/](https://tech.davis-hansson.com/p/make/).
- “Automatic Variables.” In _GNU Make Manual_. Free Software Foundation. Accessed March 2, 2022. [https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html).