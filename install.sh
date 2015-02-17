#!/bin/sh
DOTFILES_DIR=".dotfiles"
DOTFILES="$HOME/$DOTFILES_DIR"
GIT_REPO="mmrose/dotfiles"
GIT_BRANCH="master"
OHMYZSH="$HOME/.oh-my-zsh"

## Check for git
if [ ! -x "$(which git)" ]; then
    echo "Git not found."
    exit 1
fi

## Remove symlinks
for SYMLINK in $(find $HOME -type l); do
    case $(readlink $SYMLINK) in
        $DOTFILES*) 
            echo "Removing symlink $SYMLINK"
            rm $SYMLINK
            ;;
    esac
done

## Grab oh-my-zsh
if [ ! -d "$OHMYZSH" ]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git $OHMYZSH
else
    cd $OHMYZSH
    git pull
    cd $HOME
fi

## Grab dotfiles
if [ ! -d "$DOTFILES" ]; then
    git clone https://github.com/$GIT_REPO.git $DOTFILES
    cd $DOTFILES
    git checkout $BRANCH
    git submodule init
else
    cd $DOTFILES
    git pull
fi
git submodule update --init --recursive
cd $HOME

## Create placeholder directories if not already there
for DIR in $(find $DOTFILES -not -iwholename "*.git*" -name "*.copy"); do
    DIR_NAME="$(basename ${DIR%.copy})"
    NEW_DIR="$HOME/.$DIR_NAME"
    if [ ! -d "$NEW_DIR" ]; then
        mkdir "$NEW_DIR"
    fi
    ## Symlink contents of placeholder directories (if they are directories)
    if [ -d "$DIR" ]; then
        for FILE in $(ls $DIR); do
            NEW_FILE="$NEW_DIR/$FILE"
            ## If not a symlink already
            if [ ! -L "$NEW_FILE" ]; then
                ## If the file exists (just not a symlink), back it up
                if [ -e "$NEW_FILE" ]; then
                    echo "Backup: $NEW_FILE -> $NEW_FILE.backup"
                    mv "$NEW_FILE" "$NEW_FILE.backup"
                fi
                ## Create the symlink
                echo "Creating symlink $NEW_FILE"
                ln -s "$DIR/$FILE" "$NEW_FILE"
            fi
        done
    fi
done


## Create config directories if not already there
for MATCH in $(find $DOTFILES -not -iwholename "*.git*" -name "*.config"); do
    BASE_NAME="$(basename ${MATCH%.config})"
    TARGET="$HOME/.config/$BASE_NAME"
    ## Symlink contents of placeholder directories (if they are directories)
    if [ -d "$MATCH" ]; then
        if [ ! -d "$TARGET" ]; then
            mkdir -p "$TARGET"
        fi
        for FILE in $(ls $MATCH); do
            NEW_FILE="$MATCH/$FILE"
            ## If not a symlink already
            if [ ! -L "$NEW_FILE" ]; then
                ## If the file exists (just not a symlink), back it up
                if [ -e "$NEW_FILE" ]; then
                    echo "Backup: $NEW_FILE -> $NEW_FILE.backup"
                    mv "$NEW_FILE" "$NEW_FILE.backup"
                fi
                ## Create the symlink
                echo "Creating symlink $NEW_FILE"
                ln -s "$MATCH/$FILE" "$NEW_FILE"
            fi
        done
    else
        ## If not symlink already
        if [ ! -L "$TARGET" ]; then
            ## Backup if file exists
            if [ -e "$TARGET" ]; then
                echo "Backup: $TARGET -> $TARGET.backup"
                mv "$TARGET" "$TARGET.backup"
            fi
            ## Create symlink
            echo "Creating symlink $TARGET"
            ln -s "$MATCH" "$TARGET"
        fi
    fi
done

## Symlink all the things!
for SYMLINK in $(find $DOTFILES -not -iwholename "*.git*" -name "*.symlink"); do
    BASE_NAME="$(basename ${SYMLINK%.symlink})"
    NEW_FILE="$HOME/.$BASE_NAME"
    ## If the new file isn't a symlink
    if [ ! -L "$NEW_FILE" ]; then
        ## If the file already exists (just not a symlink), back it up
        if [ -e "$NEW_FILE" ]; then
            echo "Backup: $(basename $NEW_FILE) -> $(basename $NEW_FILE).backup"
            mv "$NEW_FILE" "$NEW_FILE.backup"
        fi
        ## Create the symlink
        echo "Creating symlink $NEW_FILE"
        ln -s "$SYMLINK" "$NEW_FILE"
    fi
done

vim +PluginInstall +qall

exit 0;
