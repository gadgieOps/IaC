#!/bin/bash

# Generate Talos configuration
talosctl gen config talos-dev "https://talos-dev.${TF_VAR_hosted_zone}:6443" \
    --with-examples=false \
    --with-docs=false \
    --with-kubespan \
    --install-disk /dev/xvda \
    --config-patch '@machine-config.yaml' \
    --additional-sans "talos-dev.${TF_VAR_hosted_zone}" \
    --additional-sans "talos-dev-1.${TF_VAR_hosted_zone}" \
    --output-dir _out --force
rm -f ~/.talos/config
talosctl config merge _out/talosconfig


talosctl config endpoint talos-dev.${TF_VAR_hosted_zone}
talosctl config node talos-dev-1.${TF_VAR_hosted_zone}




talosctl bootstrap


 talosctl kubeconfig /Users/dave/Projects/gadgieOps/home-iac/kubernetes/.kubeconfig