{ config, ... }:

{
  home.file.".claude/CLAUDE.md".source = ../../claude-code/CLAUDE.md;
  home.file.".claude/.claudeignore".source = ../../claude-code/.claudeignore;
  home.file.".claude/agents".source = ../../claude-code/agents;
  # xdg.configFile.".claude/CLAUDE.md".source =
    # config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/claude-code/CLAUDE.md";
  # xdg.configFile.".claude/.claudeignore".source =
    # config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/claude-code/.claudeignore";
  # xdg.configFile.".claude/agents".source =
    # config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/claude-code/agents";
}
