{ user, ... }:

{
  home-manager.users.${user} = {
    home.file = {
      ".config/alacritty".source = ../../../../alacritty;
      # ".config/aerospace/aerospace.toml".source = ../../../../aerospace/aerospace.toml;
      ".wezterm.lua".source = ../../../../wezterm/wezterm.lua;
      ".config/karabiner".source = ../../../../karabiner;
    };
  };
}
