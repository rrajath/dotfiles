{ config, ... }:

{
  # Claude Code reads from ~/.claude, which is $HOME, not $XDG_CONFIG_HOME —
  # these must be home.file, not xdg.configFile (xdg.configFile targets
  # ~/.config/.claude, which Claude Code never reads, and home-manager would
  # tear down the old ~/.claude/* links without anything replacing them).
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/claude-code/CLAUDE.md";
  home.file.".claude/.claudeignore".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/claude-code/.claudeignore";
  home.file.".claude/agents".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/claude-code/agents";
}
