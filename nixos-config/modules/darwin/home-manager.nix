{ config, pkgs, lib, home-manager, user, unstable, ... }:

let
  # Define the content of your file as a derivation
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/sh
    emacsclient -c -n &
  '';
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  #  imports = [
  #   ./dock
  #  ];

  imports = [
    ./modules
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };
    # onActivation.cleanup = "uninstall";

    brews = [
      "bitwarden-cli"
    ];

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)
    #    masApps = {
    #      "1password" = 1333542190;
    #      "wireguard" = 1451685025;
    #    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit unstable; };
    users.${user} = { pkgs, config, lib, ... }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix { };
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
          { "emacs-launcher.command".source = myEmacsLauncher; }
        ];
        stateVersion = "23.11";
      };
      programs = {
        fzf = {
          enable = true;
        };

        nushell = {
          enable = true;
          configFile.text = ''
            $env.config = {
              show_banner: false
              buffer_editor: "hx"
            }
      	    $env.PATH = ($env.PATH | split row (char esep) | 
	            prepend [
      	     	  "/nix/var/nix/profiles/default/bin"
      		      "/Users/${user}/.nix-profile/bin"
                  "/usr/local/bin"
                  "~/Library/Python/3.9/bin"
                  "/opt/homebrew/bin"
                  "/Users/${user}/.local/bin"
                  "/Users/${user}/.local"
      		  ])
            $env.ORG_MODE_DIR = "~/SynologyDrive/org-mode"
            $env.ORG_ROAM_DIR = "~/org-roam"
          '';
          extraConfig = ''
            # Additional configuration that runs after the main config
            $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
            alias ll = ls -l
            
            def nb [] {
              cd ~/dotfiles/nixos-config
              nix run .#build-personal
              cd -
            }
            
            def nbs [] {
              cd ~/dotfiles/nixos-config
              nix run .#build-personal-switch
              cd -
            }
          '';
        };

        carapace = {
          enable = true;
          enableNushellIntegration = true;
	      };
        
      	zoxide = {
          enable = true;
          enableNushellIntegration = true;
	      };

        atuin = {
          enable = true;
          enableNushellIntegration = true;
        };

        starship = {
          enable = true;
          settings = {
            add_newline = true;
            character = {
              success_symbol = "[➜](bold green)";
              error_symbol = "[➜](bold red)";
            };
          };
        };

        direnv = {
          enable = true;
          enableNushellIntegration = true; # see note on other shells below
          nix-direnv.enable = true;
        };
        
        jujutsu = {
          enable = true;
          settings = {
            user = {
              name = "${user}";
              email = "r.rajath@protonmail.com";
            };
            ui = {
              editor = "hx";
              default-command = "log";
            };
          };
        };
        
        helix = {
          enable = true;
          settings = {
            theme = "base16_transparent";

            editor = {
              mouse = false;
              color-modes = true;
              cursorline = false;
              idle-timeout = 40;
              auto-save = true;
              bufferline = "multiple";

              cursor-shape = {
                insert = "bar";
                normal = "block";
                select = "underline";
              };

              file-picker = {
                hidden = false;
              };

              statusline = {
                left = [ "mode" "spinner" "file-name" "file-type" "total-line-numbers" "file-encoding" ];
                center = [ "selections" "primary-selection-length" "position" "position-percentage" ];
                right = [ "diagnostics" "workspace-diagnostics" ];
              };

              lsp = {
                display-messages = true;
              };

              indent-guides = {
                render = true;
              };
            };

            keys = {
              normal = {
                C-s = ":w";
                C-r = ":reload";
                C-S-up = "expand_selection";
                C-S-down = "shrink_selection";
                C-n = "move_line_down";
                C-p = "move_line_up";
                C-j = ":buffer-previous";
                C-k = ":buffer-next";
                C-e = [ "goto_line_end" "move_char_right" ];
                C-a = "goto_line_start";
                D = [ "extend_line_below" "delete_selection" ];
                C-c = [ "toggle_comments" "move_line_down" ];
                esc = [ "collapse_selection" "keep_primary_selection" ];

                space = {
                  w = ":write";
                  q = ":quit";
                  c = ":buffer-close";
                  C = ":buffer-close-others";
                };
              };
              insert = {
                C-s = ":w";
                C-f = "move_char_right";
                C-b = "move_char_left";
                C-c = [ "toggle_comments" "move_line_down" ];
                C-e = [ "goto_line_end" "move_char_right" ];
                C-a = "goto_line_start";
                C-n = "move_line_down";
                C-p = "move_line_up";
              };
            };
          };
        };
      } // import ../shared/home-manager.nix { inherit config pkgs lib user; };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  #  local.dock.enable = true;
  #  local.dock.entries = [
  #    { path = "/Applications/Slack.app/"; }
  #    { path = "/System/Applications/Messages.app/"; }
  #    { path = "/System/Applications/Facetime.app/"; }
  #    { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
  #    { path = "/System/Applications/Music.app/"; }
  #    { path = "/System/Applications/News.app/"; }
  #    { path = "/System/Applications/Photos.app/"; }
  #    { path = "/System/Applications/Photo Booth.app/"; }
  #    { path = "/System/Applications/TV.app/"; }
  #    { path = "/System/Applications/Home.app/"; }
  #    {
  #      path = toString myEmacsLauncher;
  #      section = "others";
  #    }
  #    {
  #      path = "${config.users.users.${user}.home}/.local/share/";
  #      section = "others";
  #      options = "--sort name --view grid --display folder";
  #    }
  #    {
  #      path = "${config.users.users.${user}.home}/.local/share/downloads";
  #      section = "others";
  #      options = "--sort name --view grid --display stack";
  #    }
  #  ];

}
