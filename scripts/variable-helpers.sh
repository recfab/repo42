#! /usr/bin/env bash

set_common_ci_vars() {
  remote=$(git remote get-url origin)

  CI_PROJECT_NAME=$(echo "$remote" | awk -F '[:/.]' '{ print $(NF-1) }')
  CI_PROJECT_NAMESPACE=$(echo "$remote" | awk -F '[:/.]' '{ print $(NF-2) }')
  CI_PROJECT_DIR=$(git rev-parse --show-toplevel)
  CI_PROJECT_PATH='recfab/main'
  CI_PROJECT_PATH_SLUG="${CI_PROJECT_PATH//[^a-z09]/-}"

  CI_COMMIT_REF_NAME=$(git branch --show-current)
  CI_COMMIT_REF_SLUG="${CI_COMMIT_REF_NAME//[^a-z09]/-}"
  CI_COMMIT_SHA=$(git rev-parse HEAD)
  CI_COMMIT_SHORT_SHA=$(git rev-parse --short HEAD)
  CI_COMMIT_BEFORE_SHA=$(git rev-parse @~)
  CI_COMMIT_DESCRIPTION=$(git log -1 --pretty=%s)

  CI_REGISTRY="http://registry.example.com"
  CI_REGISTRY_IMAGE="$CI_REGISTRY/$CI_PROJECT_PATH"

  export CI_PROJECT_NAME
  export CI_PROJECT_NAMESPACE
  export CI_PROJECT_DIR
  export CI_PROJECT_PATH
  export CI_PROJECT_PATH_SLUG

  export CI_COMMIT_REF_NAME
  export CI_COMMIT_REF_SLUG
  export CI_COMMIT_SHA
  export CI_COMMIT_SHORT_SHA
  export CI_COMMIT_BEFORE_SHA
  export CI_COMMIT_DESCRIPTION

  export CI_REGISTRY
  export CI_REGISTRY_IMAGE
}

set_env_ci_vars() {
  CI_ENVIRONMENT_NAME="review/$CI_COMMIT_REF_SLUG"
  CI_ENVIRONMENT_SLUG="${CI_ENVIRONMENT_NAME//[^a-z09]/-}"
  CI_ENVIRONMENT_URL="https://example.com/$CI_COMMIT_REF_SLUG"

  export CI_ENVIRONMENT_NAME
  export CI_ENVIRONMENT_SLUG
  export CI_ENVIRONMENT_URL
}

print_ci_vars_by_prefix() {
  prefix="$1"
  title="$2"

  printf "\e[4m%s\e[0m\n" "$title"
  set | grep -E -e "^$prefix.*=" |
    awk -F '[=]' '{ printf "\033[2m%-30s\033[0m %s\n", $1, $2 }'
  echo
}

print_project_ci_vars() {
  print_ci_vars_by_prefix 'CI_PROJECT' 'GitLab predefined variables: Project'
}

print_commit_ci_vars() {
  print_ci_vars_by_prefix 'CI_COMMIT' 'GitLab predefined variables: Commit'
}

print_registry_ci_vars() {
  print_ci_vars_by_prefix 'CI_REGISTRY' 'Gitlab predefined variables: Registry'
}

print_environment_ci_vars() {
  print_ci_vars_by_prefix 'CI_ENVIRONMENT_' 'GitLab predefined variables: Environment'
}
