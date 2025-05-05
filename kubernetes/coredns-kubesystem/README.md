# Patch kube-system DNS

This patch allows pods to lookup gadgieops.yem records. This is a chicken and egg fixer after the DNS service has been created.

```bash
kubectl patch configmap coredns --patch-file patch.yml --namespace kube-system
```
