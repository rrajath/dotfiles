{ pkgs }:

with pkgs; [
  # General packages for development and system management
  broot
  bat
  direnv
  nixd
  cargo
  deno
  jdk21
  eas-cli
  hugo
  zola
  bun
  multimarkdown
  go-grip
  pnpm
  syncthing-macos
  go
  claude-usage-tracker

  # Migrated from Homebrew (see docs/BREW_TO_NIX.md)
  eza
  ffmpeg
  bitwarden-cli
  cmake
  fontforge
  git-filter-repo

  # TUI Apps
  jjui

  # Language servers
  nil                    # Nix LSP
  typescript-language-server
# nodePackages.pyright   # Python LSP
  rust-analyzer          # Rust LSP

  # Formatters
  nixpkgs-fmt           # Nix formatter
  black                 # Python formatter
  prettier # JS/TS formatter

  # Other useful tools
  ripgrep               # Fast grep (used by Helix)
  fd                    # Fast find (used by Helix)
  tree-sitter           # Syntax highlighting
]
