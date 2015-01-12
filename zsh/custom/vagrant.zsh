alias v='vagrant'
alias vd='vagrant destroy'
alias vdf='vagrant destroy -f'
alias vs='vagrant ssh'
alias vu='vagrant up'
alias vus='vagrant up && vagrant ssh'
alias vr='vagrant reload'
alias vh='vagrant halt'

function vus() {
    vagrant up $1
    vagrant ssh $1
}

function vrs() {
    vagrant reload $1
    vagrant ssh $1
}

function vdi() {
    vagrant up $1
    vagrant ssh -c "curl -L https://raw.githubusercontent.com/mmrose/dotfiles/master/install.sh | sh"  $1
    vagrant ssh -c "sudo chsh -s /bin/zsh vagrant" $1
}

function vdu() {
    vagrant up $1
    vagrant ssh -c "update-dotfiles" $1
}

function vsp() {
    vagrant up $1
    vagrant ssh -c 'cat << "EOF" > /home/vagrant/.dotfiles/zsh/custom/local.zsh
export PATH=/home/vagrant/virtualenv/bin:$PATH
export STAGE=vagrant
cd /vagrant
EOF
' $1
}
