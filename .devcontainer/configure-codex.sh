#!/usr/bin/env bash
set -euo pipefail

CODEX_DIR="${HOME}/.codex"
CODEX_CONFIG="${CODEX_DIR}/config.toml"

mkdir -p "${CODEX_DIR}"
touch "${CODEX_CONFIG}"

tmp_file="$(mktemp)"

awk '
BEGIN {
  in_section = 0
  saw_section = 0
  wrote_setting = 0
}
{
  line = $0

  if (line ~ /^\[sandbox_workspace_write\][[:space:]]*$/) {
    saw_section = 1
    in_section = 1
    print line
    next
  }

  if (in_section && line ~ /^\[[^]]+\][[:space:]]*$/) {
    if (!wrote_setting) {
      print "network_access = false"
      wrote_setting = 1
    }
    in_section = 0
  }

  if (in_section && line ~ /^[[:space:]]*network_access[[:space:]]*=/) {
    if (!wrote_setting) {
      print "network_access = false"
      wrote_setting = 1
    }
    next
  }

  print line
}
END {
  if (!saw_section) {
    print ""
    print "[sandbox_workspace_write]"
    print "network_access = false"
  } else if (in_section && !wrote_setting) {
    print "network_access = false"
  }
}
' "${CODEX_CONFIG}" > "${tmp_file}"

mv "${tmp_file}" "${CODEX_CONFIG}"
chmod 600 "${CODEX_CONFIG}"

echo "Configured Codex sandbox setting in ${CODEX_CONFIG}"
