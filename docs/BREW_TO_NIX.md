# Brew → Nix migration backlog

*Snapshot taken 2026-07-19 during dotfiles consolidation (change #2). `nix-config/brews.nix` and `nix-config/casks.nix` now declare the full live Homebrew state. This file tracks what can move out of brew and into nixpkgs later, one small change at a time.*

## Formulas snapshotted in `brews.nix` (16 originally)

### Available in nixpkgs — migrate to `modules/packages.nix` when ready

| Formula | nixpkgs attr | Notes |
|---|---|---|
| bash | `bash` | Only matters if scripts hardcode `/opt/homebrew/bin/bash` |
| gnu-sed | `gnu-sed` | |
| llama.cpp | `llama-cpp` | nixpkgs build may lack Metal tuning brew has — benchmark before switching |
| opencode | `opencode` | Fast-moving tool; nixpkgs may lag brew on version |

Migration recipe per formula: add to `modules/packages.nix` → `drp` → verify `which <tool>` points at `/etc/profiles/per-user/rrajath/bin` → remove from `brews.nix` → `brew uninstall <formula>`.

### Done — moved to `modules/packages.nix` (2026-07-22)

`bitwarden-cli`, `cmake`, `eza`, `ffmpeg`, `fontforge`, `git-filter-repo`. Activated via `drp`; `which <tool>` confirmed nix wins on PATH; `brew uninstall`'d.

### Dropped

`tmux` — no config anywhere on this machine (open question in CONSOLIDATION.md, resolved: drop). Removed from `brews.nix`, `brew uninstall`'d.

### Keep in brew (or decide separately)

| Formula | Why |
|---|---|
| mas | Mac App Store CLI — brew is the practical channel on macOS |
| n | Node version manager; imperative by design. Migrating means switching to nix-managed node versions instead — a workflow change, not a package swap |
| coreutils | Tried 2026-07-22: nixpkgs' plain `coreutils` installs **unprefixed** binaries (`ls`, `cp`, `mv`, `rm`, `cat`...) that shadow macOS system/BSD tools everywhere on PATH — brew's formula avoids this by not linking unprefixed names. `coreutils-prefixed` (g-prefixed: `gls`, `gcp`...) would match brew's behavior if revisited later. |
| ~~openjdk@17, openjdk@21~~ | **Done**: replaced by nix `jdk21` with `JAVA_HOME = "${pkgs.jdk21.home}"`; both brew JDKs uninstalled |

## Already handled in change #2

- **Uninstalled** brew `prettier` and `typescript-language-server` — nix (`packages.nix`) provides both and wins on PATH. Brew auto-removed their orphaned deps (`typescript`, `icu4c@76`) in the process.
- **Left installed but undeclared** (emacs-plus orphans): `gcc`, `libgccjit`, `enchant`, `pygobject3` (+ dep chain: aspell, fontconfig-adjacent libs). emacs-plus@30 itself is no longer installed. Once confirmed nothing needs them: `brew autoremove` then `brew uninstall gcc libgccjit enchant pygobject3`.
- **Unused taps left in place**: `d12frosted/emacs-plus`, `gromgit/brewtils`, `hamed-elfayome/claude-usage`. Only `devenjarvis/tap` (lathe) is declared in `darwin.nix`. Untap the others when convenient: `brew untap <tap>`.
- **Cask renames**: old `docker` / `tigervnc-viewer` installs are pre-rename aliases of `docker-desktop` / `tigervnc`; `casks.nix` declares only canonical names.

## End-state goal

`brews.nix` shrinks to genuinely-brew-only items (mas, n, possibly llama.cpp). Once the lists have been stable for a while, flip `homebrew.onActivation.cleanup` from `"none"` to `"zap"` for fully declarative brew — **only after** everything wanted is declared, since zap uninstalls anything unlisted.
