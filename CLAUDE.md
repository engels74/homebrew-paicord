# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this
repository.

## Scope

- This repository is only the Homebrew tap and release automation; Paicord application source
  lives upstream and is not built here.
- `Casks/paicord.rb` is the sole package definition. `.github/workflows/update-cask.yml` owns
  the rolling release and automated cask updates.

## Invariants

- Do not manually change `version` or `sha256` in `Casks/paicord.rb`; let the update workflow
  derive both from the latest successful upstream `build.yml` run and downloaded DMG.
- Keep those two cask fields at exactly two spaces of indentation. The workflow's anchored
  `sed` replacements silently stop matching if their indentation or shape changes.
- Keep the cask URL on this repository's `latest` release asset, `Paicord.dmg`. The upstream
  build is an ephemeral nightly.link artifact; the workflow re-hosts it here.
- A release identity change is cross-file: the `latest` tag and `Paicord.dmg` asset name are
  coupled between `Casks/paicord.rb` and `.github/workflows/update-cask.yml`.

## Verification

- No build, test, lint, or typecheck command is defined in this repository, and the workflows
  do not validate the cask before the update job commits it.

## Reference files

- `.github/workflows/update-cask.yml` — complete update/release/scan pipeline. Read before
  changing cask versioning, artifact hosting, release notes, or update automation.
- `.github/workflows/immortality.yml` and `gh-workflow-immortality.sh` — monthly scheduled
  workflow keepalive using `PERSONAL_TOKEN`. Read only when changing keepalive behavior.
