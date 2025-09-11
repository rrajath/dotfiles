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

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "hx";
  };
}
