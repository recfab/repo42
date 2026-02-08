# Infrastructure

Using DigitalOcean

## Planned Infra

- Kubernetes cluster
  - gitlab-agent
  - ArgoCD
  - Gitlab Runners
  - FusionAuth
  - Prometheus
  - Grafana
  - Ingress controller (NGINX?)
  - Istio
- Database server
- VPC
- domain: recfab.net
  - subdomains
    - dev.recfab.net
    - ci.recfab.net

## Pipeline design

- init
- validate
- plan
- apply
  - automatically in MR
  - manual on main
- destroy
  - when merge the MR
