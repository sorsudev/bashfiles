# RVM install

export PATH=/usr/local/bin:$PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# RVM install

# History navigation

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[5D":backward-word'
bind '"\e[5C":forward-word'

# History navigation

# Activate colors

source $HOME/bash_profile/.git-prompt.sh

export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\[\033[33;35m\]\n\$(__git_ps1)\$(parse_git_dirty)\[\033[m\] "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'

# Activate colors

# git autocomple functions

source $HOME/bash_profile/.git-completition.bash

# git autocomple functions

# git alias

source $HOME/bash_profile/.git-alias.sh

# git alias


function parse_git_dirty {
  git diff --quiet HEAD &>/dev/null
  if [ $? != 1 ]
  then
    echo "$"
  else
    echo "⚡ "
  fi
}
