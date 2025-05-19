# GitLab Postgres Vault Secret Instructions

To create the secret in Vault, use the following command (replace `<USERNAME>` and `<PASSWORD>` with your actual credentials):

```sh
vault kv put kvv2/gl-pg-user/config username="<USERNAME>" password="<PASSWORD>"
```

**Note:** The username and password values have been redacted for security.vault kv put kvv2/gl-pg-user/config username="REDACTED" password="REDACTED"
