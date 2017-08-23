directory=.bash_files
export PATH=/usr/local/bin:$HOME/$directory/bin/:$PATH

# History navigation

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[5D":backward-word'
bind '"\e[5C":forward-word'

# History navigation

# Activate colors

source $HOME/$directory/.git-prompt.sh

export PS1="\[$(tput bold)\]\[\033[38;5;33m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;99m\]\t\[$(tput sgr0)\]\[\033[38;5;127m\]--->\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;14m\]\w\[$(tput sgr0)\]\[\033[38;5;91m\]\n\$(__git_ps1)\$(parse_git_dirty)\[\033[m\] "

# git autocomple functions

source $HOME/$directory/.git-completition.bash


# git alias

source $HOME/$directory/.git-alias.sh

# node config

source $HOME/$directory/.npmrc

function parse_git_dirty {
  git diff --quiet HEAD &>/dev/null
  if [ $? != 1 ]
  then
    echo "$"
  else
    echo "⚡"
  fi
}

force_color_prompt=yes

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

