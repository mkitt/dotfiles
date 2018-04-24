unset MAILCHECK
export PATH="/usr/local/bin:/usr/local/heroku/bin:$PATH"
export LC_ALL=C
export ARCHFLAGS="-arch x86_64"
export EDITOR="vim"
export HISTCONTROL="ignoreboth"
export HISTSIZE="500"

# Add color to man pages
export LESS_TERMCAP_md="$(tput setaf 4)"

# ------------------------------------------
# Color          | Escaped    | ANSI
# -------------- | ---------- | ------------
# No Color       | \033[0m    | x (default foreground)
# Black          | \033[0;30m | a
# Grey           | \033[1;30m | A
# Red            | \033[0;31m | b
# Bright Red     | \033[1;31m | B
# Green          | \033[0;32m | c
# Bright Green   | \033[1;32m | C
# Brown          | \033[0;33m | d
# Yellow         | \033[1;33m | D
# Blue           | \033[0;34m | e
# Bright Blue    | \033[1;34m | E
# Magenta        | \033[0;35m | f
# Bright Magenta | \033[1;35m | F
# Cyan           | \033[0;36m | g
# Bright Cyan    | \033[1;36m | G
# Bright Grey    | \033[0;37m | h
# White          | \033[1;37m | H

# XX (fgbg):
# 01. directory
# 02. symbolic link
# 03. socket
# 04. pipe
# 05. executable
# 06. block special
# 07. character special
# 08. executable with setuid bit set
# 09. executable with setgid bit set
# 10. directory writable to others, with sticky bit
# 11. directory writable to others, without sticky bit
#      LSCOLORS=0102030405060708091011
export LSCOLORS="excxgxfxbxdxbxbxbxexex"
export CLICOLOR="1"
export PS1="\[\033[35m\][\h] \[\033[33m\]\W \[\033[0m\]"
export PS2="\[\033[35m\]→ \[\033[0m\]"

# Source homebrew bash_completions and set custom prompt
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
 export GIT_PS1_SHOWDIRTYSTATE="true"
 export PS1="\[\033[35m\][\h] \[\033[34m\]\W\[\033[31m\]\$(__git_ps1 \" [%s]\") \[\033[0m\]"
fi

# http://ss64.com/bash/shopt.html
shopt -s histappend
shopt -s nocaseglob
shopt -s cdspell

# Map git commands through hub
eval "$(hub alias -s)"

# Handy stuff
alias ..="cd ../"
alias ...="cd ../../"
alias cp="cp -i"
alias la="ls -lA"
alias ll="ls -l"
alias ls="ls -G"
alias mv="mv -i"
alias reload="source ~/.bash_profile && cd ../ && cd -"
