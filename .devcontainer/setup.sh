#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional repo-local bootstrap hook.
if [[ -f "${SCRIPT_DIR}/bootstrap.sh" ]]; then
  bash "${SCRIPT_DIR}/bootstrap.sh"
fi

<<<<<<< HEAD
# Codex install (official npm package)
sudo npm install -g --no-update-notifier @openai/codex

# Codex config (workspace-write sandbox network access enabled)
=======
# Codex install (global install)
sudo npm install -g --no-update-notifier @openai/codex

# Codex config (workspace-write sandbox network disabled by default)
>>>>>>> e8fae2866bc9d05c0d46f466c10dcdc258f5b6bf
bash "${SCRIPT_DIR}/configure-codex.sh"

# Claude Code install (official installer)
curl -fsSL https://claude.ai/install.sh | bash

<<<<<<< HEAD
# Claude Code config (pre-authorize network fetches)
=======
# Claude Code config (minimal default permission allowlist)
>>>>>>> e8fae2866bc9d05c0d46f466c10dcdc258f5b6bf
bash "${SCRIPT_DIR}/configure-claude.sh"

# Cursor Agent install (official installer)
curl -fsSL https://cursor.com/install | bash

# Cursor Agent config (persist ~/.local/bin on PATH)
bash "${SCRIPT_DIR}/configure-cursor.sh"

# Existing external post-create setup
/opt/conda/bin/conda init bash
<<<<<<< HEAD
/opt/conda/bin/pip install -e /home/bb2238/github/trace-ai-analysis
=======
/opt/conda/bin/pip install -e /workspace
>>>>>>> e8fae2866bc9d05c0d46f466c10dcdc258f5b6bf
printf "set -g mouse on\nbind-key -T copy-mode-vi WheelUpPane send-keys -X scroll-up\nbind-key -T copy-mode-vi WheelDownPane send-keys -X scroll-down\nbind-key -T copy-mode WheelUpPane send-keys -X scroll-up\nbind-key -T copy-mode WheelDownPane send-keys -X scroll-down\n" > "${HOME}/.tmux.conf"

echo "External post-create setup complete."
