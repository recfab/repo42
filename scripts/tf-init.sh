#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

export CI_PROJECT_ID=${CI_PROJECT_ID:-21637940}
export CI_COMMIT_REF_SLUG=${CI_COMMIT_REF_SLUG:-main}

tf_state_name="$CI_COMMIT_REF_SLUG"
export TF_HTTP_ADDRESS="https://gitlab.com/api/v4/projects/$CI_PROJECT_ID/terraform/state/$tf_state_name"

if [[ -z ${CI_JOB_TOKEN:+x} ]]; then
  export TF_HTTP_USERNAME="recfab"
  export TF_HTTP_PASSWORD="$GITLAB_TOKEN"
else
  export TF_HTTP_USERNAME="gitlab-ci-token"
  export TF_HTTP_PASSWORD="$CI_JOB_TOKEN"
fi

export TF_HTTP_LOCK_ADDRESS="$TF_HTTP_ADDRESS/lock"
export TF_HTTP_UNLOCK_ADDRESS="$TF_HTTP_ADDRESS/lock"
export TF_HTTP_LOCK_METHOD='POST'
export TF_HTTP_UNLOCK_METHOD='DELETE'

terraform init

terraform plan -out plan.tfplan
