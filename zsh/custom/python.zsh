alias p='python'
alias pm='python manage.py'
alias pmr='python manage.py runserver'
alias pms='python manage.py shell'
alias pi='pip install'
alias pf='pip freeze'
alias pfg='pip freeze | grep -i'

# virtualenvwrapper
if [ -e /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
    export WORKON_HOME=$HOME/virtualenvs
fi

# pythonz
[[ -s $HOME/.pythonz/etc/bashrc ]] && source $HOME/.pythonz/etc/bashrc
