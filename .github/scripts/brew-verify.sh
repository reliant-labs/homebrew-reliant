#!/usr/bin/env bash
# brew-verify.sh — install a rendered formula or cask from this checkout with
# Homebrew and prove it works, before anything is published to main.
#
#   .github/scripts/brew-verify.sh formula <X.Y.Z>   # Formula/forge.rb
#   .github/scripts/brew-verify.sh cask    <X.Y.Z>   # Casks/reliant.rb (macOS only)
#
# The working tree's file is what is verified, committed or not: `brew tap` of a
# local path clones only what is committed, so the file is copied over the tap's
# clone before installing.
set -euo pipefail

[ $# -eq 2 ] || {
  echo "usage: $0 formula|cask <X.Y.Z>" >&2
  exit 2
}
KIND="$1"
VERSION="$2"
TAP="reliant-labs/reliant"
ROOT="${GITHUB_WORKSPACE:-$(git rev-parse --show-toplevel)}"

# ubuntu-latest ships Homebrew but does NOT put it on PATH; macOS runners do.
if ! command -v brew >/dev/null 2>&1 && [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_INSTALL_CLEANUP=1

if ! brew tap | grep -qx "$TAP"; then
  brew tap "$TAP" "$ROOT"
fi
TAP_DIR="$(brew --repository "$TAP")"

case "$KIND" in
  formula)
    mkdir -p "$TAP_DIR/Formula"
    cp "$ROOT/Formula/forge.rb" "$TAP_DIR/Formula/forge.rb"
    # Homebrew 5+ refuses to load a formula from a tap nobody trusted; an older
    # brew has no `trust` command and no such check.
    brew trust --formula "$TAP/forge" 2>/dev/null || true
    brew install --formula "$TAP/forge"
    brew test "$TAP/forge"
    out="$("$(brew --prefix)/bin/forge" version 2>&1 | head -n1)"
    echo "forge version: $out"
    case "$out" in
      *"$VERSION"*) ;;
      *)
        echo "::error::the installed formula runs '$out', not forge $VERSION" >&2
        exit 1
        ;;
    esac
    # Advisory: a style finding is not a reason to withhold a release (the
    # renderer at an older tag may predate an audit fix).
    brew audit --strict --online --formula "$TAP/forge" ||
      echo "::warning::brew audit --strict reported problems in Formula/forge.rb (see above)"
    ;;
  cask)
    mkdir -p "$TAP_DIR/Casks"
    cp "$ROOT/Casks/reliant.rb" "$TAP_DIR/Casks/reliant.rb"
    brew trust --cask "$TAP/reliant" 2>/dev/null || true
    # Installs this runner's arch, checking that DMG against the cask's sha256.
    # The other arch's checksum was checked against the release manifest
    # (latest-mac.yml) before the cask was written.
    brew install --cask "$TAP/reliant"
    plist="/Applications/Reliant.app/Contents/Info.plist"
    got="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$plist")"
    echo "installed Reliant.app $got"
    if [ "$got" != "$VERSION" ]; then
      echo "::error::the installed cask is Reliant $got, not $VERSION" >&2
      exit 1
    fi
    brew audit --cask "$TAP/reliant" ||
      echo "::warning::brew audit reported problems in Casks/reliant.rb (see above)"
    ;;
  *)
    echo "usage: $0 formula|cask <X.Y.Z>" >&2
    exit 2
    ;;
esac
