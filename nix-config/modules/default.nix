{ user, ...}:

{
  home-manager.users.${user} = {
    home.file = {
      ".config/karabiner".source = ../../karabiner;
    };
  };
}
