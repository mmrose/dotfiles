if [[ `hostname` != W4DEUMSY9002045 ]]; then
    alias sshpis='ssh pi@pi-storage.fritz.box'
    alias sshpib='ssh pi@pi-backup.fritz.box'
    alias sshtj='ssh technikjargon.de'

    function create_envs() {
        # $1 is env name, others are python versions
        if (( $# < 2)); then 
            echo "Need a virtualenv name and at least one python version"
            return
        fi
        venv_name="$1"
        for i ({2..$#}); do
            python_version=${(P)i}
            # check if version is already installed
            if [[ -z "$(pythonz locate $python_version 2>/dev/null)" ]]; then
                pythonz install $python_version
            fi
            # check if there already is a virtualenv
            if [[ ! -d "$WORKON_HOME/$venv_name-$python_version" ]]; then
                mkvirtualenv -p $(pythonz locate $python_version) "$venv_name-$python_version"
                deactivate
            fi
        done
    }

    function install_dependencies() {
        if (( $# < 2)); then
            echo "Need a virtualenv name and at least one python version"
            return
        fi
        # ensure envs are created
        create_envs $*

        venv_name=$1
        for i ({2..$#}); do
            $WORKON_HOME/$venv_name-${(P)i}/bin/pip install -e .
        done
    }
fi
