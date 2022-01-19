#!/bin/dumb-init /bin/bash
set -e -o pipefail

if [[ -n "$GIT_REPOSITORY" && -n "$GIT_USERNAME_SSM_KEY" && -n "$GIT_PASSWORD_SSM_KEY" ]]; then
    echo "Configuring AWS SSM Git credential helper for Git repository: $GIT_REPOSITORY"
    echo "Username SSM key: $GIT_USERNAME_SSM_KEY"
    echo "Password SSM key: $GIT_PASSWORD_SSM_KEY"

    git config --global \
        "credential.$GIT_REPOSITORY.helper" \
        "!bash aws-ssm-credential-helper.sh \"$GIT_USERNAME_SSM_KEY\" \"$GIT_PASSWORD_SSM_KEY\""

    echo "AWS SSM Git credential helper configured"
fi

echo "Starting Atlantis"

exec docker-entrypoint.sh "$@"
