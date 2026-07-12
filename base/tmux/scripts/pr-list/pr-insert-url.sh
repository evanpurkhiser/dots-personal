#!/usr/bin/env bash
# Insert PR URLs into the target tmux pane
# Usage: pr-insert-url.sh PANE_ID URL [URL...]
pane_id="$1"
shift

for url in "$@"; do
	tmux send-keys -t "$pane_id" -l -- "$url"
done
