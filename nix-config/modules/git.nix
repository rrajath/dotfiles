{ ... }: {
  programs.git = {
    enable = true;
    ignores = [
      "*.swp"
      ".vscode"
      ".direnv"
      ".envrc"
      ".zed"
      ".settings"
    ];
    userName = "Rajath Ramakrishna";
    lfs = {
      enable = true;
    };
    extraConfig = {
      core.editor = "hx";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };
}
