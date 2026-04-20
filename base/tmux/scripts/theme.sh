#!/usr/bin/env bash

set -e

TMUX_CONF_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

function apply_theme() {
	# Ensure variables are set from the default theme
	source "${TMUX_CONF_PATH}/themes/default.conf"

	local theme_name="$(tmux show-option -gqv @theme-name)"
	local theme_path="${TMUX_CONF_PATH}/themes/${theme_name}.conf"

	if [ -f "$theme_path" ]; then
		source "$theme_path"
	else
		tmux display-message \
			"Theme "${theme_name}" does not exist in theme folder"
	fi

	# List of variables that will be replaced in style settings
	local theme_vars=(
		t_status
		t_border
		t_msg
		t_window_name
		t_window_num
		t_window_flags
		t_window_flag_bell
		t_window_active_name
		t_window_active_num
		t_window_active_flags
		t_hostname
		t_clock
		t_indicator_copy
		t_indicator_prefix
		t_indicator_locked
		t_pane_title_active
		t_pane_title_active_edge
		t_pane_title_inactive
		t_pane_title_inactive_edge
		t_pane_title_text
		t_pane_title_transition
	)

	# List of settings to replcae theme variables in
	local style_settings=(
		status-style
		pane-border-style
		pane-active-border-style
		message-style
		window-status-format
		window-status-current-format
		status-left
		status-right
		pane-border-format
	)

	for setting in "${style_settings[@]}"; do
		local setting_string="$(tmux show-option -gqv $setting)"

		for theme_var_key in "${theme_vars[@]}"; do
			local theme_var="\#{$theme_var_key}"
			local value="${!theme_var_key}"
			setting_string="${setting_string//$theme_var/$value}"
		done

		# Split #[a,b] into #[a]#[b] to avoid comma conflicts
		# with #{?condition,true,false} in format strings
		setting_string="$(echo "$setting_string" | sed -E 's/#\[([^],]+),([^]]+)\]/#[\1]#[\2]/g')"

		tmux set-option -gq $setting "${setting_string}"
	done
}

apply_theme
