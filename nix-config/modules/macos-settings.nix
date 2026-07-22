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

        # Trackpad tracking speed: 0 (slowest) to 3 (fastest, undocumented by Apple).
        "com.apple.trackpad.scaling" = 3.0;

        # Uncheck "Use font smoothing when available". Largely vestigial on
        # modern macOS (subpixel AA was removed system-wide around Mojave).
        AppleFontSmoothing = 0;
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

        # Gate flags for TrackpadFourFingerVertSwipeGesture below.
        showMissionControlGestureEnabled = true;
        showAppExposeGestureEnabled = true;
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

        # Swipe left/right with four fingers between Spaces/full-screen apps.
        TrackpadFourFingerHorizSwipeGesture = 2;
        # Swipe down for Mission Control, up for App Exposé (four fingers).
        TrackpadFourFingerVertSwipeGesture = 2;
      };

      # Options without a structured nix-darwin option go here as raw
      # domain/key plist writes.
      CustomUserPreferences = {
        "com.apple.dock" = {
          no-bouncing = true;
        };
      };
    };
  };

  # security.pam.services.sudo_local.touchIdAuth = true;  # Enable Touch ID for sudo
}
