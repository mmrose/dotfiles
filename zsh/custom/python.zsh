alias p='python'
alias pm='python manage.py'
alias pmh='python manage.py help'
alias pmr='python manage.py runserver'
alias pms='python manage.py shell'
alias pi='pip install'
alias pf='pip freeze'
alias pfg='pip freeze | grep -i'
alias pcl='pip freeze --local | grep -v "^\-e" | cut -d = -f 1 | xargs -n1 -P10 pip uninstall -y'

# virtualenvwrapper
if [ -e /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
    export WORKON_HOME=$HOME/virtualenvs
fi

# pythonz
[[ -s $HOME/.pythonz/etc/bashrc ]] && source $HOME/.pythonz/etc/bashrc
