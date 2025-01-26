{ ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "base16_transparent";

      editor = {
        mouse = false;
        color-modes = true;
        cursorline = false;
        idle-timeout = 40;
        auto-save = true;
        bufferline = "multiple";

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
        };

        statusline = {
          left = [ "mode" "spinner" "file-name" "file-type" "total-line-numbers" "file-encoding" ];
          center = [ "selections" "primary-selection-length" "position" "position-percentage" ];
          right = [ "diagnostics" "workspace-diagnostics" ];
        };

        lsp = {
          display-messages = true;
        };

        indent-guides = {
          render = true;
        };
      };

      keys = {
        normal = {
          C-s = ":w";
          C-r = ":reload";
          C-S-up = "expand_selection";
          C-S-down = "shrink_selection";
          C-n = "move_line_down";
          C-p = "move_line_up";
          C-j = ":buffer-previous";
          C-k = ":buffer-next";
          C-e = [ "goto_line_end" "move_char_right" ];
          C-a = "goto_line_start";
          D = [ "extend_line_below" "delete_selection" ];
          C-c = [ "toggle_comments" "move_line_down" ];
          esc = [ "collapse_selection" "keep_primary_selection" ];

          space = {
            w = ":write";
            q = ":quit";
            c = ":buffer-close";
            C = ":buffer-close-others";
          };
        };
        insert = {
          C-s = ":w";
          C-f = "move_char_right";
          C-b = "move_char_left";
          C-c = [ "toggle_comments" "move_line_down" ];
          C-e = [ "goto_line_end" "move_char_right" ];
          C-a = "goto_line_start";
          C-n = "move_line_down";
          C-p = "move_line_up";
        };
      };
    };
    languages = {
      language = [{
        name = "jjdescription";
        rulers = [];
      }];
    };
  };
}
