#!/bin/bash

set -e

CA_BUNDLE=$(base64 -w0 < certs/ca.crt)

for file in dev/manifests/cluster-config/*config.yaml; do
  echo "Patching $file"
  yq e ".webhooks[].clientConfig.caBundle = \"$CA_BUNDLE\"" -i "$file"
done