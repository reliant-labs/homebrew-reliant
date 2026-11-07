#!/usr/bin/env bash
# staleness.sh — fail, and open or update an issue, when this tap installs an
# older version than the newest release for longer than a grace period.
#
#   .github/scripts/staleness.sh <name> <tap version> <latest version> <latest published at (ISO 8601)> <grace hours>
#
# Caught up: closes the open issue, if any. Behind within the grace period: a
# notice (a release takes minutes to sign and publish). Behind past it: one issue
# per package, titled "<name> on Homebrew is behind its latest release", opened
# once and commented on once per release it falls behind, and a failing job.
set -euo pipefail

[ $# -eq 5 ] || {
  echo "usage: $0 <name> <tap version> <latest version> <published at> <grace hours>" >&2
  exit 2
}
NAME="$1"
HAVE="$2"
LATEST="$3"
PUBLISHED_AT="$4"
GRACE_HOURS="$5"
TITLE="$NAME on Homebrew is behind its latest release"
RUN_URL="${GITHUB_SERVER_URL:-https://github.com}/${GITHUB_REPOSITORY:-reliant-labs/homebrew-reliant}/actions/runs/${GITHUB_RUN_ID:-local}"

open_issue() {
  gh issue list --state open --search "in:title \"$TITLE\"" --json number,title \
    --jq ".[] | select(.title == \"$TITLE\") | .number" | head -n1
}

if [ -z "$LATEST" ]; then
  echo "::error::could not resolve the latest $NAME release" >&2
  exit 1
fi

if [ "$HAVE" = "$LATEST" ] ||
  [ "$(printf '%s\n%s\n' "$HAVE" "$LATEST" | sort -V | tail -n1)" = "$HAVE" ]; then
  echo "$NAME: the tap installs $HAVE; the latest release is $LATEST"
  n="$(open_issue || true)"
  if [ -n "$n" ]; then
    gh issue close "$n" --comment "Caught up: the tap installs $NAME $HAVE, the latest release ($RUN_URL)."
  fi
  exit 0
fi

published="$(date -u -d "$PUBLISHED_AT" +%s 2>/dev/null || date -u -j -f '%Y-%m-%dT%H:%M:%SZ' "${PUBLISHED_AT%.*}Z" +%s)"
age_s=$(($(date -u +%s) - published))
age_h=$((age_s / 3600))
if [ "$age_s" -lt $((GRACE_HOURS * 3600)) ]; then
  echo "::notice::$NAME: the tap installs ${HAVE:-nothing}; $LATEST was released ${age_h}h ago, within the ${GRACE_HOURS}h grace period"
  exit 0
fi

msg="The tap installs $NAME ${HAVE:-(none)}, but $LATEST was released ${age_h}h ago ($PUBLISHED_AT), past the ${GRACE_HOURS}h grace period.

\`brew install\` hands users the old version until this is fixed. The failing run says why: $RUN_URL

To retry by hand: \`gh workflow run <the update workflow> --repo ${GITHUB_REPOSITORY:-reliant-labs/homebrew-reliant} -f version=$LATEST\`. A bump that lands only as a pull request means the deploy key is missing or refused (README, \"Automation\")."
n="$(open_issue || true)"
if [ -n "$n" ]; then
  # One comment per release it falls behind, not one per scheduled run.
  if ! gh issue view "$n" --json body,comments --jq '([.body] + [.comments[].body]) | join("\n")' |
    grep -qF "but $LATEST was released"; then
    gh issue comment "$n" --body "$msg"
  fi
else
  gh issue create --title "$TITLE" --body "$msg"
fi
echo "::error::$NAME on Homebrew is $HAVE; $LATEST was released ${age_h}h ago" >&2
exit 1
