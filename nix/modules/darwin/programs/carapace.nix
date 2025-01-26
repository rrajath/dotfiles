{pkgs, config, lib, ...}: {
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
