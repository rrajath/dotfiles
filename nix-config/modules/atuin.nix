{ ... }: {
  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    flags = [
      "--disable-up-arrow"
    ];
    # Captured from the previously unmanaged ~/.config/atuin/config.toml
    settings = {
      enter_accept = true;
      sync.records = true;
    };
  };
}
