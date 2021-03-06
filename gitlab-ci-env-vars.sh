#!/usr/bin/env bash

CURRENT_DIR="$PWD"

random() {
  UPPER=${UPPER:-100}
  RANDOM_NUMBER=$(od -A n -t d -N 2 /dev/urandom |tr -d ' ')
  echo $(($RANDOM_NUMBER % $UPPER))
}

[ ! -z "$CI_PROJECT_DIR" -a -d "$CI_PROJECT_DIR/.git" ] && cd "$CI_PROJECT_DIR"

export CI_PROJECT_DIR=${CI_PROJECT_DIR:-"$(git rev-parse --show-toplevel)"}
#export CI=${CI:-"true"}
#export CI_DEBUG_TRACE=${CI_DEBUG_TRACE:-"true"}
#export CI_DEPLOY_FREEZE=${CI_DEPLOY_FREEZE:-"true"}
#export CI_COMMIT_REF_PROTECTED=${CI_COMMIT_REF_PROTECTED:-"true"}
[ ! -z "$CI_DEPLOY_FREEZE" ] && export CI_DEPLOY_USER=${CI_DEPLOY_USER:-"$(git log -1 --pretty=format:'%an')"}
export CI_PROJECT_REPOSITORY_LANGUAGES=${CI_PROJECT_REPOSITORY_LANGUAGES:-"ruby,javascript,html,css"}
export CI_COMMIT_TIMESTAMP=${CI_COMMIT_TIMESTAMP:-"$(git log -1 --format="%cd" --date="iso8601-strict")"}
export CI_COMMIT_MESSAGE=${CI_COMMIT_MESSAGE:-"$(git log -1 --pretty=%B)"}
[ "$(echo "$CI_COMMIT_MESSAGE" | wc -c)" -gt 1000 ] && export CI_COMMIT_DESCRIPTION=${CI_COMMIT_DESCRIPTION:-"$(echo "$CI_COMMIT_MESSAGE" | tail -n+2)"}  || export CI_COMMIT_DESCRIPTION=${CI_COMMIT_DESCRIPTION:-"$CI_COMMIT_MESSAGE"}
export CI_COMMIT_TITLE=${CI_COMMIT_TITLE:-"$(echo "$CI_COMMIT_MESSAGE" | head -n1)"}
export CI_COMMIT_AUTHOR=${CI_COMMIT_AUTHOR:-"$(git log -1 --pretty=format:'%an') <$(git log -1 --pretty=format:'%ae')>"}
export CI_COMMIT_SHA=${CI_COMMIT_SHA:-"$(git rev-parse HEAD)"}
export CI_COMMIT_SHORT_SHA=${CI_COMMIT_SHORT_SHA:-"$(git rev-parse --short HEAD)"}
export CI_COMMIT_BEFORE_SHA=${CI_COMMIT_BEFORE_SHA:-"$(git rev-parse ${CI_COMMIT_SHA}^1)"}
export CI_COMMIT_REF_NAME=${CI_COMMIT_REF_NAME:-"$(git rev-parse --abbrev-ref HEAD)"}
export CI_COMMIT_REF_SLUG=${CI_COMMIT_REF_SLUG:-"$(echo "${CI_COMMIT_REF_NAME:0:63}" | tr '[[:upper:]]' '[[:lower:]]' | sed 's|[^a-z0-9]|-|g' | sed -e 's/^-*//' -e 's/-*$//')"}
export CI_COMMIT_TAG=${CI_COMMIT_TAG:-"$(git tag --points-at HEAD)"}
export CI_PROJECT_URL=${CI_PROJECT_URL:-"$(git remote get-url origin --push | sed -r 's:git@([^/]+)\:(.*\.git):https\://\1/\2:g' | sed 's|\.git$||')"}
export CI_REPOSITORY_URL=${CI_REPOSITORY_URL:-"$(git remote get-url origin --push | sed -r 's:git@([^/]+)\:(.*\.git):https\://\1/\2:g')"}
export CI_REGISTRY=${CI_REGISTRY:-"registry.$(echo "$CI_REPOSITORY_URL" | awk -F[/:] '{print $4}')"}
export CI_REGISTRY_IMAGE=${CI_REGISTRY_IMAGE:-"${CI_PROJECT_NAMESPACE}"}
export CI_PROJECT_ROOT_NAMESPACE=${CI_PROJECT_ROOT_NAMESPACE:-"$(echo "$CI_PROJECT_URL" | cut -d'/' -f4)"}
export CI_PROJECT_NAMESPACE=${CI_PROJECT_NAMESPACE:-"$(echo "$CI_PROJECT_URL" | sed 's|http[s]*://\(.*\)/.*$|\1|' | cut -f2- -d'/')"}
export CI_PROJECT_NAME=${CI_PROJECT_NAME:-"$(echo "$CI_PROJECT_URL" | sed 's#.*/##')"}
export CI_PROJECT_PATH=${CI_PROJECT_PATH:-"${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}"}
export CI_PROJECT_PATH_SLUG=${CI_PROJECT_PATH_SLUG:-"$(echo "$CI_PROJECT_PATH" | tr '[[:upper:]]' '[[:lower:]]' | sed 's|[^a-z0-9]|-|g')"}
export CI_PAGES_DOMAIN=${CI_PAGES_DOMAIN:-"gitlab.io"}
export CI_PAGES_URL=${CI_PAGES_URL:-"https://${CI_PROJECT_ROOT_NAMESPACE}.${CI_PAGES_DOMAIN}/${CI_PROJECT_NAMESPACE#"$CI_PROJECT_ROOT_NAMESPACE/"}/${CI_PROJECT_NAME}"}
export CI_PROJECT_ID=${CI_PROJECT_ID:-"34"}
export CI_JOB_ID=${CI_JOB_ID:-"$(random 100)"}
export CI_RUNNER_ID=${CI_RUNNER_ID:-"$(random 10)"}
export CI_PIPELINE_ID=${CI_PIPELINE_ID:-"$(random 1000)"}
export CI_PIPELINE_IID=${CI_PIPELINE_IID:-"$(random 10)"}
export CI_CONFIG_PATH=${CI_CONFIG_PATH:-".gitlab-ci.yml"}
export CI_DEFAULT_BRANCH=${CI_DEFAULT_BRANCH:-"$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')"}
export CI_REGISTRY_USER=${CI_REGISTRY_USER:-"gitlab-ci-token"}
export CI_RUNNER_DESCRIPTION=${CI_RUNNER_DESCRIPTION:-"my runner"}
export CI_RUNNER_TAGS=${CI_RUNNER_TAGS:-"docker, linux"}
export CI_SERVER=${CI_SERVER:-"yes"}
export CI_SERVER_PROTOCOL=${CI_SERVER_PROTOCOL:-"https"}
export CI_SERVER_HOST=${CI_SERVER_HOST:-"gitlab.com"}
export CI_SERVER_URL=${CI_SERVER_URL:-"${CI_SERVER_PROTOCOL}://${CI_SERVER_HOST}"}
export CI_SERVER_PORT=${CI_SERVER_PORT:-"443"}
export CI_SERVER_NAME=${CI_SERVER_NAME:-"GitLab"}
export CI_SERVER_REVISION=${CI_SERVER_REVISION:-"70606bf"}
export CI_SERVER_VERSION_MAJOR=${CI_SERVER_VERSION_MAJOR:-"8"}
export CI_SERVER_VERSION_MINOR=${CI_SERVER_VERSION_MINOR:-"9"}
export CI_SERVER_VERSION_PATCH=${CI_SERVER_VERSION_PATCH:-"0"}
export CI_SERVER_VERSION=${CI_SERVER_VERSION:-"${CI_SERVER_VERSION_MAJOR}.${CI_SERVER_VERSION_MINOR}.${CI_SERVER_VERSION_PATCH}"}
export CI_API_V4_URL=${CI_API_V4_URL:-"${CI_SERVER_URL}/api/v4"}
export CI_ENVIRONMENT_NAME=${CI_ENVIRONMENT_NAME:-""}
export CI_ENVIRONMENT_SLUG=${CI_ENVIRONMENT_SLUG:-"$(echo "${CI_ENVIRONMENT_NAME:0:24}" | tr '[[:upper:]]' '[[:lower:]]' | sed 's|[^a-z0-9]|-|g')"}
export CI_ENVIRONMENT_URL=${CI_ENVIRONMENT_URL:-""}
export CI_REGISTRY_USER=${CI_REGISTRY_USER:-""}

cd "$CURRENT_DIR"

# If this script is not being sourced print out the variables
(return 0 2>/dev/null) && SOURCED=1 || SOURCED=0
[ "$SOURCED" -eq 0 ] && printenv | grep "CI_" || true
