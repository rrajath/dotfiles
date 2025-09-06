{ ... }: {
  programs.starship = {
    enable = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      custom.jjstate = {
        detect_folders = [".jj"];
        command = ''
          jj log -r@ -n1 --no-graph -T "" --stat | tail -n1 | sd "(\d+) files? changed, (\d+) insertions?\(\+\), (\d+) deletions?\(-\)" ' $${1}m $${2}+ $${3}-' | sd " 0." ""
        '';
      };

      custom.jj = {
        command = ''
          jj log --ignore-working-copy --no-graph --color always --revisions @ --template '
            surround(
              "(",
              ")",
              separate(
                " ",
                change_id.shortest(),
                commit_id.shortest(),
                if(empty, label("empty", "(empty)")),
                if(description,
                  concat("\"", description.first_line(), "\""),
                  label(if(empty, "empty"), description_placeholder),
                ),
                bookmarks.join(", "),
                branches.join(", "),
                if(conflict, "💥"),
                if(divergent, "🚧"),
                if(hidden, "👻"),
                if(immutable, "🔒"),
              ))'
        '';
        when = "jj root --ignore-working-copy";
        symbol = "🥋 ";
      };
    };
  };
}
