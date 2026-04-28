# autoresearch (fork)

Minimal fork of Karpathy's `autoresearch`, intended to run inside a dev container.

## Environment

- Primary workflow: run from `.devcontainer/`
- Workspace path in container: `/workspace`
- Container name: `autoresearch-container`

## Agent + privilege model (current)

- Container user: `bb2238`
- `bb2238` has passwordless sudo in container (`NOPASSWD:ALL`)
- Code is mounted to `/workspace` (bind mount from local repo)
- Container runtime hardening:
  - `--cap-drop=ALL`
  - `--security-opt no-new-privileges:true`
  - `--pids-limit 512`
- Codex config:
  - workspace-write sandbox
  - `network_access = false` by default
- Claude config:
  - minimal default allowlist (`WebFetch`)
  - existing allowlist entries in `~/.claude/settings.json` are preserved
- `.env` is **not** auto-sourced on start (only a notice is printed)

## Install flow in container

Defined in `.devcontainer/setup.sh`:

- Codex: global npm install (`sudo npm install -g @openai/codex`)
- Claude: official installer (`curl ... | bash`)
- Cursor Agent: official installer (`curl ... | bash`)

## Debug checks

Run inside container:

```bash
whoami
id
sudo -n true && echo "sudo: yes" || echo "sudo: no"
cat ~/.codex/config.toml
cat ~/.claude/settings.json
```

