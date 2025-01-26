{pkgs, config, lib, ...}: {
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };
}
