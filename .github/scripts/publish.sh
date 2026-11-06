#!/usr/bin/env bash
# publish.sh — land a verified formula/cask bump on main, with no human step.
#
#   .github/scripts/publish.sh formula|cask <X.Y.Z> <commit subject>
#
# Runs only after the bump passed its gate (render-forge-formula.sh / the cask
# checks, then brew-verify.sh). The working tree holds the verified file.
#
# HOW IT LANDS. The checkout was made with the tap's deploy key
# (secret HOMEBREW_TAP_DEPLOY_KEY), the one identity the "main" ruleset lets
# bypass its pull-request review. A fast-forward push of exactly one file —
# Formula/forge.rb or Casks/reliant.rb — goes straight to main. The "main:
# history" ruleset, which the deploy key does NOT bypass, still refuses a force
# push or a deletion. Everything else on this tap keeps its human review.
#
# WHEN IT CANNOT. No key configured, or main refusing the push, falls back to
# the old path: a pull request for a human to approve. With no key that is a
# warning (the automation was never set up); a key that main refuses is an
# error, because the setup is broken. Either way the staleness check of the
# same workflow opens an issue if the tap stays behind.
set -euo pipefail

[ $# -eq 3 ] || {
  echo "usage: $0 formula|cask <X.Y.Z> <subject>" >&2
  exit 2
}
KIND="$1"
VERSION="$2"
SUBJECT="$3"
case "$KIND" in
  formula) FILE="Formula/forge.rb" BRANCH="update-forge-$VERSION" ;;
  cask) FILE="Casks/reliant.rb" BRANCH="update-reliant-$VERSION" ;;
  *)
    echo "usage: $0 formula|cask <X.Y.Z> <subject>" >&2
    exit 2
    ;;
esac
HERE="$(cd "$(dirname "$0")" && pwd)"
RUN_URL="${GITHUB_SERVER_URL:-https://github.com}/${GITHUB_REPOSITORY:-reliant-labs/homebrew-reliant}/actions/runs/${GITHUB_RUN_ID:-local}"

# Whether main already has VERSION or newer: then there is nothing to publish,
# and pushing would downgrade it.
main_is_current() {
  local have
  have="$("$HERE/tap-version.sh" "$KIND" origin/main || true)"
  [ -n "$have" ] && [ "$(printf '%s\n%s\n' "$have" "$VERSION" | sort -V | tail -n1)" = "$have" ]
}

git fetch --quiet origin main
if main_is_current; then
  echo "main already installs $KIND $("$HERE/tap-version.sh" "$KIND" origin/main); nothing to publish"
  exit 0
fi

# Exactly one file may change: the gate verified that file and nothing else.
changed="$(git status --porcelain --untracked-files=all | awk '{print $2}' | sort -u)"
if [ "$changed" != "$FILE" ]; then
  echo "::error::refusing to publish: the working tree changes [$(echo "$changed" | tr '\n' ' ')], not exactly $FILE" >&2
  exit 1
fi
if [ "$("$HERE/tap-version.sh" "$KIND")" != "$VERSION" ]; then
  echo "::error::refusing to publish: $FILE does not install $VERSION" >&2
  exit 1
fi

verified="$(mktemp)"
trap 'rm -f "$verified"' EXIT
cp "$FILE" "$verified"

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

# Rebuild the one-file commit on the newest main.
commit_on_main() {
  git fetch --quiet origin main
  git checkout --quiet -B "publish-$KIND" origin/main
  cp "$verified" "$FILE"
  git add "$FILE"
  git commit --quiet -m "$SUBJECT" -m "Published by $RUN_URL after it passed the tap's verification gate."
}

push_error=""
if [ "${DEPLOY_KEY_CONFIGURED:-false}" = "true" ]; then
  for attempt in 1 2 3 4 5; do
    git fetch --quiet origin main
    if main_is_current; then
      echo "main already installs $KIND $("$HERE/tap-version.sh" "$KIND" origin/main); nothing to publish"
      exit 0
    fi
    commit_on_main
    if out="$(git push origin "HEAD:refs/heads/main" 2>&1)"; then
      echo "$out"
      echo "published $FILE $VERSION to main ($(git rev-parse --short HEAD))"
      exit 0
    fi
    echo "$out"
    push_error="$out"
    # Another publish (the cask, or a newer release) moved main: rebuild on it.
    sleep $((attempt * 5))
  done
  echo "::error::the deploy key could not push to main; is it a bypass actor of the \"main\" ruleset? Falling back to a pull request." >&2
else
  echo "::warning::HOMEBREW_TAP_DEPLOY_KEY is not set, so this bump needs a human approval; run scripts/setup-automation.sh once to make it automatic."
fi

# Fallback: the pre-automation path, a pull request for a human.
git fetch --quiet origin main
if main_is_current; then
  echo "main already installs $KIND $("$HERE/tap-version.sh" "$KIND" origin/main); nothing to publish"
  exit 0
fi
commit_on_main
git push --force --quiet origin "HEAD:refs/heads/$BRANCH"
if [ -n "$(gh pr list --head "$BRANCH" --state open --json number --jq '.[].number')" ]; then
  echo "a pull request for $BRANCH is already open; its branch was updated"
else
  gh pr create --base main --head "$BRANCH" --title "$SUBJECT" \
    --body "Automated bump to $VERSION. It passed the tap's verification gate in $RUN_URL, but could not be pushed to main automatically, so it needs an approving review."
fi
[ -z "$push_error" ]
