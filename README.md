# homebrew-paicord

Homebrew tap for [Paicord](https://github.com/llsc12/Paicord) — a native Discord client for macOS built with Swift and SwiftUI.

> [!WARNING]
> Paicord is an unofficial, third-party Discord client. Using it violates Discord's Terms of Service. Your account may be suspended or banned. **Use at your own risk.**

## Install

```bash
brew tap engels74/paicord
brew install --cask paicord
```

Or as a one-liner:

```bash
brew install --cask engels74/paicord/paicord
```

## Update

```bash
brew upgrade --cask paicord
```

## Uninstall

```bash
brew uninstall --cask paicord
brew untap engels74/paicord
```

To also remove application data:

```bash
brew uninstall --cask --zap paicord
```

## How It Works

A [GitHub Actions workflow](.github/workflows/update-cask.yml) runs every 6 hours to check for new upstream builds. When a new build is detected, the workflow downloads the `.dmg`, computes its SHA256 checksum, re-hosts it on this repository's [releases](https://github.com/engels74/homebrew-paicord/releases), and updates the cask automatically.

Versions follow the format `YYYY-MM-DD-SHORTSHA`, reflecting the upstream commit date and hash.

---

This is an unofficial community-maintained tap, not affiliated with the Paicord developer(s). Licensed under [AGPL-3.0](LICENSE).
