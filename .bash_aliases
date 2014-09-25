# update
alias update-aliases='curl -sL https://raw.githubusercontent.com/mmrose/dotfiles/master/.bash_aliases > ~/.bash_aliases && source ~/.bash_aliases'
alias update-tmux='curl -sL https://raw.githubusercontent.com/mmrose/dotfiles/master/.tmux.conf > ~/.tmux.conf && if [ -n "$TMUX" ]; then tmux source-file ~/.tmux.conf; fi'

# navigation
alias c='clear'
alias r='reset'
alias ls='ls -lah --color'

# system
alias psg='ps aux | grep -v grep | grep -i'
alias ns='netstat -taupn | grep LISTEN'
alias nsg='netstat -taupn | grep -i'

# python
alias p='python'
alias pm='python manage.py'
alias pmr='python manage.py runserver'
alias pms='python manage.py shell'
alias pi='pip install'
alias pf='pip freeze'
alias pfg='pip freeze | grep -i'

# vagrant
alias v='vagrant'
alias vs='vagrant ssh'
alias vus='vagrant up && vagrant ssh -c "curl -sL https://raw.githubusercontent.com/mmrose/dotfiles/master/.bash_aliases > ~/.bash_aliases" && vagrant ssh'
alias vrs='vagrant reload && vagrant ssh -c "curl -sL https://raw.githubusercontent.com/mmrose/dotfiles/master/.bash_aliases > ~/.bash_aliases" && vagrant ssh'

# others
ssht () {
  ssh -t "$1" 'tmux -2 attach || tmux -2 new';
}
alias tmux='tmux -2'

# work
alias np='/cygdrive/c/"Program Files (x86)"/Notepad++/notepad++.exe'
