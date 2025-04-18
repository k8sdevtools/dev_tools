#!/bin/bash

set -e

WEBHOOK_NAME=gitlab-workspaces-kubernetes-webhook
WEBHOOK_NAMESPACE=default

make gen-certs WEBHOOK_NAME=$WEBHOOK_NAME WEBHOOK_NAMESPACE=$WEBHOOK_NAMESPACE

CA_BUNDLE=$(base64 -w 0 < certs/ca.crt)

yq e ".webhooks[].clientConfig.caBundle = \"$CA_BUNDLE\"" -i dev/manifests/cluster-config/mutating.config.yaml
yq e ".webhooks[].clientConfig.caBundle = \"$CA_BUNDLE\"" -i dev/manifests/cluster-config/validating.config.yaml

echo "✅ caBundle injected successfully"