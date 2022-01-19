#!/usr/bin/env bash

set -eu -o pipefail

echo "Configuring AWS SSM Git credential helper for Git repository: $GIT_REPOSITORY"
echo "Username SSM key: $GIT_USERNAME_SSM_KEY"
echo "Password SSM key: $GIT_PASSWORD_SSM_KEY"

git config --global "credential.$GIT_REPOSITORY.helper" "!bash aws-ssm-credential-helper.sh $GIT_USERNAME_SSM_KEY $GIT_PASSWORD_SSM_KEY"

echo "AWS SSM Git credential helper configured"
echo "Starting Atlantis"

docker-entrypoint.sh "$@"
