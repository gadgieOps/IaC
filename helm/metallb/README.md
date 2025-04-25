# MetalLB Helm Chart

## Overview

MetalLB is a load-balancer implementation for bare metal Kubernetes clusters. This directory contains Helm chart configurations for deploying MetalLB in a Kubernetes cluster.

## Installation Instructions

[Installation Documentation](https://metallb.universe.tf/installation/)

```bash
helm install metallb metallb/metallb --create-namespace -n metallb --version 0.14.9
```

## Configuration

For detailed configuration options, refer to the [official MetalLB documentation](https://metallb.universe.tf/configuration/).

## Troubleshooting

If you encounter issues, check the MetalLB controller and speaker logs:

```bash
kubectl logs -n metallb-system -l app=metallb,component=controller
kubectl logs -n metallb-system -l app=metallb,component=speaker
```

## Uninstallation

To uninstall MetalLB:

```bash
helm uninstall metallb -n metallb-system
```

## Additional Resources

- [MetalLB Official Documentation](https://metallb.universe.tf/)
- [MetalLB GitHub Repository](https://github.com/metallb/metallb)