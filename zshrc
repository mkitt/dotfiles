typeset -U path
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="vim"
setopt AUTO_CD
setopt HIST_IGNORE_SPACE

fpath=(~/.local/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit

autoload -Uz vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ' *'
zstyle ':vcs_info:git:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats '[%b%u%c] '
precmd() { vcs_info }
setopt PROMPT_SUBST
PROMPT='%F{5}[%n]%f %F{4}%1~%f %F{6}${vcs_info_msg_0_}%f%F{8}%#%f '
