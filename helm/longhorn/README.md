# Longhorn Installation via Helm

This guide explains how to install [Longhorn](https://longhorn.io/) using Helm.

## Prerequisites

- Kubernetes cluster (v1.18+)
- `kubectl` configured
- [Helm 3](https://helm.sh/docs/intro/install/) installed

## Add Longhorn Helm Repository

```sh
helm repo add longhorn https://charts.longhorn.io
helm repo update
```

## Useful commands

```sh
# Install
helm install longhorn longhorn/longhorn --namespace longhorn --create-namespace --version 1.8.1 -f values.yml

# Upgrade
helm upgrade longhorn longhorn/longhorn --namespace longhorn -f values.yml

# Uninstall
helm uninstall longhorn --namespace longhorn
kubectl delete namespace longhorn
```

## Documentation

See the [official Longhorn documentation](https://longhorn.io/docs/) for advanced configuration and troubleshooting.