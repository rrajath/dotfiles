{ pkgs, home-manager, ... }:

let user = "rajath.ramakrishna"; in {
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
