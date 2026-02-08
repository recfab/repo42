#! /usr/bin/env sh

set -o errexit
set -o nounset

thisDir=$(dirname "$0")

# shellcheck source=lab/variable-helpers.sh
. "$thisDir/variable-helpers.sh"

if [ -z ${CI+x} ]; then
  echo "💡 Because you are not running in a CI/CD pipeline, I presume that you are developing this script. I will set some variables for you to make that easier."
  echo

  set_common_ci_vars
  set_env_ci_vars
fi

print_project_ci_vars
print_commit_ci_vars
print_registry_ci_vars
print_environment_ci_vars

K8S_DIR="$CI_PROJECT_DIR/k8s"
BUILD_DIR="$CI_PROJECT_DIR/build"

GEN_DIR="$BUILD_DIR/kustomize"
mkdir -p "$GEN_DIR"

GEN_FILE="$GEN_DIR/kustomization.yaml"

rm -f "$GEN_FILE"
touch "$GEN_FILE"

BASE="$K8S_DIR"

REL_BASE="$(realpath "$BASE" -m --relative-to="$GEN_DIR")"

print_ci_vars_by_prefix '(K8S_DIR|BUILD_DIR|BASE|REL_BASE|GEN_)' "My vars"

yq w -i "$GEN_FILE" 'bases[+]' "$REL_BASE"

yq w -i "$GEN_FILE" 'commonAnnotations[app.kubernetes.io/version]' "$CI_COMMIT_SHORT_SHA"
yq w -i "$GEN_FILE" 'commonAnnotations[app.gitlab.com/env]' "$CI_ENVIRONMENT_NAME"
yq w -i "$GEN_FILE" 'commonAnnotations[app.gitlab.com/app]' "$CI_PROJECT_PATH_SLUG"

yq w -i "$GEN_FILE" 'images[+].name' 'blog'
yq w -i "$GEN_FILE" 'images(name==blog).newName' "$CI_REGISTRY_IMAGE/blog"
yq w -i "$GEN_FILE" 'images(name==blog).newTag' "$CI_COMMIT_REF_SLUG"
