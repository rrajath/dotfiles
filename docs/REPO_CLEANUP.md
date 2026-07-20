# Deferred repo cleanup

*Recorded 2026-07-19 during the consolidation work. These two steps from `CONSOLIDATION.md` (§6 phases 6) were explicitly deferred — pick them up whenever.*

## 1. Delete superseded legacy dirs (deferred 3g)

All dormant — no symlink or tool reads them; every live config moved into `nix-config/` modules. Git history preserves everything after deletion.

```
aerospace/  alacritty/  fish/  vim/  wezterm/  zsh/  doom_yasnippets.org  kitty/
```

- `kitty/` contains only a themes clone + literate README, no personal config. The kitty **cask** stays installed and declared in `casks.nix` regardless.
- Superseded by: amethyst (aerospace), ghostty (alacritty/wezterm/kitty), nushell (fish/zsh), helix (vim).

Already done on the home-dir side (2026-07-19): removed `~/.config/nushell` decoy stub, `~/.config/zellij` backups, `~/.config/karabiner.backup*`/`.bak` dirs.

**Intentionally untouched:** `~/.zshrc` and `~/.zshenv` — forge manages a block in `.zshrc`, and it contains a plaintext Anthropic API key (flagged for rotation / relocation to a proper secret store; don't delete these files without handling that).

## 2. Move app-settings exports into `archive/` (deferred 3h)

Pure `git mv` — these are exports/notes, not tangle sources; nothing reads them:

```
Alfred/  Apps/  BetterTouchTool/  brew/  BrowserExtensions/  Firefox/
iTerm2/  JetBrains/  MacSetup/  sublime/  VSCode/
```

`BetterTouchTool/` is the only recent export (2026) — it's the only BTT backup, keep it wherever it lands.
