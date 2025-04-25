# CoreDNS Kubernetes Deployment

This directory contains Kubernetes manifests for deploying CoreDNS, a flexible, extensible DNS server that serves as the main DNS server for the staging environment.

## Deployment

To deploy CoreDNS to your Kubernetes cluster:

```bash
kubectl apply -f .
```

## Configuration

CoreDNS is configured through a Corefile, which is stored in a ConfigMap.

To customize the CoreDNS configuration, edit the ConfigMap before applying the manifests.

## References

- [CoreDNS GitHub Repository](https://github.com/coredns/coredns)
- [CoreDNS Documentation](https://coredns.io/manual/toc/)
- [CoreDNS in Kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/coredns/)
