if [[ `hostname` == W4DEUMSY9002045 ]]; then
    export http_proxy="http://proxy.mms-dresden.de:8080"
    export HTTP_PROXY=$http_proxy
    export https_proxy=$http_proxy
    export HTTPS_PROXY=$http_proxy
    export ftp_proxy=$http_proxy
    export FTP_PROXY=$http_proxy
    unset GREP_OPTIONS

    alias np='/cygdrive/c/"Program Files (x86)"/Notepad++/notepad++.exe'
    alias poedit="/cygdrive/c/Program\ Files\ \(x86\)/Poedit/Poedit.exe"

    vms() {
        tmux send-keys 'vagrant ssh app -- -t "cd /usr/local/*suite*; mediasuite/bin/manage runserver 8100" ";" exec /bin/bash' C-m
        tmux split-window -c "$PWD"
        tmux send-keys 'vagrant ssh app -- -t "cd /usr/local/*suite*; mediasuite/bin/manage runcelery -Bv2 worker" ";" exec /bin/bash' C-m
    }
    vws() {
        tmux send-keys 'vagrant ssh app -- -t "cd /usr/local/*suite*; webcastsuite/bin/manage runserver 8100" ";" exec /bin/bash' C-m
        tmux split-window -c "$PWD"
        tmux send-keys 'vagrant ssh app -- -t "cd /usr/local/*suite*; webcastsuite/bin/manage runcelery -Bv2 worker" ";" exec /bin/bash' C-m
    }
fi
