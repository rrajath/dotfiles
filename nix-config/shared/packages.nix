{ pkgs }:

with pkgs; [
  # General packages for development and system management
  broot
  bat
  direnv
  nixd
  cargo
  deno

  # TUI Apps
  jjui

  # Language servers
  nil                    # Nix LSP
  nodePackages.typescript-language-server
# nodePackages.pyright   # Python LSP
  rust-analyzer          # Rust LSP
    
  # Formatters
  nixpkgs-fmt           # Nix formatter
  black                 # Python formatter
  nodePackages.prettier # JS/TS formatter
    
  # Other useful tools
  ripgrep               # Fast grep (used by Helix)
  fd                    # Fast find (used by Helix)
  tree-sitter           # Syntax highlighting
]
