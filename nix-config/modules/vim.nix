# amix/vimrc (previously a manual `git clone` prerequisite, sourced from
# ~/.vimrc via ~/.vim_runtime) is no longer needed: programs.vim bakes this
# config directly into the wrapped `vim` package, so there's nothing left to
# source it. Likewise vim-plug/pathogen are superseded by programs.vim.plugins.
#
# The "Set theme" section (Plug 'davidosomething/vim-colors-meh', `colorscheme
# peaksea`, lightline colorscheme 'ThemerVimLightline') referenced plugins
# that aren't in nixpkgs' vimPlugins and were dropped rather than faked with
# an unrequested substitute.
{ config, ... }: {
  programs.vim = {
    enable = true;

    settings = {
      number = true;
      background = "dark";
      undofile = true;
      undodir = [ "${config.home.homeDirectory}/.vim/undodir" ];
    };

    extraConfig = ''
      set cursorline
      set ruler
      set t_Co=256

      " Use leader key while saving/quitting a file in vim
      nmap <leader>wq :wq<cr>
      nmap <leader>q :q!<cr>

      " Set cursor shape
      let &t_SI = "\<Esc>]50;CursorShape=1\x7"
      let &t_SR = "\<Esc>]50;CursorShape=2\x7"
      let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    '';
  };

  home.file.".vim/undodir/.keep".text = "";
}
