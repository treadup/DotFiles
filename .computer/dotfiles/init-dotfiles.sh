#!/bin/bash

# This is from the following Hacker News comment.
# https://news.ycombinator.com/item?id=11071754

# Initializes a new dotfiles repo
git init --bare $HOME/.dotconf
/usr/bin/git --git-dir=$HOME/.dotconf/ --work-tree=$HOME config status.showUntrackedFiles no
