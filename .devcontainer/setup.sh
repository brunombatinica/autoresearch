#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional repo-local bootstrap hook.
if [[ -f "${SCRIPT_DIR}/bootstrap.sh" ]]; then
  bash "${SCRIPT_DIR}/bootstrap.sh"
fi

# UV — download and install the Astral uv binary, then ensure it is on PATH for this session.
# https://docs.astral.sh/uv/getting-started/installation/
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="${HOME}/.local/bin:${PATH}"
command -v uv >/dev/null || {
  echo "error: uv not found on PATH after install (~/.local/bin missing from PATH?)" >&2
  exit 1
}

# Codex install (global install)
sudo npm install -g --no-update-notifier @openai/codex

# Codex config (workspace-write sandbox network disabled by default)
bash "${SCRIPT_DIR}/configure-codex.sh"

# Claude Code install (official installer)
curl -fsSL https://claude.ai/install.sh | bash

# Claude Code config (minimal default permission allowlist)
bash "${SCRIPT_DIR}/configure-claude.sh"

# Cursor Agent install (official installer)
curl -fsSL https://cursor.com/install | bash

# Cursor Agent config (persist ~/.local/bin on PATH)
bash "${SCRIPT_DIR}/configure-cursor.sh"

# Existing external post-create setup
/opt/conda/bin/conda init bash

# Project dependencies (UV-native workflow)
uv sync

printf "set -g mouse on\nbind-key -T copy-mode-vi WheelUpPane send-keys -X scroll-up\nbind-key -T copy-mode-vi WheelDownPane send-keys -X scroll-down\nbind-key -T copy-mode WheelUpPane send-keys -X scroll-up\nbind-key -T copy-mode WheelDownPane send-keys -X scroll-down\n" > "${HOME}/.tmux.conf"

echo "External post-create setup complete."
