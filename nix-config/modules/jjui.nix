{ ... }: {
  xdg.configFile."jjui/config.toml".text = ''
    [[actions]]
    name = "tug"
    lua = ''''
    jj_async("tug")
    revisions.refresh()
    ''''

    [[bindings]]
    action = "tug"
    key = "T"
    scope = "revisions"
    desc = "tug"
  '';
}
