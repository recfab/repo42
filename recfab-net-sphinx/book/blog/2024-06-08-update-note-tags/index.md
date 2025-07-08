---
title: "How to bulk add tags to markdown frontmatter with YQ"
date: 2024-06-08T21:30:00-07:00
blogpost: true
tags:
- yq
---
# How to bulk add tags to markdown frontmatter with YQ

I keep my notes in markdown format, with tags stored in frontmatter.
Sometimes I need to apply a particular tag to all notes in a folder.
This post describes how to do that using [yq](https://mikefarah.gitbook.io/yq).

<!-- truncate -->

:::note
YQ may behave unexpectedly on markdown files that do not have any front matter defined.
See [How to ensure front matter exists in Markdown files](/blog/2024-06-08-ensure-markdown-frontmatter-exists/index.md) for a description of the problem and how to solve it.
:::

## The `--front-matter` flag

The `--front-matter` flag tell yq to read a YAML document from the start of a file. Pass `process` to this argument to print the entire file with transformed front matter; or `extract` to print just the transformed front matter.

For example, using `--front-matter=process`:

```shell
$ yq eval --front-matter=process '.' _example.md
---
title: "Example note"
tags: ['tag-a']
---

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nulla aliquet porttitor lacus luctus. Sagittis vitae et leo duis. Porta lorem mollis aliquam ut. Interdum varius sit amet mattis vulputate. Laoreet suspendisse interdum consectetur libero id faucibus nisl tincidunt. Maecenas sed enim ut sem viverra. Nunc ege lorem dolor sed. Neque sodales ut etiam sit amet. Sagittis id consectetur purus ut faucibus pulvinar elementum integer enim. In nisl nisi scelerisque eu.

```

And using `--front-matter=extract`:

```shell
yq eval --front-matter=extract '.' _example.md
---
title: "Example note"
tags: ['tag-a']
```

## Ensuring a tag exists in a file's front matter

I store tags in an array field in the front matter.
You can use the ['unique' operator](https://mikefarah.gitbook.io/yq/operators/unique) to add a tag only when it's not already present in the array.

:::warning
I don't totally understand the different between an operator and a function in yq, but for our purposes, it means we need to pipe a transformation into the unique operator, rather than call it like a function.

There is also `unique_by`, which is a function and is used for filtering an array of objects by one of the keys.
It is not used here.
:::

For example, to add a new tag, `tag-b`:

```shell
yq --front-matter=process '.tags = (.tags + "tag-b" | unique)' _example.md
---
title: "Example note"
tags: ['tag-a', 'tag-b']
---

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nulla aliquet porttitor lacus luctus. Sagittis vitae et leo duis. Porta lorem mollis aliquam ut. Interdum varius sit amet mattis vulputate. Laoreet suspendisse interdum consectetur libero id faucibus nisl tincidunt. Maecenas sed enim ut sem viverra. Nunc ege lorem dolor sed. Neque sodales ut etiam sit amet. Sagittis id consectetur purus ut faucibus pulvinar elementum integer enim. In nisl nisi scelerisque eu.
```

Whereas, trying to add `tag-a` to a note that already has it, will have no affect.

```shell
yq --front-matter=process '.tags = (.tags + "tag-a" | unique)' _example.md
---
title: "Example note"
tags: ['tag-a']
---

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nulla aliquet porttitor lacus luctus. Sagittis vitae et leo duis. Porta lorem mollis aliquam ut. Interdum varius sit amet mattis vulputate. Laoreet suspendisse interdum consectetur libero id faucibus nisl tincidunt. Maecenas sed enim ut sem viverra. Nunc ege lorem dolor sed. Neque sodales ut etiam sit amet. Sagittis id consectetur purus ut faucibus pulvinar elementum integer enim. In nisl nisi scelerisque eu.
```

## Ensuring the tag exists in multiple files

:::warning
This is not smart enough to handle hierarchical tags, as allowed in Obsidian.md.
For example, if a note has the `parent/child` tag, and you set `TAG_NAME=parent`, the note will have both tags:

```yaml
---
tags:
  - parent/child
  - parent
---
```
:::

We can combine `find`, with yq's `-i` flag to update multiple files in place with a single command.

To keep this easy to copy/paste, this script assumes you have set the `TAG_NAME` envvar to that tag you want to add

```shell
find . -name "*.md" -exec yq eval --front-matter=process '.tags = ((.tags // []) + env(TAG_NAME) | unique)' -i {} \;
```


## References

- [Front Matter](https://mikefarah.gitbook.io/yq/usage/front-matter) in the YQ manual
- [Unique operator](https://mikefarah.gitbook.io/yq/operators/unique) in the YQ manual
