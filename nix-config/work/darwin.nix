{ user, pkgs, ... }:
{
  # Work-specific system packages
  environment.systemPackages = with pkgs; [
    # Add work system packages here
  ];
  
  # Work-specific Homebrew apps
  homebrew = {
    casks = [
      # "slack"
      # "zoom"
      # Add work apps here
    ];
  };
}
