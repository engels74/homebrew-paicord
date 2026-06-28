# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Homebrew tap providing a single cask, `paicord`, for [Paicord](https://github.com/llsc12/Paicord) — an unofficial macOS Discord client. The tap re-hosts upstream nightly DMG builds as a rolling GitHub release and keeps `Casks/paicord.rb` updated automatically. There is no application source code in this repo.

## Layout

- `Casks/paicord.rb` — the cask definition; the only deliverable of this repo.
- `.github/workflows/update-cask.yml` — automation entry point. Everything else exists to support it.
- `.github/workflows/immortality.yml` + `gh-workflow-immortality.sh` — monthly keepalive so the scheduled cron is not suspended for inactivity.
- `renovate.json` — Renovate config; automerges all GitHub Actions version bumps.

## How updates flow (`update-cask.yml`)

Runs on a 6-hour cron and `workflow_dispatch`. Each run:
1. Reads the latest successful `build.yml` run from `llsc12/Paicord` and derives `new_version` as `YYYY-MM-DD-SHORTSHA` (upstream commit date + 7-char short SHA).
2. Compares it against the `version` in `Casks/paicord.rb`; exits early if unchanged.
3. Downloads the DMG via `nightly.link`, computes SHA256, and re-hosts it on this repo's rolling `latest` release.
4. Rewrites the `version` and `sha256` lines in `Casks/paicord.rb` with `sed`, then commits and pushes.
5. The dependent `virustotal-scan` job scans the DMG and appends results to the release notes.

## Repository-specific rules

- Do not manually edit the `version` or `sha256` lines in `Casks/paicord.rb`; the workflow owns them (see the file's header comment). Manual bumps get overwritten and can desync the version from its checksum.
- If you restructure `Casks/paicord.rb`, keep `version` and `sha256` at exactly two leading spaces. `update-cask.yml` rewrites them with anchored `sed` patterns (`^\(  version \)"..."` and `^\(  sha256 \)"..."`); any other indentation silently breaks the automation.
- The cask `url` must keep pointing at this repo's rolling `latest` release (`releases/download/latest/Paicord.dmg`), not at upstream — upstream only publishes ephemeral CI artifacts.

## Validating a cask edit

For structural cask changes (anything other than version/sha256), validate locally with standard Homebrew tooling — no CI gate enforces this:

```bash
brew style --cask Casks/paicord.rb
brew audit --cask Casks/paicord.rb
```

User-facing install command (see `README.md`): `brew install --cask engels74/paicord/paicord`.
