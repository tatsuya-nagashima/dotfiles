# General
export LANG=ja_JP.UTF-8
export LC_TIME=C
export EDITOR=vim

bindkey -e 
set bell-style none; setopt nobeep; setopt nolistbeep  # No beep
setopt print_eight_bit        # Enable Japanese file name

# History
export HISTFILE=${HOME}/.zsh-history
export HISTSIZE=1000         # Number of saved history on memory
export SAVEHIST=2000         # Number of saved history

setopt hist_ignore_dups       # Ignore duplicated history
setopt hist_ignore_space      # Ignore command starts with white spaces
setopt hist_no_store          # Ignore history command
setopt hist_reduce_blanks     # Strip white spaces
setopt share_history          # Share history across multi processes
setopt extended_history       # Save timestamp

# Alias
alias c='clear'
alias t='tmux'
alias vi='vim'
alias le='less'
alias ga='git add'
alias gb='git branch'
alias gl='git log'
alias gch='git checkout'
alias gst='git status'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gpull='git pull'
alias gpush='git push'

#ls
if [ $(uname) = 'Darwin' ]; then
  export LSCOLORS=gxfxcxdxbxegedabagacad
  alias ls='ls -G'
  alias la='ls -a'
  alias ll='ls -alh'
else
  if [ -e ~/.colorrc ]; then
    eval `dircolors ~/.colorrc`
  fi
  alias ls='ls --color=auto'
  alias la='ls -a'
  alias ll='ls -alh'
fi

# peco
if which peco &> /dev/null; then
  function peco-select-history {
    BUFFER=`history -n -r 1 | peco --query "$LBUFFER"`
    CURSOR=$#BUFFER
    zle reset-prompt
  }
  zle -N peco-select-history
  bindkey '^r' peco-select-history
fi

# diff
if which colordiff &> /dev/null; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

# less
export LESS='-iMR'

# zsh-syntax-highlighting
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_STYLES[alias]=fg=green
    ZSH_HIGHLIGHT_STYLES[command]=fg=green
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=green
    ZSH_HIGHLIGHT_STYLES[builtin]=fg=green
    ZSH_HIGHLIGHT_STYLES[function]=fg=green
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
	  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
	  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
fi

# enable auto-suggestions based on the history
if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# Completion
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

setopt auto_menu              # Toggle complement candidates using TAB
setopt auto_param_slash       # Insert / after a complemented directory name
setopt correct                # Do spell check
setopt list_packed            # Use compackt style candidates viewer mode
setopt list_types             # Show kinds of file using marks
setopt magic_equal_subst      # Even option args are complemented
setopt complete_aliases       # Expand aliases before completing

# Git status
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' formats "%{${fg[green]}%}[%b]"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }

# Prompt color
autoload -U colors; colors

PROMPT="${REMOTE_PROMPT}%{${fg[green]}%}%n: %{${fg[green]}%}%c %{${fg[green]}%}%# "
PROMPT2="%{${fg[green]}%} %_ > %{${reset_color}%}"
RPROMPT='${vcs_info_msg_0_}'
SPROMPT="%{${fg[red]}%}correct: %R -> %r ? [n,y,a,e] %{${reset_color}%}"

if [ ${SSH_CLIENT:-undefined} = "undefined" ] && [ ${SSH_CONECTION:-undefined} = "undefined" ]; then
    REMOTE_PROMPT=""
  else
    REMOTE_PROMPT="%F{red}[REMOTE]%f "
fi

# direnv
if type "direnv" > /dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# asdf
if [ -e /usr/local/opt/asdf/asdf.sh ]; then
  # Do not use `. $(brew --prefix asdf)/asdf.sh` due to performance issues.
  . /usr/local/opt/asdf/asdf.sh
fi

