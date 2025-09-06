{user, pkgs, ...}: {
  # Install Jujutsu package
  home.packages = with pkgs; [
    jujutsu
  ];

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "rrajath";
        email = "r.rajath@protonmail.com";
      };
      ui = {
        editor = "hx";
        default-command = "log";
      };
      git = {
        private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
      };
      template-aliases = {
        "format_short_id(id)" = "id.shortest()";
        "format_timestamp(timestamp)" = "timestamp.ago()";
        "format_short_signature(signature)" = "signature.email().local()";
      };
    };
  };
}
