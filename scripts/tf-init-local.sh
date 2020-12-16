#! /usr/bin/env bash

thisDir=$(dirname "$0")
terraformDir=$(realpath "$thisDir/../terraform")

PROJECT_ID='21637940'
TF_STATE_NAME='default'
TF_USERNAME='recfab'
TF_PASSWORD="$GITLAB_ACCESS_TOKEN"
TF_ADDRESS="https://gitlab.com/api/v4/projects/${PROJECT_ID}/terraform/state/$TF_STATE_NAME"

pushd "$terraformDir" || exit

terraform init \
    -backend-config=address=${TF_ADDRESS} \
    -backend-config=lock_address=${TF_ADDRESS}/lock \
    -backend-config=unlock_address=${TF_ADDRESS}/lock \
    -backend-config=username=${TF_USERNAME} \
    -backend-config=password="${TF_PASSWORD}" \
    -backend-config=lock_method=POST \
    -backend-config=unlock_method=DELETE \
    -backend-config=retry_wait_min=5

popd || exit
