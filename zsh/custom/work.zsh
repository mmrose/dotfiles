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
fi

if [[ "`id -nu`" == "vagrant" ]]; then
    MSM=`echo /**/usr/local/*/mediasuite/bin/manage`
    WSM=`echo /**/usr/local/*/webcastsuite/bin/manage`


    alias msm=$MSM
    alias msr="while true; do msm runserver 8000; sleep 2; done"
    alias msc="msm runcelery worker -BQ celery -l info --autoreload"
    alias msp="/usr/local/*/mediasuite/bin/pip"

    alias wsm=$WSM
    alias wsr="while true; do wsm runserver 8100; sleep 2; done"
    alias wsc="wsm runcelery worker -BQ celery,highprio -l info --autoreload"
    alias wsp="/usr/local/*/webcastsuite/bin/pip"

    alias wsim="/usr/local/*/wsi/bin/manage"
    alias wsir="while true; do wsim runserver 8200; sleep 2; done"
    alias wsip="/usr/local/*/wsi/bin/pip"

    alias sctl="/usr/local/*/supervisor/bin/supervisorctl"

    export STAGE=vagrant
    cd /vagrant 

    if [[ -x /opt/python/bin/python ]]; then
        export PATH=/opt/python/bin:$PATH
    fi
    if [[ -x ~/virtualenv/bin/pyrun ]]; then
        export PATH=~/virtualenv/bin:$PATH
    fi
fi
