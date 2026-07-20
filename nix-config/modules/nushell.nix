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
          "/Users/rrajath/bin/venv/bin"
          "/Users/rrajath/go/bin"
          "/Users/rrajath/.cargo/bin"
    ])
    $env.JAVA_HOME = "/opt/homebrew/Cellar/openjdk@21/21.0.10/"
    $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
    '';
    extraConfig = ''
      # Additional configuration that runs after the main config
      alias ll = ls -l

      alias drp = sudo darwin-rebuild switch --flake ~/dotfiles/nix-config#default
    '';
  };
}
