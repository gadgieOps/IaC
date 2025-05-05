# Setup Cert Manager

```bash
kubectl create serviceaccount issuer
kubectl get sa
kubectl apply -f secret.yaml
kubectl get secrets
kubectl describe secret issuer-token
kubectl get secret issuer-token -o jsonpath={.data.token} | base64 -d
```
