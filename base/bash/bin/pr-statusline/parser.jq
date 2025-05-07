def reviewMap:
    {
        "APPROVED": "#[fg=green]󰆀#[default]",
        "REVIEW_REQUIRED": "#[fg=yellow]󰆅#[default]",
        "CHANGES_REQUESTED": "#[fg=red]󰆇#[default]",
        "": ""
    };

def checkMap:
    {
        "SUCCESS": "#[fg=green]#[default]",
        "FAILURE": "#[fg=red]#[default]",
        "ERROR": "#[fg=red]#[default]",
        "EXPECTED": "#[fg=yellow]#[default]",
        "PENDING": "#[fg=yellow]#[default]",
        "": "",
    };

.data.viewer.pullRequests.edges
    | map(.node
        | .commits.nodes[].commit.statusCheckRollup.state as $checkState
        | {
            number: .number,
            checkState: $checkState,
            checkColor: checkMap[$checkState // ""],
            review: .reviewDecision,
            reviewIcon: reviewMap[.reviewDecision // ""],
          }
        | " ##\(.number) \(.checkColor) \(.reviewIcon)"
    )
    | join(" #[fg=grey]│#[default] ")
