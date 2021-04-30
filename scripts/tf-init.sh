#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

tf_state_name="$CI_COMMIT_REF_SLUG"
export TF_HTTP_ADDRESS="https://gitlab.com/api/v4/projects/$CI_PROJECT_ID/terraform/state/$tf_state_name"

export TF_HTTP_USERNAME="$CI_DEPLOY_USER"
export TF_HTTP_PASSWORD="$CI_DEPLOY_PASSWORD"

export TF_HTTP_LOCK_ADDRESS="$TF_HTTP_ADDRESS/lock"
export TF_HTTP_UNLOCK_ADDRESS="$TF_HTTP_ADDRESS/lock"
export TF_HTTP_LOCK_METHOD='POST'
export TF_HTTP_UNLOCK_METHOD='DELETE'

terraform init
