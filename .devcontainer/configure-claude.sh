#!/usr/bin/env bash
set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"
HOOKS_DIR="${CLAUDE_DIR}/hooks"
SETTINGS="${CLAUDE_DIR}/settings.json"

# ---------------------------------------------------------------------------
# 1. Directories
# ---------------------------------------------------------------------------
setup_dirs() {
  mkdir -p "${CLAUDE_DIR}" "${HOOKS_DIR}"
  touch "${SETTINGS}"
}

# ---------------------------------------------------------------------------
<<<<<<< HEAD
# 2. ntfy notification hook script
# ---------------------------------------------------------------------------
install_notify_hook() {
  local hook="${HOOKS_DIR}/notify.sh"

  cat > "${hook}" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
MESSAGE=$(printf '%s' "$INPUT" | jq -r '.message // "Claude needs attention"')
TITLE=$(printf '%s' "$INPUT" | jq -r '.title // "Claude Code"')

curl -s \
  -H "Title: $TITLE" \
  -d "$MESSAGE" \
  "https://ntfy.sh/bruno_agents" > /dev/null 2>&1 || true
EOF

  chmod +x "${hook}"
  echo "Installed ntfy hook: ${hook}"
}

# ---------------------------------------------------------------------------
# 3. settings.json — merge permissions and hooks (idempotent)
=======
# 2. settings.json — enforce minimal permissions (idempotent)
>>>>>>> e8fae2866bc9d05c0d46f466c10dcdc258f5b6bf
# ---------------------------------------------------------------------------
configure_settings() {
  local tmp
  tmp="$(mktemp)"

  node - "${SETTINGS}" "${tmp}" <<'EOF'
const fs = require("fs");
const [inputPath, outputPath] = process.argv.slice(2);

// Load existing settings (or start fresh)
let s = {};
try {
  const raw = fs.readFileSync(inputPath, "utf8").trim();
  if (raw) s = JSON.parse(raw);
} catch (_) {}

// -- permissions.allow --
if (!s.permissions || typeof s.permissions !== "object" || Array.isArray(s.permissions)) {
  s.permissions = {};
}
const existingAllow = Array.isArray(s.permissions.allow)
  ? s.permissions.allow.filter((v) => typeof v === "string")
  : [];

<<<<<<< HEAD
// Safe read-only / non-destructive commands to always allow
const DEFAULT_ALLOW = [
  "WebFetch",
  "Bash(find *)",
  "Bash(cat *)",
  "Bash(grep *)",
  "Bash(rg *)",
  "Bash(ls *)",
  "Bash(ls)",
  "Bash(echo *)",
  "Bash(printf *)",
  "Bash(head *)",
  "Bash(tail *)",
  "Bash(wc *)",
  "Bash(pwd)",
  "Bash(which *)",
  "Bash(du *)",
  "Bash(df *)",
  "Bash(stat *)",
  "Bash(file *)",
  "Bash(sort *)",
  "Bash(uniq *)",
  "Bash(cut *)",
  "Bash(awk *)",
  "Bash(sed *)",
  "Bash(tr *)",
  "Bash(diff *)",
  "Bash(tree *)",
  "Bash(date)",
  "Bash(date *)",
  "Bash(env)",
  "Bash(printenv *)",
  "Bash(uname *)",
  "Bash(id)",
  "Bash(whoami)",
=======
// Minimal default allowlist to reduce agent shell permissions.
const DEFAULT_ALLOW = [
  "WebFetch",
>>>>>>> e8fae2866bc9d05c0d46f466c10dcdc258f5b6bf
];

// Merge: keep any existing custom entries, add defaults if not present
const allow = [...existingAllow];
for (const entry of DEFAULT_ALLOW) {
  if (!allow.includes(entry)) allow.push(entry);
}
s.permissions.allow = allow;

<<<<<<< HEAD
// -- hooks --
const HOOK_CMD = "~/.claude/hooks/notify.sh";
const hookEntry = { matcher: "", hooks: [{ type: "command", command: HOOK_CMD }] };

if (!s.hooks || typeof s.hooks !== "object") s.hooks = {};

for (const event of ["Notification", "Stop"]) {
  if (!Array.isArray(s.hooks[event])) s.hooks[event] = [];
  const exists = s.hooks[event].some((h) =>
    Array.isArray(h.hooks) && h.hooks.some((c) => c.command === HOOK_CMD)
  );
  if (!exists) s.hooks[event].push(hookEntry);
}

=======
>>>>>>> e8fae2866bc9d05c0d46f466c10dcdc258f5b6bf
fs.writeFileSync(outputPath, JSON.stringify(s, null, 2) + "\n", "utf8");
EOF

  mv "${tmp}" "${SETTINGS}"
  chmod 600 "${SETTINGS}"
  echo "Configured Claude Code settings: ${SETTINGS}"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
  setup_dirs
<<<<<<< HEAD
  install_notify_hook
=======
>>>>>>> e8fae2866bc9d05c0d46f466c10dcdc258f5b6bf
  configure_settings
}

main