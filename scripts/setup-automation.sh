#!/usr/bin/env bash
# setup-automation.sh — give this tap's publish workflows the one identity that
# may land a formula/cask bump on main without a review. Run once by an admin
# of reliant-labs/homebrew-reliant; re-run to rotate the key.
#
#   scripts/setup-automation.sh            # do it
#   scripts/setup-automation.sh --dry-run  # print what it would change
#
# What it changes, in this order (so there is never a moment where the key can
# rewrite history):
#   1. Creates the ruleset "main: history" — no deletion, no force push on main —
#      with the same bypass actors "main" has today, and NOT the deploy key.
#   2. Creates a write deploy key "homebrew-reliant publish automation", stores
#      its private half as the Actions secret HOMEBREW_TAP_DEPLOY_KEY, and
#      deletes any older key with that title (rotation). The private key never
#      leaves a temp directory that is removed on exit.
#   3. Adds "Deploy keys" (bypass: always) to the "main" ruleset, so a push by
#      that key skips the pull-request review. A ruleset's deploy-key bypass
#      covers every deploy key of the repository: this script checks that the
#      automation key is the only one.
#
# The key is usable only by workflows of this repository (secrets are not given
# to pull requests from forks), and the workflows push only Formula/forge.rb or
# Casks/reliant.rb, only after their verification gate (.github/workflows/).
# Every other change to main keeps its human review.
set -euo pipefail

REPO="reliant-labs/homebrew-reliant"
KEY_TITLE="homebrew-reliant publish automation"
SECRET="HOMEBREW_TAP_DEPLOY_KEY"
DRY_RUN=0
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

run() {
  if [ "$DRY_RUN" = 1 ]; then
    echo "would run: $*"
  else
    "$@"
  fi
}

if [ "$(gh api "repos/$REPO" --jq .permissions.admin)" != "true" ]; then
  echo "error: you are not an admin of $REPO; an admin must run this" >&2
  exit 1
fi

rulesets="$(gh api "repos/$REPO/rulesets")"
main_id="$(jq -r '.[] | select(.name == "main") | .id' <<<"$rulesets")"
[ -n "$main_id" ] || {
  echo "error: $REPO has no ruleset named \"main\"" >&2
  exit 1
}
main="$(gh api "repos/$REPO/rulesets/$main_id")"

# 1. History protection the deploy key cannot bypass.
if jq -e '.[] | select(.name == "main: history")' <<<"$rulesets" >/dev/null; then
  echo "ruleset \"main: history\" exists"
else
  body="$(jq '{
    name: "main: history",
    target: "branch",
    enforcement: "active",
    conditions: .conditions,
    rules: [{type: "deletion"}, {type: "non_fast_forward"}],
    bypass_actors: [.bypass_actors[] | select(.actor_type != "DeployKey")]
  }' <<<"$main")"
  echo "creating ruleset \"main: history\": $(jq -c . <<<"$body")"
  [ "$DRY_RUN" = 1 ] || gh api -X POST "repos/$REPO/rulesets" --input - <<<"$body" >/dev/null
fi

# 2. The deploy key and its secret.
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
old_ids="$(gh api "repos/$REPO/keys" --jq ".[] | select(.title == \"$KEY_TITLE\") | .id")"
if [ "$DRY_RUN" = 1 ]; then
  echo "would create write deploy key \"$KEY_TITLE\", set secret $SECRET, delete old key ids: ${old_ids:-none}"
else
  ssh-keygen -q -t ed25519 -N '' -C "$KEY_TITLE" -f "$tmp/key"
  new_id="$(gh api -X POST "repos/$REPO/keys" -f title="$KEY_TITLE" -f key="$(cat "$tmp/key.pub")" -F read_only=false --jq .id)"
  gh secret set "$SECRET" --repo "$REPO" <"$tmp/key"
  echo "created deploy key $new_id and set secret $SECRET"
  for id in $old_ids; do
    gh api -X DELETE "repos/$REPO/keys/$id"
    echo "deleted the previous automation key $id"
  done
fi
others="$(gh api "repos/$REPO/keys" --jq ".[] | select(.title != \"$KEY_TITLE\") | \"\(.id) \(.title)\"")"
if [ -n "$others" ]; then
  echo "warning: $REPO has other deploy keys, which the \"main\" ruleset's deploy-key bypass also covers:" >&2
  echo "$others" >&2
fi

# 3. Let deploy keys bypass the review rule of "main".
if jq -e '.bypass_actors[] | select(.actor_type == "DeployKey")' <<<"$main" >/dev/null; then
  echo "ruleset \"main\" already lets deploy keys bypass it"
else
  body="$(jq '{name, target, enforcement, conditions, rules,
    bypass_actors: (.bypass_actors + [{actor_id: null, actor_type: "DeployKey", bypass_mode: "always"}])}' <<<"$main")"
  echo "adding the deploy-key bypass to ruleset \"main\" ($main_id)"
  [ "$DRY_RUN" = 1 ] || gh api -X PUT "repos/$REPO/rulesets/$main_id" --input - <<<"$body" >/dev/null
fi

echo
echo "done. Prove it end to end (publishes nothing when the tap is current):"
echo "  gh workflow run update-forge-formula.yml --repo $REPO"
echo "  gh workflow run update-cask.yml --repo $REPO"
