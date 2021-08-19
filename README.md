# Yggdrasil

The World Tree, i.e. where I keep most of my personal code.

## Ideas for projects

- "Linting" kubernetes manifests. Not sure if linting is the right word here. "Analyze"? "Audit"? Whatever. Point is: point tool at a folder of Kubernetes manifests, and it will analyze them as a group
  - broken references, like a Deployment referencing a ConfigMap that doesn't exist
  - orphaned resources, like a ConfigMap that's not used by any Deployments
- Resource Roomba. Really broad concept, so might actually be multiple tools. Cleanup "dirt" from kubernetes
  - Delete the kind of thing found by the kubernetes linter
  - Delete resources for an environment that isn't associated with a branch in GitLab
- GitLab CI files in a non-shit language. Anything is better than YAML. Might rely heavily on scripts.
- Various graphics toys e.g. filigree, word art, other weird shit that looks cool.
