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
