#!/bin/dumb-init /bin/bash
set -e -o pipefail

if [[ -n "$ATLANTIS_GITLAB_HOSTNAME" ]] && [[ -n "$ATLANTIS_GITLAB_USER" ]] && [[ -n "$ATLANTIS_GITLAB_TOKEN" ]]; then
    echo "Configuring AWS SSM Git credential helper for Git repository: $ATLANTIS_GITLAB_HOSTNAME"

    if [[ $(id -u) == 0 ]]; then
        gosu atlantis git config --global \
            "credential.https://$ATLANTIS_GITLAB_HOSTNAME.helper" \
            '!bash -c "echo \"username=$ATLANTIS_GITLAB_USER\"; echo \"password=$ATLANTIS_GITLAB_TOKEN\""'
    else
        git config --global \
            "credential.https://$ATLANTIS_GITLAB_HOSTNAME.helper" \
            '!bash -c "echo \"username=$ATLANTIS_GITLAB_USER\"; echo \"password=$ATLANTIS_GITLAB_TOKEN\""'
    fi

    echo "AWS SSM Git credential helper configured"
fi

echo "Starting Atlantis"

exec docker-entrypoint.sh "$@"
