{ config, user, pkgs, ... }: {
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
	      "/etc/profiles/per-user/${user}/bin"
          "/nix/var/nix/profiles/default/bin"
          "${config.home.homeDirectory}/.nix-profile/bin"
          "/usr/local/bin"
          "/opt/homebrew/bin"
          "${config.home.homeDirectory}/.local/bin"
          "${config.home.homeDirectory}/go/bin"
          "${config.home.homeDirectory}/.cargo/bin"
    ])
    $env.JAVA_HOME = "${pkgs.jdk21.home}"
    $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
    '';
    extraConfig = ''
      # Additional configuration that runs after the main config
      alias ll = ls -l

      alias drp = sudo darwin-rebuild switch --flake ~/dotfiles/nix-config#default
    '';
  };
}
