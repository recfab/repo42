#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm upgrade --install argocd argo/argo-cd \
    --version '4.9.4' \
    --namespace argocd \
    --create-namespace
