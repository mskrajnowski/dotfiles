# Docker Sandboxes

https://docs.docker.com/ai/sandboxes/

## Initial config

1. Login using a Docker account

   ```sh
   sbx login
   ```

2. Set the default policy

   ```sh
   sbx-set-policy
   ```

   If you've already set a default policy run `sbx policy reset -f` and exit (CTRL+C) without choosing the default policy.

3. Set custom credentials needed for some MCP tools

   ```sh
   sbx secret set-custom -g --placeholder 'ctx7sk-proxy-managed' --host mcp.context7.com
   ```

## Usage

To start an agent inside the current working directory

```sh
sbx-run .
```
