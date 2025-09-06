{ user, config, lib, pkgs, ... }:
{
  # Import shared modules
  imports = [
    ../modules/carapace.nix
    ../modules/ghostty.nix
    ../modules/helix.nix
    ../modules/nushell.nix
    ../modules/atuin.nix
    ../modules/jujutsu.nix
    ../modules/starship.nix
    ../modules/zed-editor.nix
  ];
  
  # Home Manager needs configuration version
  home.stateVersion = "23.11";
  
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  xdg.enable = true;
  xdg.configHome = "${config.home.homeDirectory}/.config";
  
  # Set environment variables
  home.sessionVariables = {
    EDITOR = "hx";
  };
}
