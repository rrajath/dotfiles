{ pkgs, ... }: {
  imports = [
    ../shared/home.nix
    ../modules/git.nix
  ];

  # Personal-specific packages
  home.packages = with pkgs; [
    # Personal packages
  ] ++ (pkgs.callPackage ../modules/packages.nix { });

  # Personal-specific program configurations
  programs.git = {
    userEmail = "r.rajath@protonmail.com";
  };
}
