---
name: sbx
description: Operating rules for the Docker sandboxed VM (Docker Sandboxes/sbx). Use when sandbox constraints, host access, file exchange with the developer, network policy or blocked requests, publishing/forwarding ports, sudo/package installation, or "why can't you see my machine" questions are relevant.
---

# Docker sandbox environment

This agent runs inside a Docker sandbox (`sbx`): a microVM with its own filesystem and its own Docker daemon. See <https://docs.docker.com/ai/sandboxes/>.

Unless stated otherwise, `sbx ...` commands in this document are run by the developer on the **host**, not inside the VM. You cannot run the host CLI from inside the sandbox.

## Access and privileges inside the VM

- You have `sudo`. You may install packages, for example `sudo apt-get update && sudo apt-get install -y <pkg>`.
- You have internet access, subject to network policy (see [Networking](#networking)).
- You have a private Docker Engine. `docker` commands affect this VM only, not the host's containers or images.
- You can read and write the VM filesystem, including `/`, your home, and any mounted workspace.

## Isolation boundaries

Assume you cannot reach host resources unless the developer explicitly shared them. By default the sandbox blocks:

- Host filesystem access outside mounted workspaces.
- The host Docker daemon.
- Direct network communication between sandboxes.
- ICMP (ping) and outbound UDP (UDP is experimental and off by default).
- Outbound TCP unless network policy allows the destination.

### When the developer reports a host-side problem

Do not search this VM for the developer's logs or code and present it as theirs. The host is a different filesystem.

- Say plainly that you cannot see the host directly.
- Ask for the specific error text, log excerpt, file contents, or command output you need.
- Ask them to put files in your shared home directory (see [File exchange with the host](#file-exchange-with-the-host)).
- Do not present sandbox-only results as if they reflect the host environment.

## Workspace and repository access

### Repository access

This environment does not use `sbx`'s direct-mount or built-in clone mode. The developer manually clones the repositories you should work on into your home directory. Work inside those clones.

- You cannot pull or push yourself: the remote repository lives on the developer's host filesystem and is not reachable from the sandbox. Ask the developer to pull or push when needed.
- Do not try to add a host-path remote or access `/run/sandbox/source`; that path applies only to `sbx --clone` sandboxes, which this is not.
- Local commits and branches inside the clone work normally. Git operations that contact a remote do not.
- The developer's host working tree is not mounted here. Edits you make in the sandbox do not appear on the host unless the developer copies or pulls them.

### File exchange with the host

Your home `~` is symlinked to `/home/agents/{agent_name}` and is shared with the host at the same path. Use it to exchange files in both directions.

`{agent_name}` is this sandbox's name: the directory component of `/home/agents/{agent_name}`. `basename "$(readlink -f ~)"` reveals it. In this setup the sandbox name and directory name are identical; if the derivation is unclear, use `sbx ls` on the host or ask the developer.

- Ask the developer to copy debug artifacts, logs, configs, or sample inputs into `~/` (or `/home/agents/{agent_name}`).
- Write outputs they should retrieve into the same directory.
- Keep secrets out of shared directories and command output. Redact credentials in logs before asking the developer to copy them.

Do not assume host paths exist inside the VM just because they exist on the host. Prefer commands that run entirely inside the sandbox.

## Networking

Outbound TCP goes through a host-side proxy that enforces network policy. In this environment the policy allows all destinations by default **except local addresses**, so the sandbox cannot browse the developer's local network. Assume public internet access works without asking for a rule; local/private addresses are blocked and cannot be opened with an allow rule because a first-match deny wins.

- If a public request is blocked, ask the developer to run `sbx policy ls` to see active rules and `sbx policy log` to inspect the egress path.
- For local/private destinations, an allow rule will not help. Use SSH remote forwarding instead; see [Reaching a host service from the sandbox](#reaching-a-host-service-from-the-sandbox).

## Credentials and authentication

Credentials are injected by the host-side proxy. The sandbox normally sees a sentinel value such as `proxy-managed` instead of the real secret. That is expected and does not mean the credential is missing or invalid; the raw value stays on the host.

- Never ask the developer to paste secrets into chat or into a file in the sandbox. Do not try to read host keychains or secret files.
- If authentication fails, ask the developer to configure or refresh the credential on the host with `sbx secret set <service>` or `sbx secret import`, then retry. Use the service name the tool expects; do not assume a specific provider. Configure only what the task actually needs.
- For remote Git or API operations, rely on proxy-injected credentials when configured. If a command insists on a raw token or the proxy cannot help, ask the developer to run it on the host.
- For custom services or domains, the developer can use `sbx secret set-custom` on the host.

## Git and repository workflow

- Work in the repository clones the developer placed in your home directory. You cannot fetch, pull, or push against the host-side remote yourself; ask the developer to do it.
- SSH agent forwarding is disabled in this setup. You cannot use host SSH keys for Git authentication or commit signing. Do not attempt `git commit -S` or SSH remotes expecting host keys.
- Local commits without signing are fine unless the project requires signatures. If signed commits or SSH-authenticated pushes are required, ask the developer to run those operations on the host, or use HTTPS credentials configured through `sbx secret`.
- Check the project's conventions and tell the developer when a signature is required rather than silently committing unsigned.

## Exposing a sandbox service to the host

To expose a web service running in the sandbox, ask the developer to publish the port from the host:

```bash
sbx ports {agent_name} --publish {host_port}:{sandbox_port}
```

- The service must listen on all interfaces inside the sandbox, not only `127.0.0.1`. Bind it to `0.0.0.0` (IPv4) or `[::]` (both), e.g. a dev server flag `--host 0.0.0.0`.
- Omit the host port to let the OS choose one: `sbx ports {agent_name} --publish {sandbox_port}`, then run `sbx ports {agent_name}` to find the assigned host port. OS-assigned ports change on restart; explicit host ports are reused.
- To stop forwarding: `sbx ports {agent_name} --unpublish {host_port}:{sandbox_port}`.
- Published ports survive restarts. `sbx run` ignores `--publish` when re-attaching to an existing sandbox; use `sbx ports` instead.
- `sbx ls` shows active port mappings.

## Reaching a host service from the sandbox

Local addresses are denied by policy and cannot be opened with an allow rule in this setup. To help debug a service running on the developer's machine, ask them to forward the host port into the sandbox with SSH remote forwarding:

```bash
ssh -R {sandbox_port}:localhost:{host_port} {agent_name}.sbx
```

`{sandbox_port}` is the port the sandbox listens on; `{host_port}` is the service port on the developer's host. The developer runs this command on the host. Inside the sandbox, connect to `localhost:{sandbox_port}` (or `127.0.0.1:{sandbox_port}`); that listener is in the sandbox VM and forwards traffic to the host service. Do not try `host.docker.internal`, the host's LAN IP, or an `sbx policy allow` rule for local addresses.

### Port order

The two commands take ports in opposite order:

| Direction | Command | Order |
| --- | --- | --- |
| Sandbox service to host | `sbx ports {agent_name} --publish {host_port}:{sandbox_port}` | host port first |
| Host service to sandbox | `ssh -R {sandbox_port}:localhost:{host_port} {agent_name}.sbx` | sandbox port first |

## Troubleshooting

When the sandbox itself seems broken (not the developer's app), ask the developer to run these on the host and share the output.

### Diagnostics

- `sbx diagnose` — installation, daemon reachability, version mismatch, auth.
- `sbx ls` — sandbox status and port mappings.
- `sbx policy ls` and `sbx policy log` — network rules and blocked egress.

### Recovery

- `sbx stop {agent_name}` / `sbx start {agent_name}` — unresponsive sandbox.
- `sbx daemon restart` — daemon connection errors.
- `sbx reset --preserve-secrets` — persistent or corrupted state. Destructive to sandbox data.
