#!/usr/bin/env bash

# Implements Git Credential Helper protocol to pass username and password to Git repository
# based on the username and password in AWS System Manager Parameter Store.
#
# Based on https://github.com/samdengler/aws-ssm-git-credential-helper/blob/master/aws-ssm-credential-helper.sh
#

set -eu -o pipefail

prog=$(basename "$0")
usage="Usage: $prog <username_ssm_key> <password_ssm_key>"

if [[ $# -lt 2 ]]; then
  echo "$usage"; exit 1
fi
SSM_USERNAME_KEY=$1
SSM_PASSWORD_KEY=$2

SSM_USERNAME_VALUE=$(aws ssm get-parameter --with-decryption --name "$SSM_USERNAME_KEY" --output text --query Parameter.Value 2>/dev/null)
if [[ -z "$SSM_USERNAME_VALUE" ]]; then
  echo -e "invalid ssm_username_key: $SSM_USERNAME_KEY\naws ssm get-parameter --with-decryption --name \"$SSM_USERNAME_KEY\" --output text --query Parameter.Value"; exit 1
fi

SSM_PASSWORD_VALUE=$(aws ssm get-parameter --with-decryption --name "$SSM_PASSWORD_KEY" --output text --query Parameter.Value 2>/dev/null)
if [[ -z "$SSM_PASSWORD_VALUE" ]]; then
  echo -e "invalid ssm_password_key: $SSM_PASSWORD_KEY\naws ssm get-parameter --with-decryption --name \"$SSM_PASSWORD_KEY\" --output text --query Parameter.Value"; exit 1
fi

echo username=$SSM_USERNAME_VALUE
echo password=$SSM_PASSWORD_VALUE
