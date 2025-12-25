{ ... }: {
  xdg.configFile."ghostty/config".text = ''
    theme = Catppuccin Mocha
    window-save-state = always
    background-blur-radius = 20
    background-opacity = 0.7
    keybind = global:ctrl+shift+t=toggle_quick_terminal
    keybind = alt+left=unbind
    keybind = alt+right=unbind
    macos-titlebar-style = tabs
    mouse-hide-while-typing = true
  '';
}
