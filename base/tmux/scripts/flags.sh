#!/usr/bin/env bash

#  *  Denotes the current window.
#  -  Marks the last window (previously selected).
#  #  Window activity is monitored and activity has been detected.
#  !  Window bells are monitored and a bell has occurred in the window.
#  ~  The window has been silent for the monitor-silence interval.
#  M  The window contains the marked pane.
#  Z  The window's active pane is zoomed.

set -e

option="\#{window_flags}"

readarray -t mappings <<-EOM
	s/*/ /
	s/-/󰌍 /
	s/#/ /
	s/!/󰂞 /
	s/~/󰝟 /
	s/M/ /
	s/Z/󰁌 /
EOM

sed_script="$(
	IFS=';'
	echo "${mappings[*]}"
)"

# The extra replacment adds spaces between each character
formatting_script="sed -e '${sed_script}g'"
flags_value=" #(printf '%%s\n' '#F' | ${formatting_script})"

for setting in window-status-format window-status-current-format; do
	status_value="$(tmux show-option -gqv ${setting})"
	tmux set-option -gq $setting "${status_value/$option/$flags_value}"
done
