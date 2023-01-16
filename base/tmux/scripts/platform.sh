#!/usr/bin/env bash

if [ "$(uname)" == "Linux" ] && hash xcmenu 2>/dev/null; then
	tmux bind -t vi-copy Enter copy-pipe "xcmenu -ci"
fi
