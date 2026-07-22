# Homebrew formulas
# Snapshot of `brew leaves` taken 2026-07-19, minus:
#   - emacs-plus orphans left undeclared (gcc, libgccjit, enchant, pygobject3, icu4c@76)
#   - prettier / typescript-language-server (provided by nix, brew copies uninstalled)
# bitwarden-cli, cmake, eza, ffmpeg, fontforge, git-filter-repo migrated to
# modules/packages.nix; tmux dropped (no config anywhere). See docs/BREW_TO_NIX.md.
# coreutils stays in brew: nixpkgs' plain `coreutils` installs unprefixed binaries
# (ls, cp, mv, rm, cat...) that shadow macOS system tools system-wide, unlike brew's
# g-prefixed install. `coreutils-prefixed` would fix that but wasn't chosen — revisit
# in docs/BREW_TO_NIX.md if this comes up again.
[
  "bash"
  "coreutils"
  "gnu-sed"
  "llama.cpp"
  "mas"
  "n"
  "opencode"
  "emacs-plus@30"
]
