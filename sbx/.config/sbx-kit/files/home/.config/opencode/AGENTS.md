## Sandbox

You are running inside a virtual machine to sandbox you from the user's machine.
The VM is managed by [docker sandbox / sbx](https://docs.docker.com/ai/sandboxes/).

Key takeaways:

- you cannot access the user's environment directly
- you have access to the internet, but not the user's local network
- if needed the user can grant you access to their local machine, e.g. by opening ports
- you can use `sudo` inside the VM, e.g. to install packages with `apt`

## Docker

[docker](https://docs.docker.com/engine/) and [docker compose](https://docs.docker.com/compose/) are preinstalled.

Use them for containerized development environments, e.g. if the repo has a `docker-compose.yml`.

## Mise

[mise](https://mise.jdx.dev/walkthrough.html) is preinstalled.

It's a tool to:

- specify other tools needed to work on a project, see https://mise.jdx.dev/dev-tools/
- set environment variables, see https://mise.jdx.dev/environments/
- configure and run common tasks, https://mise.jdx.dev/tasks/

Cheat sheet:

```sh
# add a tool to the project, updates mise.toml and installs the tool, e.g.
mise use uv
# add a tool with a specific version, e.g.
mise use uv@0.11.26
# use a tool, e.g.
mise x -- uv
```

Use it for non-containerized development environments, e.g. repos without a `docker-compose.yml`.

## Git workflow

As part of the sandbox you are running on a clone of the git repo, not on the user's filesystem directly.

The user has access to your clone using a git remote, so they can `git fetch` your code and `git pull` any of your committed changes. They cannot pull uncommitted changes. You can also pull their committed changes, e.g. when they merged your branch or added some commits to it.

Create atomic commits, split your changes into multiple atomic commits if needed. If the project does not specify otherwise, use [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/). Keep the commit messages and descriptions brief and to the point. Committing does not require user's approval, don't ask before committing.

Whenever you start working on something create a branch dedicated to that work. That way the user will be able to `git checkout` and review your work. Once the user is happy with your work they will merge it to the default branch, likely `main`.

## Available tools

- [context7](https://context7.com/docs/overview) - exposes tool/library documentation pages through MCP tools, prefer for looking up documentation over `websearch`/`webfetch`
- websearch - web search powered by [Exa](https://exa.ai/docs/reference/exa-mcp), use to research general topics or for documentation if it is missing from `context7`
- webfetch - fetch a particular URL, use to read web pages if you cannot find the information through other tools
- [lsp](https://opencode.ai/docs/lsp/) - language servers that can help with working on code, e.g. find references, spot issues, format code
