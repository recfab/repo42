---
title: "Issues with using subtrees in my notes"
created_at: 2024-07-15T22:10:00-07:00
blogpost: true
tags:
  - MyNotes
  - ObsidianMd
---
# Issues with using subtrees in my notes

I manage my notes with Obsidian and store them in git.
I have some notes that I share between home and work, and others that I only access via personal devices.
I used to manage these shared notes with submodules, but recently switched so sub trees.
However, I ran into some issues that have me considering switching back to submodules.

<!-- truncate -->
## My repository structure

I currently separate my notes into "workspaces" and "domains".
I have 5 repositories:

- 2 workspaces
  - `personal-notes-workspace`
  - `work-notes-workspace`
- 3 Domains
  - `personal-notes`
  - `work-notes`
  - `shared-notes`

In `personal-notes-workspace` I use the `personal-notes`, `work-notes`, and `shared-notes` domains.
In `work-notes-workspace` I use the `work-notes` and `shared-notes` domains.

## Why did I switch to subtrees in the first place?

Mobile support and Obsidian, basically.

The Obsidian Git plugin has support, but it's a little buggy.
That's not that big of a deal on a laptop as I can work around this with scripts.

On Mobile, this plugin doesn't work, at least not with my git client, _Working Copy_.
Instead, in Working Copy, I "link" the repo to a folder that Obsidian can access, and I have an iOS Shortcut to easily back them up.
However, I kept running weird errors with the submodules, and Working Copy doesn't have any options in iOS Shortcuts to work around them.

I don't do much organizing or processing of notes from my phone, but I do a lot of brain dumping.
These brain dumps go into `personal/stream/year/`, with a timestamp filename.
Since `personal` maps to the `personal-notes` domain repo, this workflow basically always breaks.

I suspect that if I understood submodules better, I could work around this as well, but subtrees seemed like a simpler solution.

## What happened?

I ran into a pretty big issue with syncing notes between my `work-notes-workspace` and `work-notes` domain repo.
I had pushed files to `work-notes` and later changed them.
Because the work trees are separate, those files had conflicts that would not have happened with submodules
Also, it dumped the contents into the root so `work/projects` got dumped into `projects`, etc.
I'm not sure how much of this is subtrees vs my using them wrong.

I think ultimately this isn't the right usecase for subtrees.
Based on [one article I read](https://www.atlassian.com/git/tutorials/git-subtree), it seems like the main usecases are 1) publishing a readonly copy of part of your monorepo or 2) vendoring.
That is to say: `subtree push` or `subtree pull` based workflows, but not both.
Or at least not nearly as often as I need to.

I would prefer having full, independent git histories; it's the implementation of submodules that's wonky, not the semantics.
Something like [meta](https://github.com/mateodelnorte/meta) might work as well.
In the meantime, I've changed my push script to simulate `subtree push --force` (which doesn't exist) by using `subtree split` and `subtree push` together.
I haven't tried my pull script again.
