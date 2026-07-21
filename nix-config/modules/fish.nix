# Plugins are installed manually via Fisher (not nix-managed):
#   fisher install jorgebucaran/fisher
#   fisher install patrickf1/fzf.fish
#   fisher install gazorby/fish-abbreviation-tips
#   fisher install jethrokuan/z
#   fisher install jorgebucaran/nvm.fish
#   fisher install jorgebucaran/hydro
{ ... }: {
  # Original config explicitly disabled starship in fish (prevd/nextd
  # incompatibility) — override home-manager's auto fish integration, which
  # would otherwise enable it since programs.starship is already imported.
  programs.starship.enableFishIntegration = false;

  programs.fish = {
    enable = true;

    shellAbbrs = {
      "-" = "cd -";
      mc = "mkdir-cd";
      dotdot = {
        regex = ''^\.\.+$'';
        function = "multicd";
      };
      "!!" = {
        position = "anywhere";
        function = "last_history_item";
      };
      cz = "chezmoi";

      ls = "eza -l --color=always --group-directories-first";
      la = "eza -a --color=always --group-directories-first";
      ll = "eza -l --color=always --group-directories-first";
      lt = "eza -aT --color=always --group-directories-first";
      "l." = ''eza -a | egrep "^\."'';
      lss = "ls";

      ylf = "yarn lint:fix";
      yt = "yarn test";
      ytw = "yarn test:watch";
      yte = "yarn test:e2e:local";
      ytew = "yarn test:e2e:local:watch";
      yi = "yarn install";
      yb = "yarn betterer";

      gco = "git checkout";
      gst = "git status";
      gss = "git status -s";
      gcp = "git cherry-pick";
      gbuom = "git branch -u origin/mainline";
      grbc = "git rebase --continue";
      grba = "git rebase --abort";
      grbi = "git rebase -i";
      gpr = "git pull --rebase";
      ga = "git add";
      gb = "git branch";
      gd = "git difftool --no-symlinks --dir-diff";
      gsta = "git stash";
      gstp = "git stash pop";
    };

    functions = {
      fish_user_key_bindings = "fish_default_key_bindings";

      __history_previous_command = ''
        switch (commandline -t)
        case "!"
          commandline -t $history[1]; commandline -f repaint
        case "*"
          commandline -i !
        end
      '';

      __history_previous_command_arguments = ''
        switch (commandline -t)
        case "!"
          commandline -t ""
          commandline -f history-token-search-backward
        case "*"
          commandline -i '$'
        end
      '';

      org-search = {
        description = "send a search string to org-mode";
        body = ''
          set -l output (emacsclient -a "" -e "(message \"%s\" (mapconcat #'substring-no-properties \
              (mapcar #'org-link-display-format \
              (org-ql-query \
              :select #'org-get-heading \
              :from  (org-agenda-files) \
              :where (org-ql--query-string-to-sexp \"$argv\"))) \
              \"
          \"))")
          printf $output
        '';
      };
    };

    shellInit = ''
      set fish_greeting
      set TERM "xterm-256color"

      set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
      set EDITOR emacsclient -a /usr/local/bin/emacs

      # Colorscheme ayu Mirage
      set -U fish_color_normal CBCCC6
      set -U fish_color_command 5CCFE6
      set -U fish_color_quote BAE67E
      set -U fish_color_redirection D4BFFF
      set -U fish_color_end F29E74
      set -U fish_color_error FF3333
      set -U fish_color_param CBCCC6
      set -U fish_color_comment 5C6773
      set -U fish_color_match F28779
      set -U fish_color_selection --background=FFCC66
      set -U fish_color_search_match --background=FFCC66
      set -U fish_color_history_current --bold
      set -U fish_color_operator FFCC66
      set -U fish_color_escape 95E6CB
      set -U fish_color_cwd 73D0FF
      set -U fish_color_cwd_root red
      set -U fish_color_valid_path --underline
      set -U fish_color_autosuggestion 707A8C
      set -U fish_color_user brgreen
      set -U fish_color_host normal
      set -U fish_color_cancel --reverse
      set -U fish_pager_color_prefix normal --bold --underline
      set -U fish_pager_color_progress brwhite --background=cyan
      set -U fish_pager_color_completion normal
      set -U fish_pager_color_description B3A06D
      set -U fish_pager_color_selected_background --background=FFCC66
      set -U fish_pager_color_selected_completion
      set -U fish_pager_color_selected_description
      set -U fish_pager_color_secondary_prefix
      set -U fish_pager_color_secondary_description
      set -U fish_pager_color_secondary_completion
      set -U fish_pager_color_background
      set -U fish_color_option
      set -U fish_color_keyword
      set -U fish_color_host_remote
      set -U fish_pager_color_selected_prefix
      set -U fish_pager_color_secondary_background

      # Hydro prompt
      set hydro_color_pwd "green"
      set hydro_color_git "yellow"
      set hydro_color_error $fish_color_error
      set hydro_color_prompt --dim $fish_color_command
      set hydro_color_duration --dim $fish_color_command

      # Auto complete colors
      set fish_color_normal brcyan
      set fish_color_autosuggestion '#7d7d7d'
      set fish_color_command brcyan
      set fish_color_error '#ff6c6b'
      set fish_color_param brcyan

      # Bindings for !! and !$
      if [ "$fish_key_bindings" = "fish_vi_key_bindings" ];
         bind -Minsert ! __history_previous_command
         bind -Minsert '$' __history_previous_command_arguments
         else
             bind ! __history_previous_command
             bind '$' __history_previous_command_arguments
             end

      set -xg N_PREFIX ~

      export NVM_DIR="$HOME/.nvm"

      # zoxide/direnv/atuin integration is injected automatically by their
      # own home-manager modules (already imported in home.nix) once
      # programs.fish.enable is true — no manual init lines needed here.
    '';
  };
}
