#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

TARGET="${1}"

CI_COMMIT_REF_NAME=$(git branch --show-current)
CI_COMMIT_REF_SLUG="${CI_COMMIT_REF_NAME//[^a-z09]/-}"

export CI_COMMIT_REF_NAME
export CI_COMMIT_REF_SLUG

export CI_PROJECT_ID=${CI_PROJECT_ID:-21637940}
export CI_API_V4_URL="${CI_API_V4_URL:-https://gitlab.com/api/v4}"

export ENV="$CI_COMMIT_REF_SLUG"
export STACK='default'
export REGION='sfo3'
export TF_STATE_NAME="${ENV}-${REGION}-${STACK}"

api_root="$CI_API_V4_URL/projects/$CI_PROJECT_ID"
address="$api_root/terraform/state/$TF_STATE_NAME"

if [[ -z ${CI:+x} ]]; then
    username="recfab"
    password="$GITLAB_TOKEN"
else
    username="gitlab-ci-token"
    password="$CI_JOB_TOKEN"
fi

export TF_IN_AUTOMATION='true'
terraform -chdir="$TARGET" \
    init \
    -reconfigure \
    -upgrade \
    -backend-config="address=$address" \
    -backend-config="lock_address=$address/lock" \
    -backend-config="unlock_address=$address/lock" \
    -backend-config="username=$username" \
    -backend-config="password=$password" \
    -backend-config="lock_method=POST" \
    -backend-config="unlock_method=DELETE" \
    -backend-config="retry_wait_min=5"
