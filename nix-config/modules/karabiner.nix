{ config, ... }:

{
  # Install Karabiner Elements (you'll still need to add this to your darwin configuration)
  # homebrew.casks = [ "karabiner-elements" ];

  xdg.configFile."karabiner".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/karabiner";
}
