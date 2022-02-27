#!/usr/bin/env bash

set -e

option="\#{prefix_highlight}"
prefix_text=""
copy_text=" COPY"

copy_format="#[#{t_indicator_copy}]#{?pane_in_mode, ${copy_text} ,}"
prefix_format="#[#{t_indicator_prefix}]#{?client_prefix, ${prefix_text} ,${copy_format}}#[default]"

status_value="$(tmux show-option -gqv status-right)"
tmux set-option -gq status-right "${status_value/$option/$prefix_format}"
