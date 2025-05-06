# CloudNativePG Helm Chart

This README provides instructions for installing [CloudNativePG](https://cloudnative-pg.io/) using Helm.

## Prerequisites

- [Helm 3.x](https://helm.sh/)
- Kubernetes cluster (v1.21+ recommended)

## Add the Helm Repository

```sh
helm repo add cnpg https://cloudnative-pg.github.io/charts
helm repo update
```

## Install CloudNativePG

```sh
helm upgrade --install cnpg \
  --namespace cnpg \
  --create-namespace \
  cnpg/cloudnative-pg --version 0.23.2
```

- `cnpg-operator`: Release name
- `cnpg/cloudnative-pg`: Chart name
- `--namespace cnpg-system`: Target namespace

## Upgrade

```sh
helm upgrade cnpg-operator cnpg/cloudnative-pg --namespace cnpg
```

## Uninstall

```sh
helm uninstall cnpg-operator --namespace cnpg
```

## Configuration

See [values.yaml](https://github.com/cloudnative-pg/charts/blob/main/charts/cloudnative-pg/values.yaml) for configurable parameters.

## Documentation

- [CloudNativePG Docs](https://cloudnative-pg.io/documentation/)
- [Helm Chart Source](https://github.com/cloudnative-pg/charts)