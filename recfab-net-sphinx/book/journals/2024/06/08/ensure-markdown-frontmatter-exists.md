---
title: How to ensure front matter exists in Markdown files
date: 2024-06-08T20:47:00-07:00
---
YQ supports operating and transforming YAML front matter via the [--front-matter](https://mikefarah.gitbook.io/yq/usage/front-matter) flag.

For example, when using a file that has front matter, yq can extract the YAML correctly:

```shell
$ yq --front-matter=extract '.' ./with-frontmatter.md.txt
---
key: value
```

However, it behaves unexpectedly when the file does not have any front matter.

<!-- truncate -->
## Demonstrating the problem

When using a file without front matter, yq will treat the entire file as front matter.

```shell
$ yq --front-matter=extract '.' ./without-frontmatter.md.txt
# Lorem ipsum dolor sit amet

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quis blandit turpis cursus in hac habitasse platea dictumst. Amet justo donec enim diam. Nam aliquam sem et tortor consequat id. Tincidunt lobortis feugiat vivamus at. Leo vel orci porta non pulvinar neque laoreet. Pellentesque habitant morbi tristique senectus. Maecenas volutpat blandit aliquam etiam erat velit scelerisque. Fringilla est ullamcorper eget nulla facilisi etiam. Egestas sed tempus urna et pharetra pharetra. Condimentum id venenatis a condimentum vitae sapien pellentesque. Ut faucibus pulvinar elementum integer enim neque. Morbi non arcu risus quis varius quam. Elementum integer enim neque volutpat ac tincidunt vitae. Imperdiet proin fermentum leo vel orci porta. Nunc scelerisque viverra mauris in aliquam sem fringilla ut. Amet facilisis magna etiam tempor orci eu lobortis elementum. Duis ultricies lacus sed turpis tincidunt id aliquet risus feugiat.
```

Further, when that file starts with a markdown list, yq will fail to parse it entirely

```shell
$ cat ./without-frontmatter-start-with-list.md.txt
# Lorem ipsum dolor sit amet

- Lorem ipsum dolor sit amet,
- consectetur adipiscing elit,
- sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

Quis blandit turpis cursus in hac habitasse platea dictumst. Amet justo donec enim diam. Nam aliquam sem et tortor consequat id. Tincidunt lobortis feugiat vivamus at. Leo vel orci porta non pulvinar neque laoreet. Pellentesque habitant morbi tristique senectus. Maecenas volutpat blandit aliquam etiam erat velit scelerisque. Fringilla est ullamcorper eget nulla facilisi etiam. Egestas sed tempus urna et pharetra pharetra. Condimentum id venenatis a condimentum vitae sapien pellentesque. Ut faucibus pulvinar elementum integer enim neque. Morbi non arcu risus quis varius quam. Elementum integer enim neque volutpat ac tincidunt vitae. Imperdiet proin fermentum leo vel orci porta. Nunc scelerisque viverra mauris in aliquam sem fringilla ut.

$ yq --front-matter=process '.' ./without-frontmatter-start-with-list.md.txt
Error: bad file '/var/folders/4v/gx73n44s2rzcjtf_f27g0c8m0000gn/T/temp66459618': yaml: line 6: could not find expected ':'
```

## Fixing the problem

This solution uses the `globstar` option, which requires at least version 4.0 of Bash.

The following script takes a path, finding any `.md` files under that path and for any such files which do not start with the literal string `---`, will add empty front matter i.e. `---\n---\n` to the start of the file.

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

target_dir="$1"

shopt -s globstar nullglob
for file in "$target_dir"/**/*.md
do
  first_line=$(head -1 "$file")
  if [[ $first_line != '---' ]]; then
    sed -e '1s/^/---\n---\n/' -i '' "$file"
  fi
done
```

You can save it as `ensure-frontmatter-exists.sh` and call it with `./ensure-frontmatter-exists.sh path/to/your/notes`.
