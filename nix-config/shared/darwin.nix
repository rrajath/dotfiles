{ user, pkgs, ... }: {
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

  # Set Nushell as the default shell
  environment.shells = [ pkgs.nushell ];
  
  # Configure the default shell for the user
  users.users.${user} = {
    shell = pkgs.nushell;
  };
  
  # Enable Homebrew
  homebrew = {
    enable = false; # There's some issue with updating homebrew via nix on the latest MacOS 26. So, setting it to false for now
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };
  
  # TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    # Used for backwards compatibility
    stateVersion = 6;
    # Define primary user
    primaryUser = user;
  };
  
  
  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";
}
