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
      template-aliases = {
        "format_short_id(id)" = "id.shortest()";
        "format_timestamp(timestamp)" = "timestamp.ago()";
        "format_short_signature(signature)" = "signature.email().local()";
      };
    };
  };
}
