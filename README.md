# Repository 42

The answer to the infra, the apps and everything.

## Structure of repository

TODO Bring repo into alignment with this structure

- 📂 `.config/`
  - `dotnet-tools.json` - .NET commandline tools
- 📂 `.gitlab/`: CI/CD related stuff
  - 📂 `issue_templates/`
- 📂 `.vscode/` - config for [VS Code](https://code.visualstudio.com/)
- 📂 `dotfiles/` - my dotfiles
  - 📂 `bin/`
- 📂 `infra/` - infrastructure as code
- 📂 `notes/` - my notes, managed by [Dendron](https://wiki.dendron.so/).
- 📂 `tools/` - scripts for working with the repository itself
- 📂 `lab/` - experiments
- 📂 `src/` - application source code
- `.meta` - config file for [meta](https://github.com/mateodelnorte/meta)
- `.tools-versions` - config file for [asdf](https://asdf-vm.com/) (version manager)
- `cspell.json` - config file for [cspell](https://github.com/streetsidesoftware/cspell) (spellchecking code and text)
- `lefthook.yml` - config file for [lefthook](https://github.com/evilmartians/lefthook) (manage git hooks)

## Todo List

- TODO merge other repositories
  - infra
  - commonplace-book
- DONE document repo structure
- TODO document using .code-workspace files in this repo
- DONE Convert this README to markdown
- TODO Move ideas into Dendron

## Ideas for projects

- "Linting" kubernetes manifests. Not sure if linting is the right word here. "Analyze"? "Audit"? Whatever. Point is: point tool at a folder of Kubernetes manifests, and it will analyze them as a group
  - broken references, like a Deployment referencing a ConfigMap that doesn't exist
  - orphaned resources, like a ConfigMap that's not used by any Deployments
- Resource Roomba. Really broad concept, so might actually be multiple tools. Cleanup "dirt" from kubernetes
  - Delete the kind of thing found by the kubernetes linter
  - Delete resources for an environment that isn't associated with a branch in GitLab
- GitLab CI files in a non-shit language. Anything is better than YAML. Might rely heavily on scripts.
- Various graphics toys e.g. filigree, word art, other weird shit that looks cool.
- DeepThought LSP
  - or maybe just Asciidoc?
  - move sections up and down easily
- File Graph
  - I started an extension for Asciidoc Graph, but fuck it: let's do all files
- Asciidoc in FSharp
  - I checked the spec on the Eclipse Foundation GitLab
- Asciidoc linter
- Hygen templates
  - bash scripts
  - idea
  - daily note
- Org-mode but for Asciidoc

## Task list

- [ ] Bring notes back over from Deep Thought
- [ ] Turn the build green
- [ ] Setup Conventional Commits & Commit lint
  - How does this work when squashing-on-merge?
- [ ] Setup Fake
- [ ] Configure MR settings
  - Always squash
  - Cannot push to main
- [ ] Setup githooks using lefthook
  - not sure which hooks I should use off hand. Look this up later.
  - spelling
  - tests
  - linting
  - disallow push if there are any `--fixup` commits
- [ ] bring dotfiles in from Homesick project.
- I might want this repo to act as a portfolio
  - [ ] Research what would be visible by _Not Me_ if I make this repo public.
  I don't care if the source code is visible.
  I only care about notes that might have personal information e.g. my allergies and such
