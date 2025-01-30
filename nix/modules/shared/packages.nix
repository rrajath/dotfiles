{ pkgs }:

with pkgs; [
  # General packages for development and system management

  # Text and Terminal Utilities
  tldr
  jujutsu
  cargo
  atuin
  fzf
  zoxide
  carapace
  direnv
  hugo
  jq
  ripgrep
  gawk
  aspell
  
  # GUI Apps
  alacritty
  wezterm
  vscode
  postman
  aerospace

  # TUI Apps
  yazi
  helix
  bat
  broot
  zellij
  (lazyjj.overrideAttrs (_: {
    doCheck = false;
  }))
  
  # Shells
  nushell
  fish

  # Utilites
  coreutils
  nil
  nixpkgs-fmt
  
  # Encryption and security tools
  gnupg


  # Cloud-related tools and SDKs
  colima
  lazydocker
  docker-compose

  # Media-related packages
  emacs-all-the-icons-fonts
  #  dejavu_fonts
  #  ffmpeg
  #  fd
  #  font-awesome
  #  hack-font
  #  noto-fonts
  #  noto-fonts-emoji
  #  meslo-lgs-nf

  # Node.js development tools
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs
  deno

  # Text and terminal utilities
  #  htop
  #  hunspell
  #  iftop
  #  jetbrains-mono

  #  tree
  #  tmux
  #  unrar
  #  unzip
  #  zsh-powerlevel10k

  # Python packages
  python3
  virtualenv
  pipx
]
