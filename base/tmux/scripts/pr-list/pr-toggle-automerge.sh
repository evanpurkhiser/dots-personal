#!/usr/bin/env bash
# Toggle auto-merge on PRs given their GitHub URLs (one per argument)

for url in "$@"; do
    repo=$(echo "$url" | sed 's|https://github.com/||;s|/pull/.*||')
    pr=$(echo "$url" | grep -o '[0-9]*$')
    gh pr merge "$pr" --repo "$repo" --squash --auto 2>/dev/null \
        || gh pr merge "$pr" --repo "$repo" --disable-auto || true
done

# Refresh PR statusline
~/.config/bash/bin/pr-statusline/pr-statusline &
