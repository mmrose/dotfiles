alias tf="tail -f"


function update-repos() {
    for DIR in $(find . -mindepth 1 -maxdepth 1 -type d); do
        cd $DIR
        echo "Updating $DIR ..."
        if [[ -d '.git' ]]; then
            git pull
        elif [[ -d '.svn' ]]; then
            svn up
        fi
        cd ..
    done
}
