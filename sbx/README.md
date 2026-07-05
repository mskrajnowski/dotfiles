# Docker Sandboxes

https://docs.docker.com/ai/sandboxes/

## Initial config

1. Login using a Docker account

   ```sh
   sbx login
   ```

2. Set the default policy and provide necessary secrets

   ```sh
   sbx-setup
   ```

   If you've already set a default policy run `sbx policy reset -f` and exit (CTRL+C) without choosing the default policy.

## Usage

To start an agent inside the current working directory

```sh
sbx-run .
```
