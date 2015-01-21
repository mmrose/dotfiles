function update_repos() {
    for DIR in $(find . -mindepth 1 -maxdepth 1 -type d); do
        cd $DIR
        if [[ -d '.git' ]]; then
            git pull
        elif [[ -d '.svn' ]]; then
            svn up
        fi
        cd ..
    done
}
