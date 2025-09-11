{ user, pkgs, ... }:
{
  # Work-specific system packages
  environment.systemPackages = with pkgs; [
    # Add work system packages here
  ];
  
  # Work-specific Homebrew apps
  homebrew = {
    casks = pkgs.callPackage ../shared/casks.nix { } ++ [
    ];
    brews = pkgs.callPackage ../shared/brews.nix { } ++ [
    ];
  };
}
