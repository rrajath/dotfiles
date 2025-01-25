{ pkgs, home-manager, user, ... }: {
  networking.hostName = "work-macbook";
  users.users."${user}" = {
    name = "${user}";
    home = "/Users/${user}";
  };

  environment.systemPackages = with pkgs; [
    alacritty
  ];

  home-manager = {
    users.${user} = {
      programs.alacritty = {
        enable = true;
        settings = {
          window.opacity = 0.5;
        };
      };
    };
  };

  programs.fish.enable = true;
}
