{ user, pkgs, ... }:
{
  # Personal-specific system packages
  environment.systemPackages = with pkgs; [
    # Add personal system packages here
  ];
  
  # Personal-specific Homebrew apps
  homebrew = {
    casks = [
      # "discord"
      # Add personal apps here
    ];
  };
}
