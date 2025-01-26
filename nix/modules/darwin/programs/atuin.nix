{ ... }: {
  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    flags = [
      "--disable-up-arrow"
    ];
  };
}
