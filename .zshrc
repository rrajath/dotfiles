# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="sorin"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git gitignore python web-search tmux colorize jump colored-man)

# Customize to your needs...
PATH=/usr/bin:/bin:/usr/sbin:/sbin
PATH=/usr/local/bin:/usr/local/sbin:"$PATH"
PATH=/usr/local/share/python/:"$PATH"
PATH=~/android/android-sdk-macosx/platform-tools/:~/bin/gradle-2.3/bin:"$PATH"
export PATH

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Setting vi mode in shell
bindkey -v

bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search
bindkey '^R' history-incremental-search-backward

# tmux

function gi() { curl http://gitignore.io/api/$@ ;}

export JAVA_HOME=$(/usr/libexec/java_home)

# source ~/.bin/tmuxinator.zsh

# If we have a glob this will expand it
setopt GLOB_COMPLETE
setopt PUSHD_MINUS

# Make cd=pushd
export EDITOR="vi"

# No more annoying pushd messages
setopt PUSHD_SILENT

# allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

# This will use named dirs when possible
setopt AUTO_NAME_DIRS

source $ZSH/oh-my-zsh.sh

# Add aliases
[[ -f $HOME/.zsh_aliases ]] && source $HOME/.zsh_aliases
