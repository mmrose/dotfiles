if [[ `hostname` == W4DEUMSY9002045 ]]; then
    export http_proxy="http://proxy.mms-dresden.de:8080"
    export HTTP_PROXY=$http_proxy
    export https_proxy=$http_proxy
    export HTTPS_PROXY=$http_proxy
    export ftp_proxy=$http_proxy
    export FTP_PROXY=$http_proxy

    export VBOX_USER_HOME="C:/Users/$USER/.VirtualBox"
    export VAGRANT_HOME="C:/Users/$USER/.vagrant.d"

    unset GREP_OPTIONS

    alias np='/cygdrive/c/"Program Files (x86)"/Notepad++/notepad++.exe'
    alias poedit="/cygdrive/c/Program\ Files\ \(x86\)/Poedit/Poedit.exe"

    vms() {
        tmux send-keys 'vagrant ssh app -- -t "cd /usr/local/*suite*; mediasuite/bin/manage runserver 8100" ";" exec /bin/bash' C-m
        tmux split-window -c "$PWD"
        tmux send-keys 'vagrant ssh app -- -t "cd /usr/local/*suite*; mediasuite/bin/manage runcelery worker -l fatal" ";" exec /bin/bash' C-m
    }
    vws() {
        tmux send-keys 'vagrant ssh app -- -t "cd /usr/local/*suite*; webcastsuite/bin/manage runserver 8100" ";" exec /bin/bash' C-m
        tmux split-window
        tmux send-keys "cd $PWD" C-m 'vagrant ssh app -- -t "cd /usr/local/*suite*; webcastsuite/bin/manage runcelery worker -Q celery -l fatal" ";" exec /bin/bash' C-m
        tmux split-window
        tmux send-keys "cd $PWD" C-m 'vagrant ssh app -- -t "cd /usr/local/*suite*; webcastsuite/bin/manage runcelery worker -BQ highprio -l fatal -n highprio@%h" ";" exec /bin/bash' C-m
    }
    vwsi() {
        tmux send-keys 'vagrant ssh dmz -- -t "cd /usr/local/*suite*; wsi/bin/manage runserver 8200" ";" exec /bin/bash' C-m
        tmux split-window -c "$PWD"
        tmux send-keys 'vagrant ssh dmz -- -t "cd /var/local/*suite*; tail -f \$(find wsi/ -name *.log)" ";" exec /bin/bash' C-m
    }
fi

if [[ "`id -nu`" == "vagrant" ]]; then
    export STAGE=vagrant
    if [[ -x ~/virtualenv/bin/pyrun ]]; then
        export PATH=~/virtualenv/bin:$PATH
        cd /vagrant
    fi
fi
