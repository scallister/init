#!/usr/bin/env bash

# Confirm in a dotfile repository
if ! basename $(pwd) | grep -i dotfiles
then
    echo "This script can only be run from without a dotfiles directory"
    exit 1
fi

if [ -z $HOME ]; then
    echo '$HOME must be defined'
    exit 1
fi

base_dirs=`ls -d */`
dirs_to_stow=`echo "$base_dirs" "$include_dirs"`

echo "Running stow on these directories:"
echo "$dirs_to_stow"


for d in $dirs_to_stow
do
    ( stow --target $HOME --delete $d )
done
