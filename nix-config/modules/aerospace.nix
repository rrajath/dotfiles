{ ... }: {
  services.aerospace = {
    enable = true;

    settings = {
      # start-at-login is forced off (nix-darwin asserts on this): the
      # launchd agent this module installs already has RunAtLoad = true,
      # so AeroSpace starts at login either way.
      start-at-login = false;
      after-login-command = [ ];
      after-startup-command = [ ];

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";

      key-mapping.preset = "qwerty";

      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      on-focus-changed = [ "move-mouse window-lazy-center" ];

      gaps = {
        inner.horizontal = 5;
        inner.vertical = 5;
        outer.left = 5;
        outer.bottom = 5;
        outer.top = 5;
        outer.right = 5;
      };

      mode.main.binding = {
        cmd-alt-slash = "layout tiles horizontal vertical";
        cmd-alt-comma = "layout accordion horizontal vertical";

        ctrl-alt-left = "focus left";
        ctrl-alt-down = "focus down";
        ctrl-alt-up = "focus up";
        ctrl-alt-right = "focus right";

        ctrl-alt-shift-left = "move left";
        ctrl-alt-shift-down = "move down";
        ctrl-alt-shift-up = "move up";
        ctrl-alt-shift-right = "move right";

        alt-shift-minus = "resize smart -50";
        alt-shift-equal = "resize smart +50";

        alt-1 = "workspace 1"; # Slack and Postman
        alt-2 = "workspace 2"; # Emacs and Logseq
        alt-3 = "workspace 3"; # Zed, Arc and Warp
        alt-4 = "workspace 4"; # Docker
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9"; # Temp space

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";

        alt-shift-f = "fullscreen";

        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        alt-shift-semicolon = "mode service";
      };

      mode.service.binding = {
        esc = [ "reload-config" "mode main" ];
        r = [ "flatten-workspace-tree" "mode main" ];
        f = [ "layout floating tiling" "mode main" ];
        backspace = [ "close-all-windows-but-current" "mode main" ];

        alt-shift-left = [ "join-with left" "mode main" ];
        alt-shift-down = [ "join-with down" "mode main" ];
        alt-shift-up = [ "join-with up" "mode main" ];
        alt-shift-right = [ "join-with right" "mode main" ];
      };

      on-window-detected = [
        { "if".app-id = "com.tinyspeck.slackmacgap"; run = "move-node-to-workspace 1"; }
        { "if".app-id = "com.postmanlabs.mac"; run = "move-node-to-workspace 1"; }
        { "if".app-id = "org.gnu.Emacs"; run = "move-node-to-workspace 3"; }
        { "if".app-id = "app.zen-browser.zen"; run = "move-node-to-workspace 2"; }
        { "if".app-id = "com.electron.logseq"; run = "move-node-to-workspace 2"; }
        { "if".app-id = "dev.zed.Zed"; run = "move-node-to-workspace 3"; }
        { "if".app-id = "company.thebrowser.Browser"; run = "move-node-to-workspace 3"; }
        { "if".app-id = "dev.warp.Warp-Stable"; run = "move-node-to-workspace 3"; }
        { "if".app-id = "com.electron.dockerdesktop"; run = "move-node-to-workspace 4"; }
        { "if".app-id = "com.cisco.anyconnect.gui"; run = [ "layout floating" "move-node-to-workspace 8" ]; }
        { "if".app-id = "org.whispersystems.signal-desktop"; run = "move-node-to-workspace 8"; }
        { "if".app-id = "ai.perplexity.mac"; run = "move-node-to-workspace 8"; }
        { "if".app-id = "com.mitchellh.ghostty"; run = [ "layout floating" "move-node-to-workspace 8" ]; }
      ];

      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "main";
        "4" = "main";
        "5" = "main";
        "6" = "main";
        "7" = "main";
        "8" = "secondary";
        "9" = "main";
      };
    };
  };
}
