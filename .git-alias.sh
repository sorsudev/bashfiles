alias gst='git status'
alias gco='git checkout'
alias gci='git commit'
alias grb='git rebase'
alias gbr='git branch -a'
alias gpl='git pull'
alias gad='git add'
alias gpu='git push'
alias gmt='git mergetool'
alias bdf='git diff'
alias glg='git log --date-order --all --graph --name-status --format="%C(green)%h%Creset %C(yellow)%an%Creset %C(blue bold)%ar%Creset %C(red bold)%d%Creset%s"'
alias gg='git grep'

__git_complete gco _git_checkout
