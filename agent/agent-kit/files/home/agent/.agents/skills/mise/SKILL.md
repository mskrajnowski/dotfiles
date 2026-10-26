---
name: mise
description: Use mise (preinstalled in this sandbox) to install and pin project tools and runtimes such as uv, Node, Python, aws-cli, compilers, and linters. Prefer mise over apt/npm/pip for versioned project tooling. Covers mise.toml, install/use/exec/run, environments, local overrides, and lockfiles. Use when installing a tool, requiring a specific version, setting up a cloned project, defining environment variables, or running project tasks.
---

# mise: project tool and runtime management

`mise` is preinstalled and activated in this sandbox. It installs tools at pinned versions and supplies them on `PATH`, so prefer it over ad-hoc `apt`, `npm -g`, `pip install`, or downloading binaries when a project needs a specific version. See <https://mise.jdx.dev/>.

Use `apt` only for OS-level packages or libraries that mise does not provide. Use mise for language runtimes and versioned developer tools.

## How mise selects tools

mise combines config files from least to most specific:

1. System config in `/etc/mise`.
2. Global config in `~/.config/mise/config.toml`.
3. `mise.toml` files from the filesystem root down to the current directory. The nearest file wins.

A project's `mise.toml` declares tools, environment variables, and tasks. A `mise.local.toml` beside it holds personal overrides and should stay out of version control. Run `mise ls` to see which tools are installed globally in this sandbox.

## Environments

mise manages environment variables as well as tools. Define them under `[env]` in `mise.toml`:

```toml
[env]
NODE_ENV = "development"
```

### Defining variables

- `mise set KEY=VALUE` writes to the nearest `mise.toml`; `mise set KEY` prints a value; `mise set` lists variables and their source files; `mise unset KEY` removes one.
- Check a value in a child process without changing your shell: `mise exec -- sh -c 'echo "$NODE_ENV"'`.
- `mise env` prints the resolved environment; `--json` and `--dotenv` change the format. Output contains actual values, including secrets; do not paste it into logs or chat.

### Loading files

- When a project uses environment variables for configuration, load them with `[env] _.file = ".env"`.
- Use `_.path` for `PATH` entries and `_.source` for variables exported by a script.
- Relative paths resolve against the project directory.
- Keep `.env` out of version control unless the project already commits it.

### Local overrides

`mise.local.toml` overrides `mise.toml` in the same directory. Use it for personal overrides such as local credentials or a different database URL. Do not commit it. Write to it explicitly:

```bash
mise set --file mise.local.toml DATABASE_URL=postgres://localhost/app
```

Precedence from lowest to highest: global config, parent `mise.toml`, project `mise.toml`, project `mise.local.toml`, and with `MISE_ENV` set, the matching `mise.<env>.toml` and `mise.<env>.local.toml` files. A project config wins over the global config.

## Project setup

1. Check what the project already declares:

   ```bash
   mise config
   mise ls --current
   ```

   Look for `mise.toml`, `.tool-versions`, or a `mise/` directory. Do not replace existing configuration without understanding it.

2. Install the tools the project requests:

   ```bash
   mise install
   ```

   This installs every configured tool that is missing. It does not change config.

3. Add or pin a tool for the project:

   ```bash
   mise use <tool>@<version>
   ```

   This installs the tool and writes it to the project's `mise.toml`. Use an explicit version when the project requires one; use a major or minor request only when that matches the project's policy. Avoid `latest` for project dependencies unless the project already uses it.

   Examples:

   ```bash
   mise use uv@0.13.5
   mise use node@24
   mise use python@3.13
   mise use aws-cli@2
   ```

4. Run `mise lock` after adding or changing tools. This creates or refreshes `mise.lock`, which records exact versions and download URLs. Commit `mise.lock` next to `mise.toml` for reproducible installs. Use `mise upgrade` later to move within the requests in `mise.toml`.

5. For Python projects, configure the virtual environment under `[env]`:

   ```toml
   [env]
   _.python.venv = ".venv"
   ```

   Use `_.python.venv = { path = ".venv", create = true }` if mise should create the environment when it is missing. Add `.venv/` to `.gitignore`.

## Running commands

Use the project's toolchain for commands:

```bash
mise exec -- <command>
```

Or run a task defined in `mise.toml`:

```bash
mise tasks          # list available tasks
mise run <task>
```

In non-interactive shells, `mise exec` is the reliable way to put the project's tools on `PATH`. Do not assume activation applies to a command you run.

Run a one-off tool version without touching config:

```bash
mise exec <tool>@<version> -- <command>
mise x <tool>@<version> -- <command>
```

This installs and runs that version for the command only. It is not added to `PATH` for later commands.

## Global tools

When working on a project, do not use `mise use -g`. Always add tools to the project's `mise.toml` so anyone who clones the repository and runs `mise install` gets the required tooling. Reserve the global config for tools you genuinely want in every project and only when the developer explicitly asks for them:

```bash
mise use -g <tool>@<version>
```

In this sandbox the global config already provides common utilities; prefer adding project requirements to the project's `mise.toml`.

## Inspecting and troubleshooting

- `mise ls` lists installed tools and where each version is configured.
- `mise ls --current` lists the versions active in the current directory.
- `mise which <tool>` shows the executable mise resolves.
- `mise where <tool>` shows the install directory.
- `mise latest <tool>` shows the newest matching version; `mise ls-remote <tool>` lists available versions.
- `mise search <tool>` finds tools by name.
- `mise doctor` checks the mise setup.
- `mise trust` marks a config as trusted after you review it. Only trust configuration you have inspected; do not trust unreviewed repository configs.
- `mise upgrade` upgrades configured tools. Ask before upgrading unless the task is explicitly an upgrade.
- `mise install --locked` installs only versions in the lockfile. If global tools are active but absent from the project lockfile, run `mise lock -g` once or use plain `mise install`.

If a tool is missing after `mise install`, check `mise config` for the config file that should declare it and `mise ls --current` for the resolved version. If a command still uses the wrong version, run it through `mise exec -- <command>` rather than relying on the shell's `PATH`.

## Boundaries

- mise manages tools inside this sandbox VM; it does not change the developer's host toolchain. Downloads go through the sandbox network policy. See the `sbx` skill for network and credential details.
- Do not install credentials or secrets through mise config. Use the sandbox's credential mechanism instead; see the `sbx` skill.
