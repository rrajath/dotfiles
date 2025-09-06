{ pkgs, ... }: {
  # Install Atuin package
  home.packages = with pkgs; [
    atuin
  ];

  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    flags = [
      "--disable-up-arrow"
    ];
  };
}
