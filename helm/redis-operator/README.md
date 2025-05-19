# Installing the Redis Operator

For detailed instructions, refer to the official guide: [Redis Operator Installation Instructions](https://arc.net/l/quote/xeonywdw)

To install the Redis Operator using Helm, follow these steps:

1. Add the Helm repository:

    ```sh
    helm repo add ot-helm https://ot-container-kit.github.io/helm-charts/
    ```

2. Install or upgrade the Redis Operator

    ```sh
    helm upgrade redis-operator ot-helm/redis-operator --create-namespace --install --namespace redis
    ```

This will create the `redis` namespace (if it doesn't exist) and deploy the Redis Operator into your Kubernetes cluster.
