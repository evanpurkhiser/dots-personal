#!/usr/bin/env bash

set -e

option="\#{locked}"
text=" LOCKED"

locked_format="#[#{t_indicator_locked}]#{?pane_input_off, ${text} ,}#[default]"

status_value="$(tmux show-option -gqv status-right)"
tmux set-option -gq status-right "${status_value/$option/$locked_format}"
