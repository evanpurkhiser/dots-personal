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

# Each format uses a different base flag style, so the bell replacement
# restores to the appropriate one after its colored icon.
declare -A restore=(
	[window-status-format]="#{t_window_flags}"
	[window-status-current-format]="#{t_window_active_flags}"
)

for setting in window-status-format window-status-current-format; do
	readarray -t mappings <<-EOM
		s/*/ /
		s/-/󰌍 /
		s/#/ /
		s/!/#[#{t_window_flag_bell}]󰂞 #[${restore[$setting]}]/
		s/~/󰝟 /
		s/M/ /
		s/Z/󰁌 /
	EOM

	sed_script="$(
		IFS=';'
		echo "${mappings[*]}"
	)"

	# The extra replacement adds spaces between each character
	formatting_script="sed -e '${sed_script}g'"
	flags_value=" #(printf '%%s\n' '#F' | ${formatting_script})"

	status_value="$(tmux show-option -gqv ${setting})"
	tmux set-option -gq $setting "${status_value/$option/$flags_value}"
done
