# Brew → Nix migration backlog

*Snapshot taken 2026-07-19 during dotfiles consolidation (change #2). `nix-config/brews.nix` and `nix-config/casks.nix` now declare the full live Homebrew state. This file tracks what can move out of brew and into nixpkgs later, one small change at a time.*

## Formulas snapshotted in `brews.nix` (16)

### Available in nixpkgs — migrate to `modules/packages.nix` when ready

| Formula | nixpkgs attr | Notes |
|---|---|---|
| bash | `bash` | Only matters if scripts hardcode `/opt/homebrew/bin/bash` |
| bitwarden-cli | `bitwarden-cli` | |
| cmake | `cmake` | |
| coreutils | `coreutils` | |
| eza | `eza` | |
| ffmpeg | `ffmpeg` | Big closure; brew and nix builds have different codec flags — verify the ones you use |
| fontforge | `fontforge` | |
| git-filter-repo | `git-filter-repo` | |
| gnu-sed | `gnu-sed` | |
| llama.cpp | `llama-cpp` | nixpkgs build may lack Metal tuning brew has — benchmark before switching |
| opencode | `opencode` | Fast-moving tool; nixpkgs may lag brew on version |
| tmux | `tmux` | Or drop entirely — no config exists anywhere (open question in CONSOLIDATION.md) |

Migration recipe per formula: add to `modules/packages.nix` → `drp` → verify `which <tool>` points at `/etc/profiles/per-user/rrajath/bin` → remove from `brews.nix` → `brew uninstall <formula>`.

### Keep in brew (or decide separately)

| Formula | Why |
|---|---|
| mas | Mac App Store CLI — brew is the practical channel on macOS |
| n | Node version manager; imperative by design. Migrating means switching to nix-managed node versions instead — a workflow change, not a package swap |
| ~~openjdk@17, openjdk@21~~ | **Done**: replaced by nix `jdk21` with `JAVA_HOME = "${pkgs.jdk21.home}"`; both brew JDKs uninstalled |

## Already handled in change #2

- **Uninstalled** brew `prettier` and `typescript-language-server` — nix (`packages.nix`) provides both and wins on PATH. Brew auto-removed their orphaned deps (`typescript`, `icu4c@76`) in the process.
- **Left installed but undeclared** (emacs-plus orphans): `gcc`, `libgccjit`, `enchant`, `pygobject3` (+ dep chain: aspell, fontconfig-adjacent libs). emacs-plus@30 itself is no longer installed. Once confirmed nothing needs them: `brew autoremove` then `brew uninstall gcc libgccjit enchant pygobject3`.
- **Unused taps left in place**: `d12frosted/emacs-plus`, `gromgit/brewtils`, `hamed-elfayome/claude-usage`. Only `devenjarvis/tap` (lathe) is declared in `darwin.nix`. Untap the others when convenient: `brew untap <tap>`.
- **Cask renames**: old `docker` / `tigervnc-viewer` installs are pre-rename aliases of `docker-desktop` / `tigervnc`; `casks.nix` declares only canonical names.

## End-state goal

`brews.nix` shrinks to genuinely-brew-only items (mas, n, possibly ffmpeg/llama.cpp). Once the lists have been stable for a while, flip `homebrew.onActivation.cleanup` from `"none"` to `"zap"` for fully declarative brew — **only after** everything wanted is declared, since zap uninstalls anything unlisted.
