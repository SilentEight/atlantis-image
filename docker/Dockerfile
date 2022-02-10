ARG version=v0.18.2
FROM ghcr.io/runatlantis/atlantis:${version}

ENV HELM_VERSION=3.8.0 \
    TERRAGRUNT_VERSION=0.36.1 \
    TERRAGRUNT_ATLANTIS_CONFIG_VERSION=1.12.3 \
    TFSEC_VERSION=1.1.4 \
    TERRASCAN_VERSION=1.13.0 \
    SOPS_VERSION=3.7.1 \
    HELM_SECRETS_VERSION=3.12.0
RUN set -euo pipefail; \
    curl -LSso /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; \
    chmod +x /usr/local/bin/kubectl; \
    curl -fsSL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
        | tar -xzv --strip-components=1 -C /usr/local/bin linux-amd64/helm; \
    curl -LSso /usr/local/bin/terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"; \
    chmod +x /usr/local/bin/terragrunt; \
    curl -LSso /usr/local/bin/tfsec "https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64"; \
    chmod +x /usr/local/bin/tfsec; \
    curl -fsSL "https://github.com/accurics/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz" \
        | tar -xzvC /usr/local/bin terrascan; \
    curl -fsSL "https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64.tar.gz" \
        | tar -xzv --strip-components=1 -C /usr/local/bin terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64; \
    ln -s /usr/local/bin/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64 /usr/local/bin/terragrunt-atlantis-config; \
    curl -LSso /usr/local/bin/sops "https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux"; \
    chmod +x /usr/local/bin/sops

# Upgrade default Terraform to 1.1.5.
# NOTE(ahaczewski): Copy-paste adapted from https://github.com/runatlantis/atlantis/blob/master/Dockerfile#L16
ENV DEFAULT_TERRAFORM_VERSION=1.1.5
RUN set -euo pipefail; \
    rm /usr/local/bin/terraform1.1.*; \
    rm -rf /usr/local/bin/tf/versions/1.1.*; \
    curl -LOs https://releases.hashicorp.com/terraform/${DEFAULT_TERRAFORM_VERSION}/terraform_${DEFAULT_TERRAFORM_VERSION}_linux_amd64.zip; \
    curl -LOs https://releases.hashicorp.com/terraform/${DEFAULT_TERRAFORM_VERSION}/terraform_${DEFAULT_TERRAFORM_VERSION}_SHA256SUMS; \
    sed -n "/terraform_${DEFAULT_TERRAFORM_VERSION}_linux_amd64.zip/p" terraform_${DEFAULT_TERRAFORM_VERSION}_SHA256SUMS | sha256sum -c; \
    mkdir -p /usr/local/bin/tf/versions/${DEFAULT_TERRAFORM_VERSION}; \
    unzip terraform_${DEFAULT_TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/tf/versions/${DEFAULT_TERRAFORM_VERSION}; \
    ln -s /usr/local/bin/tf/versions/${DEFAULT_TERRAFORM_VERSION}/terraform /usr/local/bin/terraform${DEFAULT_TERRAFORM_VERSION}; \
    rm terraform_${DEFAULT_TERRAFORM_VERSION}_linux_amd64.zip; \
    rm terraform_${DEFAULT_TERRAFORM_VERSION}_SHA256SUMS; \
    ln -sf /usr/local/bin/tf/versions/${DEFAULT_TERRAFORM_VERSION}/terraform /usr/local/bin/terraform

USER atlantis

RUN set -euo pipefail; \
  helm plugin install https://github.com/jkroepke/helm-secrets --version v${HELM_SECRETS_VERSION}

USER root

# Set Terraform to non-interactive mode.
# See: https://www.terraform.io/docs/cli/config/environment-variables.html#tf_input
# See: https://terragrunt.gruntwork.io/docs/reference/cli-options/#terragrunt-non-interactive
ENV TF_INPUT=false

# Don't suggest commands to run next.
# See: https://www.terraform.io/docs/cli/config/environment-variables.html#tf_in_automation
ENV TF_IN_AUTOMATION=true

COPY docker-pre-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-pre-entrypoint.sh"]
CMD ["server"]
