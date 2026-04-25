{ user, ...}:

{
  home-manager.users.${user} = {
    home.file = {
      ".config/karabiner".source = ../../karabiner;
      ".config/amethyst/amethyst.yml".source = ../../amethyst/amethyst.yml;
    };
  };
}
