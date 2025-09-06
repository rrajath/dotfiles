{ config, pkgs, lib, ... }:

{
  # Install Karabiner Elements (you'll still need to add this to your darwin configuration)
  # homebrew.casks = [ "karabiner-elements" ];

  # Link your existing Karabiner configuration
  # home.file.".config/karabiner/karabiner.json" = {
    # source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/karabiner/karabiner.json";
  # };

  home.file.".config/karabiner".source = ../../karabiner;

  # Optional: Also link any assets directory if you have one
  # home.file.".config/karabiner/assets" = lib.mkIf (builtins.pathExists "${config.home.homeDirectory}/dotfiles/karabiner/assets") {
    # source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/karabiner/assets";
  # };
}
