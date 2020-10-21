# Junk Drawer

A collection of randoms things that don't have a better place to go.

## Ideas for projects

- "Linting" kubernetes manifests. Not sure if linting is the right word here. "Analyze"? "Audit"? Whatever. Point is: point tool at a folder of Kubernetes manifests, and it will analyze them as a group
  - broken references, like a Deployment referencing a ConfigMap that doesn't exist
  - orphaned resources, like a ConfigMap that's not used by any Deployments
