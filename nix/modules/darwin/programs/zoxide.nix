{pkgs, config, lib, ...}: {
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };
}
