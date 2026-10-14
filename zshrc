eval "$(/opt/homebrew/bin/brew shellenv)"
export EDITOR="vim"

# http://zsh.sourceforge.net/Doc/Release/Options.html
setopt AUTO_CD
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt NO_CASE_GLOB

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
alias cp="cp -i"
alias la="ls -lA"
alias ll="ls -l"
alias ls="ls -G"
alias mv="mv -i"

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
                                    'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Load zsh completion engine
autoload -Uz compinit && compinit

# Load local zshrc file if it exists
if [ -f "${ZDOTDIR:-$HOME}/.zshrc.local" ]; then
  source "${ZDOTDIR:-$HOME}/.zshrc.local"
fi
