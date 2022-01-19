#!/usr/bin/env bash

# Implements Git Credential Helper protocol to pass username and password to Git repository
# based on the username and password in AWS System Manager Parameter Store.
#
# Based on https://github.com/samdengler/aws-ssm-git-credential-helper/blob/master/aws-ssm-credential-helper.sh
#

set -e -o pipefail

prog=$(basename "$0")
usage="Usage: $prog <username_ssm_key> <password_ssm_key>"

if [[ $# -lt 2 ]]; then
  echo "$usage"; exit 1
fi
SSM_USERNAME_KEY=$1
SSM_PASSWORD_KEY=$2
