{user, ...}: {
  programs.jujutsu = {
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
}
