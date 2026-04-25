{ ... }: {
  xdg.configFile."jjui/config.toml".text = ''
    [custom_commands]
    "tug" = { key = ["T"], args = ["tug"] }
  '';
}
