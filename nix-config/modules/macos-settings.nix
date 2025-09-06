{ ... }: {
  system = {
    stateVersion = 6;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        KeyRepeat = 2; # Values: 120, 90, 60, 30, 12, 6, 2
        InitialKeyRepeat = 15; # Values: 120, 94, 68, 35, 25, 15

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        autohide-delay = 3.0;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 48;
        expose-group-apps = true;
        mru-spaces = false;
      };

      finder = {
       _FXShowPosixPathInTitle = false;
       FXDefaultSearchScope = "SCcf";
       FXEnableExtensionChangeWarning = false;
       FXPreferredViewStyle = "clmv";
       NewWindowTarget = "Home";
       ShowPathbar = true;
       ShowStatusBar = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };

  # security.pam.services.sudo_local.touchIdAuth = true;  # Enable Touch ID for sudo
}
