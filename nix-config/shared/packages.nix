{ pkgs }:

with pkgs; [
  # General packages for development and system management
  broot
  bat
  direnv
  nixd
  cargo
  deno
  jre8
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
