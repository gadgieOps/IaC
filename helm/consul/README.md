# Consul Helm Chart Setup

This directory contains the Helm chart configuration for installing Consul, designed to work as a backend for Vault.

## Overview

Consul serves as a service mesh and distributed key-value store that provides a reliable way to connect, secure, and configure applications across modern runtime platforms. In this setup, it's specifically configured to function as a backend storage for HashiCorp Vault.

## Installation

To install Consul using this Helm chart:

```bash
# Install
 helm install consul hashicorp/consul --create-namespace -n consul --version 1.6.3 -f values.yml

# Update values
helm upgrade consul hashicorp/consul -n consul -f values.yml

#Uninstall
helm uninstall consul hashicorp/consul -n consul
```

## Configuration

The `values.yaml` file contains the customized configuration for Consul. Modify this file to adjust settings according to your environment requirements.

## Vault Integration

This Consul deployment is specifically configured to work as a backend for HashiCorp Vault. For detailed implementation guidelines and best practices, refer to the [official documentation on Consul backend for Vault](https://arc.net/l/quote/madcxekt).

## Troubleshooting

For common issues and troubleshooting steps, consult the [Consul documentation](https://www.consul.io/docs/troubleshoot).
