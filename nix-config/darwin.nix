{ user, pkgs, ... }: {
  imports = [
    ./modules/macos-settings.nix
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

  # Homebrew: activation only installs/uninstalls from the lists below.
  # autoUpdate/upgrade stay off because brew update during activation hangs on macOS 26;
  # run brew update/upgrade manually when needed.
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };
    taps = [
      "devenjarvis/tap" # lathe
    ];
    casks = import ./casks.nix;
    brews = import ./brews.nix;
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
  nixpkgs.config.allowUnfree = true;
}
