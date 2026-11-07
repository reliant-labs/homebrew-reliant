# Homebrew Tap for Reliant

This is the official [Homebrew](https://brew.sh/) tap for [Reliant](https://reliantlabs.io/), the AI-powered coding assistant.

## Installation

```bash
# Add the tap
brew tap reliant-labs/reliant

# Install Reliant
brew install --cask reliant
```

Or install directly with a single command:

```bash
brew install --cask reliant-labs/reliant/reliant
```

## forge

[forge](https://github.com/reliant-labs/forge), Reliant's framework for building and shipping apps, installs from this tap as a formula:

```bash
brew install reliant-labs/reliant/forge
forge version
```

`Formula/forge.rb` is rendered from each forge release's `checksums.txt` by the `Update forge formula` workflow.

## Automation

Every release lands here without a human step, and a stall is loud:

| Package | Workflow | Triggered by | Gate before it reaches `main` |
|---|---|---|---|
| `Formula/forge.rb` | `update-forge-formula.yml` | forge's release script (`forge-release-published`), and every 30 minutes | The release's archives and `checksums.txt` verify against forge's Sigstore release signature; the formula's every url/sha256 matches the signed `checksums.txt`; `brew install` + `brew test` + `forge version` on macOS and Linux |
| `Casks/reliant.rb` | `update-cask.yml` | reliant's release workflow (`release-published`), and every 30 minutes | Both DMGs' sha512 match the release's `latest-mac.yml`; the cask keeps its exact shape; `brew install --cask` on macOS reports the version |

A bump that passes its gate is pushed straight to `main` by the tap's deploy
key (`HOMEBREW_TAP_DEPLOY_KEY`), the only identity the `main` ruleset lets skip
its review, and only for that one file. The `main: history` ruleset, which the
key does not bypass, still forbids force pushes and deletion. Every other
change to this repository needs an approving review, as before.

If the tap stays behind the latest release for more than 3 hours, the
workflow's `staleness` job fails and opens the issue "forge on Homebrew is
behind its latest release" (or "Reliant on ..."), and closes it once caught up.

Setting up or rotating the key is one command for a repository admin:
`scripts/setup-automation.sh` (`--dry-run` first to see the changes). Without
the key, bumps fall back to a pull request that needs an approval.

## Updating

```bash
brew upgrade --cask reliant
```

## Uninstalling

```bash
brew uninstall --cask reliant
```

## What is Reliant?

Reliant is an AI-powered coding assistant with intelligent agents for professional software development. It provides:

- Multi-agent workflows for complex coding tasks
- Intelligent code analysis and suggestions
- Seamless integration with your development environment

Learn more at [reliantlabs.io](https://reliantlabs.io/).

## Issues

- For issues with the Homebrew formula, please [open an issue here](https://github.com/reliant-labs/homebrew-reliant/issues).
- For issues with Reliant itself, please [open an issue on the main repo](https://github.com/reliant-labs/reliant/issues).

## License

MIT
