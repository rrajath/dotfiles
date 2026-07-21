{ ... }: {
  programs.kitty = {
    enable = true;

    font = {
      name = "SourceCode Pro";
      size = 15.0;
    };

    themeFile = "Atom";

    settings = {
      cursor_shape = "block";

      mouse_hide_wait = -1;
      copy_on_select = true;
      strip_trailing_spaces = "smart";

      scrollback_pager_history_size = 100;

      dynamic_background_opacity = true;
      background_opacity = 1;

      inactive_text_alpha = 0.5;
      window_margin_width = 5;
      hide_window_decorations = true;
      remember_window_size = true;

      tab_bar_style = "powerline";

      macos_option_as_alt = true;
      allow_remote_control = true;
    };

    keybindings = {
      f1 = "set_background_opacity +0.1";
      f2 = "set_background_opacity -0.1";
      f3 = "set_background_opacity 0.5";
      f4 = "set_background_opacity default";

      "opt+j" = "previous_tab";
      "opt+k" = "next_tab";

      f7 = "create_marker";
      f8 = ''toggle_marker iregex 1 \\bERROR\\b 2 \\bFAILED\\b'';
      f9 = "remove_marker";

      "ctrl+p" = "scroll_to_mark prev";
      "ctrl+n" = "scroll_to_mark next";
      "ctrl+1" = "scroll_to_mark prev 1";
      "ctrl+2" = "scroll_to_mark prev 2";
    };
  };
}
