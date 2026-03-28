# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Homebrew tap (`engels74/paicord`) that distributes [Paicord](https://github.com/llsc12/Paicord), an unofficial native Discord client for macOS. The tap contains a single cask definition and a GitHub Actions workflow that auto-updates it.

## Repository Structure

- `Casks/paicord.rb` — The Homebrew cask formula. The `version` and `sha256` lines are auto-managed by CI; do not edit them manually.
- `.github/workflows/update-cask.yml` — Runs every 6 hours (and on manual dispatch). Checks the upstream Paicord repo for new successful builds, downloads the DMG via nightly.link, re-hosts it as a GitHub release on this repo, and updates the cask.

## Version Scheme

Versions use the format `YYYY-MM-DD-SHORTSHA` (e.g., `2026-03-18-f6d294d`), derived from the upstream commit date and 7-char SHA.

## Key Commands

```bash
# Install the cask locally for testing
brew tap engels74/paicord
brew install --cask paicord

# Audit the cask formula
brew audit --cask Casks/paicord.rb

# Lint the cask (style checks)
brew style Casks/paicord.rb
```

## How the Auto-Update Workflow Works

1. Queries the GitHub API for the latest successful `build.yml` run on `llsc12/Paicord` (main branch).
2. Compares the derived version against the current version in `Casks/paicord.rb`.
3. If newer: downloads the DMG zip from `nightly.link`, extracts it, computes SHA256.
4. Deletes the existing `latest` GitHub release, creates a new one with the fresh DMG.
5. Updates `version` and `sha256` in the cask file via `sed`, commits, and pushes.

The DMG URL in the cask always points to `https://github.com/engels74/homebrew-paicord/releases/download/latest/Paicord.dmg` (a stable URL; the release asset is replaced on each update).

## Cask Conventions

- The cask follows standard Homebrew cask DSL. Key stanzas: `url`, `name`, `desc`, `homepage`, `depends_on`, `app`, `zap`, `caveats`.
- `zap trash:` lists all known application data paths for clean uninstall.
- The `caveats` block warns users about Discord ToS risks.
