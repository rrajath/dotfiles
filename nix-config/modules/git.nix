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
    lfs = {
      enable = true;
    };
    settings = {
      user.name = "Rajath Ramakrishna";
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
