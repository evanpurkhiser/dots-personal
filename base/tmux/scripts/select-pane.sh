#!/usr/bin/env bash

pane_id=$(tmux display -p '#{pane_id}')

# Build list of all panes with ID and title
pane_list=$(tmux list-panes -a -F '#{pane_id} #{pane_title}')

[ -z "$pane_list" ] && exit 0

echo "${pane_list}" >/tmp/tmux-panes

export FZF_TMUX_HEIGHT=15
term_height=$(tmux display -p '#{window_height}')
cursor_y=$(($(tmux display -p -t "$pane_id" '#{pane_top} + #{cursor_y}')))

layout="--layout=reverse"
pos_x=$(($(tmux display -p -t "$pane_id" '#{pane_left} + #{cursor_x}')))
pos_y=$(("$cursor_y" + "$FZF_TMUX_HEIGHT"))

if ((pos_y > term_height)); then
	layout="--layout=default"
	pos_y="$((cursor_y + 1))"
fi

tmux display-popup \
	-E \
	-B \
	-x ${pos_x} -y ${pos_y} \
	-h ${FZF_TMUX_HEIGHT} \
	-w 60 \
	-e FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT} $layout $FZF_DEFAULT_OPTS" \
	'cat /tmp/tmux-panes | fzf --prompt=" ← insert pane: " > /tmp/tmux-pane-selected'

selected="$(cat /tmp/tmux-pane-selected)"

if [[ -n $selected ]]; then
	# Extract just the pane ID (%N)
	selected_id=$(echo "$selected" | awk '{print $1}')
	tmux send-keys -t "$pane_id" "$selected_id"
fi
