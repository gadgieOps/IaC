# Installing GitLab Redis with Helm

Refer to the official documentation for more details:  
<https://arc.net/l/quote/irfaopjd>

To install the GitLab Redis instance using Helm, run the following command:

```sh
helm upgrade gl-redis ot-helm/redis --install --namespace gitlab
```

This command will install (or upgrade) the Redis instance in the `gitlab` namespace using the `ot-helm/redis` chart.
