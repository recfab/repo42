#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

export CI_API_V4_URL="${CI_API_V4_URL:-https://gitlab.com/api/v4}"
export CI_ENVIRONMENT_SLUG=${CI_ENVIRONMENT_SLUG:-local-infra}
export CI_PROJECT_ID=${CI_PROJECT_ID:-21637940}

api_root="$CI_API_V4_URL/projects/$CI_PROJECT_ID"
address="$api_root/terraform/state/$CI_ENVIRONMENT_SLUG"

if [[ -z ${CI:+x} ]]; then
  username="recfab"
  password="$GITLAB_TOKEN"
else
  username="gitlab-ci-token"
  password="$CI_JOB_TOKEN"
fi

export TF_IN_AUTOMATION='true'
terraform init \
  -reconfigure \
  -backend-config="address=$address" \
  -backend-config="lock_address=$address/lock" \
  -backend-config="unlock_address=$address/lock" \
  -backend-config="username=$username" \
  -backend-config="password=$password" \
  -backend-config="lock_method=POST" \
  -backend-config="unlock_method=DELETE" \
  -backend-config="retry_wait_min=5"
