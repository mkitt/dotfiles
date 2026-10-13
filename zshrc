eval "$(/opt/homebrew/bin/brew shellenv)"
export EDITOR="vim"

# http://zsh.sourceforge.net/Doc/Release/Options.html
setopt AUTO_CD
setopt GLOB_COMPLETE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt NO_CASE_GLOB
setopt SHARE_HISTORY

# @see http://zsh.sourceforge.net/Doc/Release/Parameters.html
HISTSIZE=10000
SAVEHIST=10000

# @see http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
bindkey '^P' history-incremental-pattern-search-backward
bindkey '^N' history-incremental-pattern-search-forward

# @see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
# @see https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
if [ -f /opt/homebrew/etc/bash_completion.d/git-prompt.sh ]; then
  . /opt/homebrew/etc/bash_completion.d/git-prompt.sh
  setopt PROMPT_SUBST
  GIT_PS1_SHOWDIRTYSTATE="true"
  PROMPT='%F{5}[%n]%f %F{4}%1~%f %F{6}$(__git_ps1 "[%s] ")%f%F{8}%#%f '
else
  PROMPT='%F{5}[%n]%f %F{4}%1~%f %F{8}%#%f '
fi

# Handy stuff
alias ...="cd ../../"
alias ....="cd ../../../"
alias cp="cp -i"
alias la="ls -lA"
alias ll="ls -l"
alias ls="ls -G"
alias mv="mv -i"

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
                                    'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# Load zsh completion engine
autoload -Uz compinit && compinit

# Load local zshrc file if it exists
if [ -f "${ZDOTDIR:-$HOME}/.zshrc.local" ]; then
  source "${ZDOTDIR:-$HOME}/.zshrc.local"
fi
