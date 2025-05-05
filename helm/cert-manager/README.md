# Install Jetstack Cert Manager

## Based On

<https://cert-manager.io/docs/installation/helm/>

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
    cert-manager jetstack/cert-manager \
    --namespace cert-manager --create-namespace \
    --version v1.11.0 --set installCRDs=true
kubectl get crds
kubectl get po -n cert-manager
```
