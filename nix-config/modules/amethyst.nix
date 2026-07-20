{ config, ... }:

{
  # Amethyst reads ~/.config/amethyst/amethyst.yml when present (falling back to
  # its preferences plist otherwise). Out-of-store symlink so edits in the repo
  # apply without a rebuild.
  xdg.configFile."amethyst/amethyst.yml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/amethyst/amethyst.yml";
}
