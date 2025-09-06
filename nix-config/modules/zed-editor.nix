{ config, pkgs, ... }: {
  programs.zed-editor = {
    enable = true;
    userSettings = {
      "helix_mode" = true;
      "ui_font_size" = 16;
      "theme" = {
        "mode" = "system";
        "light" = "One Light";
        "dark" = "One Dark";
      };
    };
    extensions = ["nix" "deno" "typescript"];
  };
}
