{ pkgs }:

with pkgs; [
  # General packages for development and system management
  atuin
  bat
  broot
  coreutils
  helix
  neofetch
  nushell
  nil
  nixpkgs-fmt
  emacs30
  fzf
  zoxide
  carapace
  colima
  direnv
  lazydocker
  yazi
  alacritty
  aerospace
  jujutsu
  cargo
  (lazyjj.overrideAttrs (_: {
    doCheck = false;
  }))

  # Encryption and security tools
  gnupg


  # Cloud-related tools and SDKs
#  docker
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
  #  nodePackages.npm # globally install npm
  #  nodePackages.prettier
  #  nodejs

  # Text and terminal utilities
  #  htop
  #  hunspell
  #  iftop
  #  jetbrains-mono
  jq
  ripgrep
  #  tree
  #  tmux
  #  unrar
  #  unzip
  #  zsh-powerlevel10k

  # Python packages
  #  python3
  #  virtualenv
]
