#!/bin/dumb-init /bin/bash
set -e -o pipefail

if [[ -n "$GIT_REPOSITORY" && -n "$ATLANTIS_GITLAB_USER" && -n "$ATLANTIS_GITLAB_TOKEN" ]]; then
    echo "Configuring AWS SSM Git credential helper for Git repository: $GIT_REPOSITORY"

    git config --global \
        "credential.$GIT_REPOSITORY.helper" \
        '!bash -c "echo \"username=$ATLANTIS_GITLAB_USER\"; echo \"password=$ATLANTIS_GITLAB_TOKEN\""'

    echo "AWS SSM Git credential helper configured"
fi

echo "Starting Atlantis"

exec docker-entrypoint.sh "$@"
