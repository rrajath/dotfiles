{ pkgs, profile, ... }:
{
  imports = [
    ../shared/home.nix
  ];
  
  # Personal-specific packages
  home.packages = with pkgs; [
    # Personal packages
  ] ++ (pkgs.callPackage ../modules/packages.nix { });
  
  # Personal-specific program configurations
  programs.git = {
    userEmail = "r.rajath@protonmail.com";
    # other personal git settings
  };
}
