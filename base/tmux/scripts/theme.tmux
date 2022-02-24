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
        t_window_active_name
        t_window_active_num
        t_window_active_flags
        t_hostname
        t_clock
        t_indicator_copy
        t_indicator_prefix
        t_indicator_locked
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
    )

    for setting in "${style_settings[@]}"; do
        local setting_string="$(tmux show-option -gqv $setting)"

        for theme_var_key in "${theme_vars[@]}"; do
            local theme_var="\#{$theme_var_key}"
            local value="${!theme_var_key}"
            setting_string="${setting_string/$theme_var/$value}"
        done

        tmux set-option -gq $setting "${setting_string}"
    done
}

apply_theme
