#!/usr/bin/env bash
set -e

# Confirm in a dotfile repository
if ! basename $(pwd) | grep -i dotfiles
then
    echo "This script can only be run from without a dotfiles directory"
    exit 1
fi

# Dirs to not stow
dirs_to_not_stow=(
"install-scripts"
)

if ! which stow > /dev/null
then
    echo "Install the stow utility to run this script"
    echo "sudo apt-get install -y stow"
    exit 1
fi

if [ -z $HOME ]; then
    echo '$HOME must be defined'
    exit 1
fi

base_dirs=`ls -d */`
dirs_to_stow=`echo "$base_dirs" "$include_dirs"`

# Filter out dirs we don't care about
for dir in "${dirs_to_not_stow[@]}"; do
    #echo "Removing $dir"
    dirs_to_stow=`echo "$dirs_to_stow" | grep -iv "$dir"`
done

# Running pre-stow scripts
pre_scripts=`find install-scripts/pre/ -type f`
echo ""
echo "=== Running pre scripts ==="
for script in $pre_scripts; do
    echo "Running $script"
    source $script
done

echo ""
echo "=== Running stow on these directories ==="
echo "$dirs_to_stow"

# Stow directories
stow --target $HOME --stow $dirs_to_stow

# Running post-stow scripts
post_scripts=`find install-scripts/post/ -type f`
echo ""
echo "=== Running post scripts ==="
for script in $post_scripts; do
    echo "Running $script"
    source $script
done
