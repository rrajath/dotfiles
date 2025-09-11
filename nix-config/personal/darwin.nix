{ user, pkgs, ... }:
{
  # Personal-specific system packages
  environment.systemPackages = with pkgs; [
    # Add personal system packages here
  ];
  
  # Personal-specific Homebrew apps
  homebrew = {
    casks = pkgs.callPackage ../shared/casks.nix { } ++ [
    ];
    brews = pkgs.callPackage ../shared/brews.nix { } ++ [
    ];
  };
}
