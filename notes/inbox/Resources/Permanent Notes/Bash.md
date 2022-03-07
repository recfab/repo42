# Bash

i.e. Bourne-again Shell

## Tips

### Handling unset or empty variables

- `+` -- if the variable is set, use the substitution
- `-` -- if the variable is *not* set, use the substitution
- `:` -- handle empty string as though it were unset

When the variable is not set

```shell
$ unset VAR
$ echo ">${VAR+y}<"
><
$ echo ">${VAR:+y}<"
><
$ echo ">${VAR-y}<"
>y<
$ echo ">${VAR:-y}<"
>y<
```

When the variable is set to empty string

```shell
$ export VAR=''
$ echo ">${VAR+y}<"
>y<
$ echo ">${VAR:+y}<"
><
$ echo ">${VAR-y}<"
><
$ echo ">${VAR:-y}<"
>y<
```

When the variable is set to a non-empty string

```shell
$ export VAR='x'
$ echo ">${VAR+y}<"
>y<
$ echo ">${VAR:+y}<"
>y<
$ echo ">${VAR-y}<"
>x<
$ echo ">${VAR:-y}<"
>x<
```
