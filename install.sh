#!/bin/sh
GIT_REPO="mmrose/dotfiles"
GIT_BRANCH="master"

## Check for git and curl
if ! [ -x "$(command -v git)" ] || ! [ -x "$(command -v curl)" ]; then
  echo 'Install both: git and curl.' >&2
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
if [ -d "~/.oh-my-zsh" ]; then
    rm -rf ~/.oh-my-zsh
fi

## Grab dotfiles
if [ -d "~/.dotfiles" ]; then
    rm -rf ~/.dotfiles
fi

exit 0;
