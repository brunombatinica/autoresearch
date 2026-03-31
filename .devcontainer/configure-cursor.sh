#!/usr/bin/env bash
set -euo pipefail

BASHRC_PATH="${HOME}/.bashrc"
PATH_EXPORT_LINE='export PATH="$HOME/.local/bin:$PATH"'

touch "${BASHRC_PATH}"

if ! grep -Fqx "${PATH_EXPORT_LINE}" "${BASHRC_PATH}"; then
  printf "\n%s\n" "${PATH_EXPORT_LINE}" >> "${BASHRC_PATH}"
  echo "Added Cursor PATH export to ${BASHRC_PATH}"
else
  echo "Cursor PATH export already present in ${BASHRC_PATH}"
fi

# Make `agent` available immediately in the current setup shell as well.
case ":${PATH}:" in
  *":${HOME}/.local/bin:"*) ;;
  *) export PATH="${HOME}/.local/bin:${PATH}" ;;
esac

if command -v agent >/dev/null 2>&1; then
  echo "Cursor Agent CLI available at $(command -v agent)"
else
  echo "WARNING: Cursor Agent CLI not found in PATH after installation."
fi
