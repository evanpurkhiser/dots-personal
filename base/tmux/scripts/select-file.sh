#!/usr/bin/env bash

pane_id=$(tmux display -p '#{pane_id}')
window_id=$(tmux display -p '#{window_id}')

# Capture content from all panes in the current window
pane_content=""
for pane in $(tmux list-panes -t "$window_id" -F '#{pane_id}'); do
    pane_content+=$(tmux capture-pane -p -t "$pane")$'\n'
done

# Extract file-looking paths
file_candidates=$(echo "$pane_content" | grep -Eo '[^[:space:]]*/[^[:space:]]+' | grep -v ' ' | sort -u)

[ -z "$file_candidates" ] && exit 0

echo "${file_candidates}" >/tmp/tmux-files

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
  'cat /tmp/tmux-files | fzf --prompt=" ← insert filepath: " > /tmp/tmux-file-selected'

selected="$(cat /tmp/tmux-file-selected)"

if [[ -n "$selected" ]]; then
  tmux send-keys -t "$pane_id" "$selected"
fi
