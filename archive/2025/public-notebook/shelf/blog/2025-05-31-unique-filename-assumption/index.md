---
title: Obsidian assumes your note names are unique
aliases:
  - Unique Filename Assumption
date: 2025-05-31
tags:
  - ObsidianMd
---
# Obsidian assumes your note names are unique

Obsidian makes some assumptions about the shape of your notes.
One of those assumptions is that the names of your notes (i.e. the basename of the file without the `.md` extension) is unique across your vault, regardless of which folder it's in.
In fact, many people recommend using Obsidian without folders at all.
There is also a unique note core plugin that creates notes with a time stamp prefix.

I would say this is a "soft" assumption, meaning that you don't have to follow it, but Obsidian will be easier to use if you do.
<!-- truncate -->

## Adhering to the assumption

- 👍 When using the "Shortest path when possible" setting for wiki links, the. The link will be just the note name
- 👍 Lower cognitive load due not having to figure out which parent folder a note is in.  All the information is in the note name.
- 👎 Names can get long, and repetitive, especially when there is a natural folder hierarchy

## Diverging from the assumption

- 👍 File names can be shorter
- 👎 Wiki links will be longer and include folder name (but only for those notes that aren't unique)
- 👎 more work to share a note outside your vault without losing context (can be mitigated by metadata )
