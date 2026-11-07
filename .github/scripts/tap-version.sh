#!/usr/bin/env bash
# tap-version.sh — print the version a package file of this tap installs.
#
#   .github/scripts/tap-version.sh formula [<git-ref>]   # Formula/forge.rb
#   .github/scripts/tap-version.sh cask    [<git-ref>]   # Casks/reliant.rb
#
# Without a ref it reads the working tree; with one (origin/main) it reads that
# commit. Prints nothing and exits 1 when the file has no single version.
set -euo pipefail

case "${1:-}" in
  formula) file="Formula/forge.rb" ;;
  cask) file="Casks/reliant.rb" ;;
  *)
    echo "usage: $0 formula|cask [<git-ref>]" >&2
    exit 2
    ;;
esac

if [ -n "${2:-}" ]; then
  body="$(git show "$2:$file" 2>/dev/null || true)"
else
  body="$(cat "$file" 2>/dev/null || true)"
fi

case "$1" in
  # The formula has no version stanza: Homebrew scans it from the release URLs,
  # which must all name the same release.
  formula) versions="$(printf '%s\n' "$body" | sed -n 's|.*/releases/download/v\([0-9][0-9.]*\)/forge_.*|\1|p' | sort -u)" ;;
  cask) versions="$(printf '%s\n' "$body" | sed -n 's/^[[:space:]]*version "\([^"]*\)".*/\1/p' | sort -u)" ;;
esac

[ -n "$versions" ] && [ "$(printf '%s\n' "$versions" | wc -l)" -eq 1 ] || exit 1
printf '%s\n' "$versions"
