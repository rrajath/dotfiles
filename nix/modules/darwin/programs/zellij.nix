{ pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    package = pkgs.zellij;

    settings = {
      pane_frames = true;
      default_mode = "normal";
      copy_on_select = true;

      theme = "catppuccin-mocha";
      themes = {
        catppuccin-mocha = {
          bg = "#585b70"; # Surface2
          fg = "#cdd6f4";
          red = "#f38ba8";
          green = "#a6e3a1";
          blue = "#89b4fa";
          yellow = "#f9e2af";
          magenta = "#f5c2e7"; # Pink
          orange = "#fab387"; # Peach
          cyan = "#89dceb"; # Sky
          black = "#181825"; # Mantle
          white = "#cdd6f4";
        };
      };
    };
  };

  # home.file.".config/zellij/layouts/dev.kdl".source = ./zellij/layouts/dev.kdl;
}
