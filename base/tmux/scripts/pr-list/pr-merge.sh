#!/usr/bin/env bash
# Squash-merge PRs given their GitHub URLs (one per argument)

for url in "$@"; do
    repo=$(echo "$url" | sed 's|https://github.com/||;s|/pull/.*||')
    pr=$(echo "$url" | grep -o '[0-9]*$')
    gh pr merge "$pr" --repo "$repo" --squash || true
done

# Refresh PR statusline
"$XDG_CONFIG_HOME/bash/bin/pr-statusline/pr-statusline" &
