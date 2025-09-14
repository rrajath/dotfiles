{ pkgs, ... }: {
  imports = [
    ../shared/home.nix
    ../modules/git.nix
    # Work-specific modules only
  ];
  
  # Work-specific packages
  home.packages = with pkgs; [
    # Work packages
  ] ++ (pkgs.callPackage ../modules/packages.nix { });
  
  # Work-specific program configurations
  programs.git = {
    userEmail = "work@company.com";
    # other work git settings
    # Include dotfiles-specific config when in dotfiles directory
    includeIf."gitdir:~/dotfiles/" = {
      path = "~/.config/git/dotfiles-config";
    };
  };

  # Create the dotfiles-specific git config file
  home.file.".config/git/dotfiles-config".text = ''
    [user]
      name = Rajath Ramakrishna
      email = r.rajath@protonmail.com
    [github]
      user = rrajath
  '';
}
