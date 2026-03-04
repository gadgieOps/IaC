#!/bin/bash

# Generate Talos configuration
talosctl gen config talos-dev "https://talos-dev.${TF_VAR_hosted_zone}:6443" --output-dir _out --force

# Set talosctl to use the cluster
talosctl config merge _out/talosconfig
talosctl config endpoint talos-dev-1.${TF_VAR_hosted_zone}
talosctl config node talos-dev-1.${TF_VAR_hosted_zone}

# Bootstrap cluster
talosctl bootstrap --nodes talos-dev-1.${TF_VAR_hosted_zone}