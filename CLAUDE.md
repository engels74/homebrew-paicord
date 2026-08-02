# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

A single-cask Homebrew tap (`engels74/paicord`) distributing [Paicord](https://github.com/llsc12/Paicord), an unofficial macOS Discord client. The tap does not build the app. `.github/workflows/update-cask.yml` pulls the latest upstream CI artifact, re-hosts it as a DMG on this repository's `latest` release, and rewrites `Casks/paicord.rb`. That cask file is machine-maintained.

## Essential Commands

There is no build, test, lint, or type-check pipeline in this repository — the only automation is GitHub Actions.

```bash
# Consumer commands documented in README.md
brew tap engels74/paicord
brew install --cask paicord
brew upgrade --cask paicord
brew uninstall --cask --zap paicord   # --zap also removes the ~/Library paths in the cask

# Trigger the automation manually (both workflows enable workflow_dispatch)
gh workflow run update-cask.yml
gh workflow run immortality.yml
```

`update-cask.yml` also runs on a 6-hour cron. `immortality.yml` runs monthly and executes `gh-workflow-immortality.sh` to stop scheduled workflows from being disabled for repository inactivity; it is the only workflow needing `secrets.PERSONAL_TOKEN` (update-cask uses the default `github.token` plus `secrets.VT_API_KEY`).

## Update Pipeline

`update-cask.yml` has two jobs:

1. `update` — resolves the newest successful `build.yml` run on `llsc12/Paicord@main`, derives the version as `<commit-date>-<7-char-sha>`, and compares it against the `version` line in `Casks/paicord.rb`. If they match, every later step is skipped.
2. On a change it downloads `Paicord-macOS.zip` from nightly.link, extracts `Paicord.dmg`, computes SHA256, deletes and recreates the `latest` release with the DMG attached, `sed`s the new `version`/`sha256` into the cask, and commits as `github-actions[bot]`.
3. `virustotal-scan` — gated on `needs.update.outputs.updated == 'true'`, receives the DMG via the `Paicord-DMG` artifact, and appends scan results to the release notes. Any new job that needs the DMG must download that artifact; it is not on the runner otherwise.

The cask `url` is a constant pointer at the `latest` release tag — only `version` and `sha256` ever change. The release is deleted and recreated each cycle, so older DMGs are not retained. Do not add a `livecheck` or per-version URL that assumes versioned release assets exist.

## Critical Gotchas

- **Never hand-edit `version` or `sha256` in `Casks/paicord.rb`** — its header comment says so. The workflow rewrites them; a manual edit is either overwritten on the next run or triggers a spurious update. To change the shipped build, re-run the workflow instead.
- **Keep the cask's line formatting exact.** The workflow writes with `sed -i "s/^\(  version \)\".*\"/..."` and reads with `grep -E '^\s*version\s+"'`. Reindenting those lines, collapsing them, or introducing a second `version`/`sha256` line silently breaks the update job.
- **The version string must end in 7 hex characters.** The release notes' diff link comes from `grep -oE '[0-9a-f]{7}$'` on the previous version; any other suffix drops the "Changes" comparison.
- **`gh-workflow-immortality.sh` is vendored third-party code** (MIT, Daniel Rudolf, with `VERSION`/`BUILD` in its header). Replace it wholesale with a newer upstream release rather than patching it in place.
- **Do not bump GitHub Action versions by hand.** `renovate.json` automerges all Actions updates including majors (`automergeType: branch`, `ignoreTests: true`).

## Editing the Cask

When changing anything other than `version`/`sha256`, preserve these stanzas:

- `depends_on macos: :sonoma` — the declared minimum macOS.
- `postflight` running `xattr -r -d com.apple.quarantine` on the installed app. Keep `must_succeed: false` so install does not fail when the attribute is absent.
- `caveats` and the README warning both state the Discord ToS risk — update them together.
- `zap trash:` lists the `com.llsc12.Paicord` support paths; extend it when upstream adds new locations.

## Additional Documentation

- `README.md` — read before changing install instructions, the `YYYY-MM-DD-SHORTSHA` version-format description, or the licensing/attribution notice (this tap is AGPL-3.0; the upstream app is GPL-3.0).
