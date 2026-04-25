{ ... }: {
  xdg.configFile."herdr/config.toml".text = ''
    [theme]
    name = "catppuccin"

    [keys]
    prefix = "ctrl+,"
    # open the palette with prefix+space
    workspace_picker = "prefix+w"

    [ui.toast]
    show_agent_labels_on_pane_borders = true
    delivery = "herdr"
    delay_seconds = 1

    [ui.toast.herdr]
    position = "bottom-right"

    [ui.toast.clipboard]
    enabled = true
    position = "bottom-center"
  '';
}
