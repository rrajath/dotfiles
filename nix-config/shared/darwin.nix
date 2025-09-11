{ user, pkgs, ... }:
{
  imports = [
    ../modules/macos-settings.nix
  ];
  
  nix = {
    package = pkgs.nix;
    settings = {
      trusted-users = [ "@admin" "${user}" ];
      substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };

    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.emacs.enable = true;
  
  # Set Nushell as the default shell
  environment.shells = [ pkgs.nushell ];
  
  # Configure the default shell for the user
  users.users.${user} = {
    shell = pkgs.nushell;
  };
  
  # Enable Homebrew
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };
  
  # Define primary user
  system.primaryUser = user;
  
  # TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
  
  # Used for backwards compatibility
  system.stateVersion = 6;
  
  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";
}
