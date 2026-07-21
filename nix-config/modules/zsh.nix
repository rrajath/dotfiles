# Antidote itself is installed manually (not nix-managed):
#   git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote
# ~/.zsh_plugins.txt (loaded below) is currently empty -- no plugins declared.
#
# zoxide/direnv/atuin integration is injected automatically by their own
# home-manager modules (already imported in home.nix) once programs.zsh.enable
# is true -- no manual init lines needed here.
#
# Stale work-machine env vars (VAULT_ADDR, POPPY_DIRECT_CONNECT, HTTPS_PROXY)
# were dropped rather than ported. EDITOR is already set globally via
# home.sessionVariables in home.nix.
{ config, lib, ... }: {
  programs.zsh = {
    enable = true;

    history = {
      size = 10000;
      save = 10000;
      saveNoDups = true;
      path = "${config.home.homeDirectory}/.zhistory";
    };

    setOptions = [
      "AUTO_PUSHD"
      "PUSHD_IGNORE_DUPS"
      "PUSHD_SILENT"
    ];

    sessionVariables = {
      VISUAL = "vi";
      ANDROID_HOME = "$HOME/Library/Android/sdk";
      NVM_DIR = "$HOME/.nvm";
      COMPLETION_WAITING_DOTS = "true";
      DISABLE_UNTRACKED_FILES_DIRTY = "true";
    };

    siteFunctions = {
      mkcd = ''
        mkdir --parents "$1" && cd "$1"
      '';
    };

    shellAliases = {
      ".." = "cd ..";
      l = "ls -lrt";
      lh = "ls -lh";
      ez = "hx ~/.zshrc";
      sz = "source ~/.zshrc";
      saf = "defaults write com.apple.finder AppleShowAllFiles -bool YES";
      haf = "defaults write com.apple.finder AppleShowAllFiles -bool NO";
      e = "emacs --init-directory=~/dotfiles/.emacs.d --debug-init";
      fzfp = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'";
      resem = ''emacsclient -e "(kill-emacs)" && doom sync && /usr/local/bin/emacs --daemon && emacsclient -nc'';
      brs = "br -s";
      sshr = "ssh rrajath@infiniteloop.local";

      gco = "git checkout";
      gst = "git status";
      gss = "git status -s";
      gcp = "git cherry-pick";
      grbc = "git rebase --continue";
      grba = "git rebase --abort";
      grbi = "git rebase -i";
      gup = "git pull --rebase";
      ga = "git add";
      gb = "git branch";
      gsta = "git stash";
      gstp = "git stash pop";
      gp = "git push";

      ls = "exa -l --color=always --group-directories-first";
      la = "exa -a --color=always --group-directories-first";
      ll = "exa -l --color=always --group-directories-first";
      lt = "exa -aT --color=always --group-directories-first";
      "l." = ''exa -a | egrep "^\."'';

      yt = "yarn test";
      ytw = "yarn test:watch";
      yb = "yarn betterer";
      ylf = "yarn lint:fix";
      yp = "yarn prep";
    };

    initContent = lib.mkOrder 1000 ''
      # NVM (Intel Homebrew path from the original config; harmless no-op on
      # Apple Silicon since the guard just fails).
      [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"
      [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

      # Rpi-specific
      if [[ "$(hostname)" == "infiniteloop" ]]; then
        alias bat="batcat"
      fi

      # Antidote plugin manager
      source ''${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
      antidote load ''${ZDOTDIR:-$HOME}/.zsh_plugins.txt
    '';
  };
}
