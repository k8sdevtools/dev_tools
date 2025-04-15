#!/bin/bash

set -e

export WEBHOOK_NAME=gitlab-workspaces-kubernetes-webhook
export WEBHOOK_NAMESPACE=default

CA_BUNDLE=$(base64 -w0 < certs/ca.crt)

patch_webhook_yaml() {
  local file="$1"
  echo "Patching $file with CA bundle"
  yq e ".webhooks[].clientConfig.caBundle = \"$CA_BUNDLE\"" -i "$file"
}

patch_webhook_yaml dev/manifests/cluster-config/mutating.config.yaml
patch_webhook_yaml dev/manifests/cluster-config/validating.config.yaml
