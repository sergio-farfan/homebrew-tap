# homebrew-tap

Personal [Homebrew](https://brew.sh) tap for [Sergio Farfan](https://github.com/sergio-farfan)'s projects.

## Install

```bash
brew install --cask sergio-farfan/tap/alttab
brew install --cask sergio-farfan/tap/nosleep
```

Using the fully qualified name trusts just that cask (Homebrew ≥ 6 requires third-party
taps to be trusted before their code runs). To use short names instead, trust the whole
tap first — note the order, trust *before* tap:

```bash
brew trust sergio-farfan/tap && brew tap sergio-farfan/tap
brew install --cask alttab nosleep
```

Update with `brew upgrade --cask <cask>`; remove with `brew uninstall --cask --zap <cask>`.

## Casks

| Cask | Description |
|------|-------------|
| [`alttab`](Casks/alttab.rb) | [AltTab](https://github.com/sergio-farfan/alttab-macos) — Windows-style window switcher for macOS |
| [`nosleep`](Casks/nosleep.rb) | [NoSleep](https://github.com/sergio-farfan/nosleep) — menu bar toggle for `caffeinate` that prevents idle sleep |

AltTab releases are ad-hoc signed and not yet notarized: on first launch macOS blocks the
app — allow it once in **System Settings → Privacy & Security → Open Anyway**. The app also
needs the **Accessibility** permission, which macOS asks for again after each update
(ad-hoc identities change per build).

NoSleep releases are ad-hoc signed as well (same first-launch step). NoSleep asks for
**notification** permission on first launch, for its session-ended alert; `brew uninstall`
also removes its Start at Login item, and `--zap` its preferences and single-instance lock.

## Maintenance

- Every push and pull request runs [`tests.yml`](.github/workflows/tests.yml):
  `brew test-bot --only-tap-syntax` (readall, audit, style), an online cask audit, and an
  install/uninstall smoke test on a clean macOS runner.
- New app releases update the cask through [`bump.yml`](.github/workflows/bump.yml): the
  app repository's release workflow sends a `repository_dispatch` (`alttab-release`,
  `nosleep-release`) with the cask, version and sha256; the workflow runs `brew bump-cask-pr --write-only --commit`, validates,
  and pushes. It can also be run by hand from the Actions tab (`workflow_dispatch`).
