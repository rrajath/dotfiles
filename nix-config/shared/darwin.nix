{ user, pkgs, ... }:
{
  imports = [
    ../modules/macos-settings.nix
  ];
  
  # Enable experimental features for flakes
  nix.settings.experimental-features = "nix-command flakes";
  
  # Set Nushell as the default shell
  environment.shells = [ pkgs.nushell ];
  
  # Configure the default shell for the user
  users.users.${user} = {
    shell = pkgs.nushell;
  };
  
  # Enable Homebrew
  homebrew.enable = true;
  
  # Define primary user
  system.primaryUser = user;
  
  # TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
  
  # Used for backwards compatibility
  system.stateVersion = 6;
  
  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";
}
