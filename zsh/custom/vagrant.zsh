alias v='vagrant'
alias vd='vagrant destroy'
alias vdf='vagrant destroy -f'
alias vs='vagrant ssh'
alias vu='vagrant up'
alias vus='vagrant up && vagrant ssh'
alias vr='vagrant reload'
alias vrs='vagrant reload && vagrant ssh'
alias vh='vagrant halt'
vdi() {
    vagrant up $1
    vagrant ssh -c "curl -L https://raw.githubusercontent.com/mmrose/dotfiles/master/install.sh | sh"  $1
    if [[ ! -e /bin/zsh ]]; then
        if [[ -e /usr/bin/yum ]]; then
            vagrant ssh -c "sudo yum -y install zsh"
        elif [[ -e /usr/bin/aptitude ]]; then
            vagrant ssh -c "sudo aptitude -y install zsh"
        else
            exit 1
        fi
    fi
    vagrant ssh -c "sudo chsh -s /bin/zsh vagrant" $1
}

vdu() {
    vagrant up $1
    vagrant ssh -c "update-dotfiles" $1
}