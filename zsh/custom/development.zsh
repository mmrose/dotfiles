alias tf="tail -f"


alias ssb="svn log -v -r0:HEAD --stop-on-copy --limit 1"


function upr() {
    for DIR in $(find $PWD/ -mindepth 1 -maxdepth 1 -type d -not -path "$PWD/.vagrant" -not -path "$PWD/VMs" -not -path "$PWD/.metadata"); do
        cd $DIR
        echo "Updating $DIR ...\n"
        if [[ -d '.git' ]]; then
            git pull
        elif [[ -d '.svn' ]]; then
            svn cleanup
            svn up
        else
            upr
        fi
        cd ..
    done
}
