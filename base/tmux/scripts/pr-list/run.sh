#!/usr/bin/env bash
#
# pr-list - Browse open PRs in a tmux popup with fzf
#

source "$XDG_CONFIG_HOME/bash/fzf" 2>/dev/null

scripts="$XDG_CONFIG_HOME/tmux/scripts/pr-list"
pane_id=$(tmux display-message -p '#{pane_id}')
json_cache="${XDG_STATE_HOME}/pr-statusline.json"
tmp=$(mktemp -d)
trap "rm -rf $tmp" EXIT

cat > "$tmp/parser.jq" <<'JQ'
def icon($cp): [$cp] | implode;
def rpad($n): tostring | ($n - length) as $p | . + (" " * (if $p > 0 then $p else 0 end));

def ansi($code): "\u001b[\($code)m";
def reset: ansi(0);

def reviewIcon:
    {
        "APPROVED":          ansi(32) + icon(983424) + reset,
        "REVIEW_REQUIRED":   ansi(33) + icon(983429) + reset,
        "CHANGES_REQUESTED": ansi(31) + icon(983431) + reset,
        "":                  " "
    };

def checkIcon:
    {
        "SUCCESS":  ansi(32) + icon(61452) + reset,
        "FAILURE":  ansi(31) + icon(62532) + reset,
        "ERROR":    ansi(31) + icon(62532) + reset,
        "EXPECTED": ansi(33) + icon(60092) + reset,
        "PENDING":  ansi(33) + icon(60092) + reset,
        "":         " "
    };

def autoMergeIcon:
    if . then ansi(34) + icon(983569) + reset
    else " " end;

.data.viewer.pullRequests.edges
    | map(.node) as $prs
    | ($prs | map(.number | tostring | length) | max) as $numWidth
    | $prs | map(
        .commits.nodes[0].commit.statusCheckRollup.state as $check
        | "\(.url)\t" + icon(59176) + " \(.title)\n  " + ansi(90) + "#\(.number | rpad($numWidth))" + reset + " \(checkIcon[$check // ""]) \(reviewIcon[.reviewDecision // ""]) \(.autoMergeRequest | autoMergeIcon) " + ansi(90) + .repository.nameWithOwner + reset + "\u001e"
    )
    | .[]
JQ

if [[ ! -f "$json_cache" ]]; then
    echo "No PR data cached yet. Waiting for pr-statusline to run..."
    sleep 2
    exit 1
fi

jq -rj -f "$tmp/parser.jq" "$json_cache" | tr '\036' '\0' > "$tmp/data"

cat > "$tmp/run.sh" <<SHELL
export PATH="$PATH"

extract="$scripts/pr-extract-urls.sh"

cat "$tmp/data" | fzf \\
    --read0 \\
    --ansi \\
    --multi \\
    --with-nth=2.. \\
    --delimiter=\$'\t' \\
    --no-info \\
    --layout=reverse \\
    --color='current-bg:-1,current-fg:-1,current-hl:-1' \\
    --no-scrollbar \\
    --bind="alt-c:execute-silent(echo {+} | \$extract | tr '\n' '\n' | pbcopy)+abort" \\
    --bind="alt-enter:execute-silent(echo {+} | \$extract | xargs $scripts/pr-insert-url.sh $pane_id)+abort" \\
    --bind="alt-m:execute-silent(echo {+} | \$extract | xargs $scripts/pr-merge.sh)+abort" \\
    --bind="alt-.:execute-silent(echo {+} | \$extract | xargs $scripts/pr-toggle-automerge.sh)+abort" \\
    > "$tmp/selected"
SHELL

tmux display-popup -E -w 100 -h 25 -x C -y C "bash $tmp/run.sh"

selected=$(cat "$tmp/selected" 2>/dev/null)

if [[ -n "$selected" ]]; then
    echo "$selected" | "$scripts/pr-extract-urls.sh" | while read -r url; do
        open "$url"
    done
fi
