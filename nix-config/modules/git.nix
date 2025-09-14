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
      rebase = {
        autoStash = true;
        updateRefs = true;
      };

      # rerere remembers how you fixed merge conflicts so that next time it encounters
      # the same merge conflicts, it fixes it for you
      rerere.enabled = true;
    };
  };
}
