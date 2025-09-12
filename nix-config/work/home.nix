{ pkgs, ... }: {
  imports = [
    ../shared/home.nix
    # Work-specific modules only
  ];
  
  # Work-specific packages
  home.packages = with pkgs; [
    # Work packages
  ] ++ (pkgs.callPackage ../modules/packages.nix { });
  
  # Work-specific program configurations
  programs.git = {
    userEmail = "work@company.com";
    # other work git settings
  };
}
