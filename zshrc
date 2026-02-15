# @see https://scriptingosx.com/2019/06/moving-to-zsh/

# Load Homebrew path
eval $(/opt/homebrew/bin/brew shellenv)

# Load ASDF
. $(brew --prefix asdf)/libexec/asdf.sh

export EDITOR="nvim"

# Add color to man pages
export LESS_TERMCAP_md="$(tput setaf 4)"

# http://zsh.sourceforge.net/Doc/Release/Options.html
setopt APPEND_HISTORY
setopt AUTO_CD
setopt GLOB_COMPLETE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt NO_CASE_GLOB
setopt SHARE_HISTORY
# TODO: Need to find equivalent of Readline's `set history-preserve-point`

# @see http://zsh.sourceforge.net/Doc/Release/Parameters.html
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=500
SAVEHIST=500

# @see http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
bindkey '^P' history-incremental-pattern-search-backward
bindkey '^N' history-incremental-pattern-search-forward

# @see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
# @see https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
if [ -f $(brew --prefix)/etc/bash_completion.d/git-prompt.sh ]; then
  . $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
  setopt PROMPT_SUBST
  GIT_PS1_SHOWDIRTYSTATE="true"
  PROMPT='%F{5}[%m]%f %F{4}%1~%f %F{6}$(__git_ps1 "[%s] ")%f%F{8}%#%f '
else
  PROMPT='%F{5}[%m]%f %F{4}%1~%f %F{8}%#%f '
fi

# Handy stuff
alias ...="cd ../../"
alias ....="cd ../../../"
alias cp="cp -i"
alias la="ls -lA"
alias ll="ls -l"
alias ls="ls -G"
alias mv="mv -i"
alias reload="source ~/.zprofile && cd ../ && cd -"
alias be="bundle exec"

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
                                    'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' \
                                    'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' \
                                    'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# Load zsh completion engine
autoload -Uz compinit && compinit
true

# Load local overrides (not tracked in git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
