if [[ `hostname` == W4DEUMSY9002045 ]]; then
    export http_proxy="http://proxy.mms-dresden.de:8080"
    export HTTP_PROXY=$http_proxy
    export https_proxy=$http_proxy
    export HTTPS_PROXY=$http_proxy
    export ftp_proxy=$http_proxy
    export FTP_PROXY=$http_proxy

    export VBOX_USER_HOME="C:/Develop/VMs"
    export VAGRANT_HOME="C:/Develop/VMs/.vagrant.d"

    unset GREP_OPTIONS

    alias np='/cygdrive/c/"Program Files (x86)"/Notepad++/notepad++.exe'
    alias poedit="/cygdrive/c/Program\ Files\ \(x86\)/Poedit/Poedit.exe"

    vms() {
        tmux send-keys 'vagrant ssh app -- -t "cd /usr/local/*suite*; mediasuite/bin/manage runserver 8000" ";" exec /bin/zsh' C-m
        tmux split-window
        tmux send-keys "cd $PWD" C-m 'vagrant ssh app -- -t "cd /usr/local/*suite*; mediasuite/bin/manage runcelery beat --schedule=/vagrant/celerybeat-schedule.db --pidfile=/vagrant/celery_beat.pid" ";" exec /bin/zsh' C-m
        tmux split-window
        tmux send-keys "cd $PWD" C-m 'vagrant ssh app -- -t "cd /usr/local/*suite*; mediasuite/bin/manage runcelery worker -l fatal" ";" exec /bin/zsh' C-m
    }
    vws() {
        tmux send-keys 'vagrant ssh app -- -t "cd /usr/local/*suite*; webcastsuite/bin/manage runserver 8100" ";" exec /bin/zsh' C-m
        tmux split-window
        tmux send-keys "cd $PWD" C-m 'vagrant ssh app -- -t "cd /usr/local/*suite*; webcastsuite/bin/manage runcelery beat --schedule=/vagrant/celerybeat-schedule.db --pidfile=/vagrant/celery_beat.pid" ";" exec /bin/zsh' C-m
        tmux split-window
        tmux send-keys "cd $PWD" C-m 'vagrant ssh app -- -t "cd /usr/local/*suite*; webcastsuite/bin/manage runcelery worker -Q highprio -l fatal -n highprio@%h" ";" exec /bin/zsh' C-m
        tmux split-window
        tmux send-keys "cd $PWD" C-m 'vagrant ssh app -- -t "cd /usr/local/*suite*; webcastsuite/bin/manage runcelery worker -Q celery -l fatal" ";" exec /bin/zsh' C-m
    }
    vwsi() {
        tmux send-keys 'vagrant ssh dmz -- -t "cd /usr/local/*suite*; wsi/bin/manage runserver 8200" ";" exec /bin/zsh' C-m
        tmux split-windo
        tmux send-keys "cd $PWD" C-m 'vagrant ssh dmz -- -t "cd /var/local/*suite*; tail -f \$(find wsi/ -name *.log)" ";" exec /bin/zsh' C-m
    }
fi

if [[ "`id -nu`" == "vagrant" ]]; then
    export STAGE=vagrant
    if [[ -x /opt/python/bin/python ]]; then
        export PATH=/opt/python/bin:$PATH
        cd /vagrant
    fi
    if [[ -x ~/virtualenv/bin/pyrun ]]; then
        export PATH=~/virtualenv/bin:$PATH
        cd /vagrant
    fi

    if [[ -x /opt/flowplayer ]]; then
        cd /vagrant/flash-build
    fi
fi
