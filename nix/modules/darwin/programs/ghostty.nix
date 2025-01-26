{ lib, ... }:

let
  inherit (lib.generators) toKeyValue mkKeyValueDefault;
in
{
  xdg.configFile."ghostty/config".text = toKeyValue { mkKeyValue = mkKeyValueDefault { } " = "; } {
    theme = "catppuccin-mocha";
    window-save-state = "always";
    background-blur-radius = 20;
    background-opacity = 0.7;
    keybind = "global:ctrl+shift+t=toggle_quick_terminal";
    macos-titlebar-style = "tabs";
  };
}
