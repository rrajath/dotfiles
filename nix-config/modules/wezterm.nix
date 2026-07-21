{ lib, ... }: {
  programs.wezterm = {
    enable = true;

    settings = {
      font = lib.generators.mkLuaInline ''wezterm.font("JetBrainsMono Nerd Font")'';
      font_size = 17;

      enable_tab_bar = true;
      window_decorations = "RESIZE";
      hide_tab_bar_if_only_one_tab = true;

      window_background_opacity = 0.8;
      macos_window_background_blur = 10;

      keys = [
        {
          key = "d";
          mods = "CMD";
          action = lib.generators.mkLuaInline ''wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }'';
        }
        {
          key = "d";
          mods = "CMD|SHIFT";
          action = lib.generators.mkLuaInline ''wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }'';
        }
      ];

      max_fps = 120;
      prefer_egl = true;

      color_scheme = "catppuccin-mocha";
    };
  };
}
