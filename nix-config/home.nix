{ pkgs, ... }: {
  imports = [
    ./modules/atuin.nix
    ./modules/carapace.nix
    ./modules/claude-code.nix
    ./modules/direnv.nix
    ./modules/ghostty.nix
    ./modules/git.nix
    ./modules/helix.nix
    ./modules/herdr.nix
    ./modules/jjui.nix
    ./modules/jujutsu.nix
    ./modules/karabiner.nix
    ./modules/nushell.nix
    ./modules/starship.nix
    ./modules/zed-editor.nix
    ./modules/zoxide.nix
  ];

  # Home Manager needs configuration version
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home.packages = import ./modules/packages.nix { inherit pkgs; };

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "hx";
    JAVA_HOME = "/etc/profiles/per-user/rrajath/bin";
  };

  programs.git = {
    settings.user.email = "r.rajath@protonmail.com";
  };
}
