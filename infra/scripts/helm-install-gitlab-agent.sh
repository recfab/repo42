#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

helm repo add gitlab https://charts.gitlab.io
helm repo update
helm upgrade --install production gitlab/gitlab-agent \
    --namespace gitlab-agent \
    --create-namespace \
    --set image.tag=v15.0.0 \
    --set config.token="${GITLAB_AGENT_TOKEN}" \
    --set config.kasAddress=wss://kas.gitlab.com
