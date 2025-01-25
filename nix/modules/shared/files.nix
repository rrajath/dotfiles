{ pkgs, config, ... }:

{
  ".emacs.d/early-init.el" = {
    text = builtins.readFile ../shared/config/emacs/early-init.el;
  };

  ".emacs.d/pre-init.el" = {
    text = builtins.readFile ../shared/config/emacs/pre-init.el;
  };
  # Initializes Emacs with org-mode so we can tangle the main config
  ".emacs.d/init.el" = {
    text = builtins.readFile ../shared/config/emacs/init.el;
  };
  ".emacs.d/post-init.el" = {
    text = builtins.readFile ../shared/config/emacs/post-init.el;
  };
}
