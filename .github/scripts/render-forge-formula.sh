#!/usr/bin/env bash
# render-forge-formula.sh — write Formula/forge.rb for a forge release, but only
# from a release whose assets are signed by forge's release workflow.
#
#   .github/scripts/render-forge-formula.sh <X.Y.Z> <Formula/forge.rb>
#
# This is the gate that replaced the human review of formula bumps. It:
#   1. waits (up to 30 min) for the release's Sigstore attestation, which forge's
#      release-attest.yml attaches about a minute after the release is published;
#   2. downloads checksums.txt and every darwin/linux archive and checks each
#      archive's sha256 against checksums.txt;
#   3. verifies every archive AND checksums.txt against that attestation, pinned
#      to forge's release-attest.yml identity, and that the signed statement
#      names THIS release (an older release's signed set replayed under a new
#      tag verifies, but names its own tag);
#   4. renders the formula with scripts/render-homebrew-formula.sh from the
#      forge tag being published, so it names that release's asset names;
#   5. re-reads every url/sha256 pair out of the rendered formula and checks it
#      against the verified checksums.txt, so a renderer bug cannot ship a
#      formula whose checksums disagree with the signed release.
#
# The signer contract (asset name, identity, predicate type) is forge's, the same
# one install.sh and forge's release-npm.yml verify against.
set -euo pipefail

SIGNATURE_ASSET="forge-release.sigstore.json"
SIGNER_IDENTITY='^https://github\.com/reliant-labs/forge/\.github/workflows/release-attest\.yml@refs/(heads/main|tags/v[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?)$'
PREDICATE_TYPE="https://github.com/reliant-labs/forge/attestations/release-assets/v1"
FORGE_REPO="reliant-labs/forge"
SIGNATURE_WAIT_ATTEMPTS="${SIGNATURE_WAIT_ATTEMPTS:-90}" # x20s = 30 min

[ $# -eq 2 ] || {
  echo "usage: $0 <X.Y.Z> <out.rb>" >&2
  exit 2
}
VERSION="${1#v}"
OUT="$2"
TAG="v$VERSION"
echo "$VERSION" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' || {
  echo "::error::version must look like X.Y.Z (got: '$1'); prereleases are not published to Homebrew" >&2
  exit 1
}

sha256_of() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}'; else shasum -a 256 "$1" | awk '{print $1}'; fi
}

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# A draft or prerelease is never offered through brew, whatever asked for it.
gh release view "$TAG" --repo "$FORGE_REPO" --json isDraft,isPrerelease >"$work/release.json"
if [ "$(jq -r '.isDraft or .isPrerelease' "$work/release.json")" = "true" ]; then
  echo "::error::$TAG is a draft or prerelease; not publishing it to Homebrew" >&2
  exit 1
fi

for attempt in $(seq 1 "$SIGNATURE_WAIT_ATTEMPTS"); do
  if gh release download "$TAG" --repo "$FORGE_REPO" --dir "$work" --pattern "$SIGNATURE_ASSET" --clobber 2>/dev/null; then
    break
  fi
  if [ "$attempt" = "$SIGNATURE_WAIT_ATTEMPTS" ]; then
    echo "::error::$TAG carries no $SIGNATURE_ASSET after waiting; did forge's release-attest.yml run? (gh workflow run release-attest.yml --repo $FORGE_REPO -f version=$TAG)" >&2
    exit 1
  fi
  echo "waiting for $TAG's $SIGNATURE_ASSET (attempt $attempt/$SIGNATURE_WAIT_ATTEMPTS)"
  sleep 20
done

gh release download "$TAG" --repo "$FORGE_REPO" --dir "$work" --clobber \
  --pattern checksums.txt --pattern 'forge_darwin_*.tar.gz' --pattern 'forge_linux_*.tar.gz'

archives=0
for f in "$work"/forge_*.tar.gz; do
  name="$(basename "$f")"
  want="$(awk -v f="$name" '$2 == f || $2 == "*" f { print $1; exit }' "$work/checksums.txt")"
  got="$(sha256_of "$f")"
  if [ -z "$want" ] || [ "$want" != "$got" ]; then
    echo "::error::$name: sha256 $got does not match checksums.txt ('$want')" >&2
    exit 1
  fi
  archives=$((archives + 1))
done
[ "$archives" -ge 4 ] || {
  echo "::error::$TAG has $archives darwin/linux archives; expected 4" >&2
  exit 1
}

for f in "$work"/forge_*.tar.gz "$work/checksums.txt"; do
  gh attestation verify "$f" --bundle "$work/$SIGNATURE_ASSET" --repo "$FORGE_REPO" \
    --cert-identity-regex "$SIGNER_IDENTITY" --predicate-type "$PREDICATE_TYPE" \
    --deny-self-hosted-runners --format json >"$work/verified.json"
  jq -e --arg release "$TAG" --arg repo "$FORGE_REPO" \
    'length > 0 and all(.[]; .verificationResult.statement.predicate.release == $release and .verificationResult.statement.predicate.repository == $repo)' \
    "$work/verified.json" >/dev/null || {
    echo "::error::$SIGNATURE_ASSET verifies $(basename "$f") but was not signed for $FORGE_REPO $TAG" >&2
    exit 1
  }
done
echo "verified $archives archives and checksums.txt against $TAG's signature"

# The renderer from the tag being published names that release's assets.
curl -fsSL --retry 5 --retry-all-errors -o "$work/render.sh" \
  "https://raw.githubusercontent.com/$FORGE_REPO/$TAG/scripts/render-homebrew-formula.sh"
mkdir -p "$(dirname "$OUT")"
bash "$work/render.sh" "$VERSION" "$work/checksums.txt" >"$work/forge.rb"

# Independent of the renderer: every url in the formula must be this release's
# archive, and the sha256 on the line after it must be that archive's signed one.
pairs="$(awk '
  /^[[:space:]]*url "/ { gsub(/.*url "|".*/, ""); url = $0; next }
  /^[[:space:]]*sha256 "/ && url != "" { gsub(/.*sha256 "|".*/, ""); print url, $0; url = "" }
' "$work/forge.rb")"
count=0
while read -r url sum; do
  [ -n "$url" ] || continue
  case "$url" in
    "https://github.com/$FORGE_REPO/releases/download/$TAG/"forge_*.tar.gz) ;;
    *)
      echo "::error::rendered formula points at $url, not a $TAG archive" >&2
      exit 1
      ;;
  esac
  name="${url##*/}"
  want="$(awk -v f="$name" '$2 == f || $2 == "*" f { print $1; exit }' "$work/checksums.txt")"
  if [ "$sum" != "$want" ]; then
    echo "::error::rendered formula pins $name to $sum; the signed checksums.txt says '$want'" >&2
    exit 1
  fi
  count=$((count + 1))
done <<<"$pairs"
[ "$count" -ge 4 ] || {
  echo "::error::rendered formula has $count url/sha256 pairs; expected 4" >&2
  exit 1
}

cp "$work/forge.rb" "$OUT"
echo "rendered $OUT for forge $VERSION ($count archives, sha256 $(sha256_of "$OUT"))"
