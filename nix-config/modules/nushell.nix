{ config, user, ... }: {
  programs.nushell = {
    enable = true;
    configFile.text = ''
    $env.config = {
      show_banner: false
      buffer_editor: "hx"
      rm: {
        always_trash: true
      }
      completions: {
        algorithm: "fuzzy"
      }
    }
    '';
    # Environment configuration
    envFile.text = ''
    $env.EDITOR = "hx"
    $env.PATH = ($env.PATH | split row (char esep) | 
	    prepend [
	      "/etc/profiles/per-user/rrajath/bin"
          "/nix/var/nix/profiles/default/bin"
          "/Users/rrajath/.nix-profile/bin"
          "/usr/local/bin"
          "~/Library/Python/3.9/bin"
          "/opt/homebrew/bin"
          "/Users/rrajath/.local/bin"
          "/Users/rrajath/.local"
    ])
    $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
    '';
    extraConfig = ''
      # Additional configuration that runs after the main config
      alias ll = ls -l
      
      alias drp = if (hostname | str contains "asdf") { 
        echo "❌ Cannot run personal config on work machine!" 
        } else { 
        sudo darwin-rebuild switch --flake ~/dotfiles/nix-config#personal 
      }

      alias drw = if (hostname | str contains "Rajaths-MacBook-Pro.local") { 
        echo "❌ Cannot run work config on personal machine!" 
      } else { 
        sudo darwin-rebuild switch --flake ~/dotfiles/nix-config#work 
      }
    '';
  };
}
