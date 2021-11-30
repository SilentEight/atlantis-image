ARG version=v0.17.5
FROM ghcr.io/runatlantis/atlantis:${version}

ENV HELM_VERSION=3.7.1 \
    TERRAGRUNT_VERSION=0.35.8 \
    TERRAGRUNT_ATLANTIS_CONFIG_VERSION=1.9.2 \
    TFSEC_VERSION=0.61.3 \
    TERRASCAN_VERSION=1.12.0 \
    SOPS_VERSION=3.7.1 \
    HELM_SECRETS_VERSION=3.11.0
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
