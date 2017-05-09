#!/usr/bin/env bash

# Ensure new shell session become reattached to the user namespace
if [ "$(uname)" == "Darwin" ] && hash reattach-to-user-namespace 2>/dev/null
then
    tmux set -g default-command "tmux rename-window 'bash'; reattach-to-user-namespace -l $SHELL"
    tmux bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
fi

if [ "$(uname)" == "Linux" ] && hash xcmenu 2>/dev/null
then
    tmux bind -t vi-copy Enter copy-pipe "xcmenu -ci"
fi
