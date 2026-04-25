{ ... }: {
  xdg.configFile."ghostty/config".text = ''
    theme = Catppuccin Mocha
    window-save-state = always
    background-blur-radius = 20
    background-opacity = 1.0
    keybind = global:ctrl+shift+t=toggle_quick_terminal
    keybind = alt+left=unbind
    keybind = alt+right=unbind
    macos-titlebar-style = tabs
    mouse-hide-while-typing = true
    shell-integration-features = ssh-terminfo,ssh-env
  '';
}
