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
    settings.user.email = "r.rajath@protonmail.com";
  };
}
