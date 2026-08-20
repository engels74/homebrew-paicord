# AGENTS.md

This file provides guidance to AI coding agents when working with code in this
repository.

## What this is

A single-cask Homebrew tap (`engels74/paicord`) for [Paicord](https://github.com/llsc12/Paicord),
an unofficial macOS Discord client. It ships no application source and has no build, test, lint,
or typecheck pipeline — the only code here is two GitHub Actions workflows and one vendored script.

`Casks/paicord.rb` is machine-maintained: `.github/workflows/update-cask.yml` runs on a 6-hour
cron, resolves the newest successful upstream `build.yml` run, re-hosts the DMG on this repo's
fixed `latest` release, and `sed`s the new `version`/`sha256` into the cask. Everything else in
the repo is hand-maintained.

## Cask gotchas

- **Never hand-edit `version` or `sha256` in `Casks/paicord.rb`.** A manual edit is either
  overwritten on the next cron run or triggers a spurious update. To ship a different build,
  re-run the workflow instead: `gh workflow run update-cask.yml` (both workflows expose
  `workflow_dispatch`).
- **Keep the shape of those two lines exact.** The workflow writes with
  `sed -i "s/^\(  version \)\".*\"/..."` and reads with `grep -E '^\s*version\s+"'`. Changing the
  two-space indent, wrapping the line, or adding a second `version`/`sha256` line makes the update
  silently no-op rather than fail.
- **The version string must end in exactly 7 hex characters** (`YYYY-MM-DD-SHORTSHA`). The
  release-notes diff link comes from `grep -oE '[0-9a-f]{7}$'` on the previous version; any other
  suffix silently drops the "Changes" section.
- **`url` is a constant pointer at the `latest` release tag**, which is deleted and recreated on
  every update, so no per-version assets exist. Don't add a `livecheck` or a versioned URL — the
  version is derived from the upstream commit, not from a release listing.
- When changing anything else in the cask, preserve: `depends_on macos: :sonoma`; the `postflight`
  `xattr -r -d com.apple.quarantine` with `must_succeed: false` (install must survive an absent
  attribute); the `zap trash:` `com.llsc12.Paicord` paths. The `caveats` Discord-ToS warning is
  duplicated in `README.md` — change both together.

## Workflow gotchas

- The `virustotal-scan` job runs on a separate runner and receives the DMG only through the
  `Paicord-DMG` artifact (1-day retention). Any new job that needs the DMG must download that
  artifact; it is not otherwise on the runner.
- Secrets differ per workflow: `update-cask.yml` uses the default `github.token` plus
  `secrets.VT_API_KEY`; `immortality.yml` uses `secrets.PERSONAL_TOKEN`.
- **Don't bump `uses:` action versions by hand.** `renovate.json` automerges all GitHub Actions
  updates including majors (branch automerge, `ignoreTests: true`).
- `gh-workflow-immortality.sh` is vendored third-party MIT code (`VERSION="1.1.1"`,
  `BUILD="20250304"`, Daniel Rudolf). Replace it wholesale with a newer upstream release rather
  than patching it in place.

## Reference

- `.github/workflows/update-cask.yml` — authoritative for the update pipeline: version derivation,
  nightly.link download, release recreation, cask rewrite, bot commit. Read before changing
  anything about how the cask gets updated.
- `README.md` — user-facing install/upgrade/zap commands, the `YYYY-MM-DD-SHORTSHA` version-format
  description, and the licensing note (tap AGPL-3.0, upstream app GPL-3.0). Read before editing
  any of those.
