def escape: "\u001b";

def reset: escape + "[0m";

def reviewMap:
    {
        "APPROVED": "\(escape)[32m\(reset)",
        "REVIEW_REQUIRED": "\(escape)[33m\(reset)",
        "CHANGES_REQUESTED": "\(escape)[31m\(reset)",
        "": ""
    };

def checkMap:
    {
        "SUCCESS": "\(escape)[32m\(reset)",
        "FAILURE": "\(escape)[31m\(reset)",
        "ERROR": "\(escape)[31m\(reset)",
        "EXPECTED": "\(escape)[33m\(reset)",
        "PENDING": "\(escape)[33m\(reset)",
        "": "",
    };

.data.viewer.pullRequests.edges
    | map(
        .node |
        .commits.nodes[].commit.statusCheckRollup.state as $checkState
        | {
            number: .number,
            checkState: $checkState,
            checkColor: checkMap[$checkState // ""],
            review: .reviewDecision,
            reviewIcon: reviewMap[.reviewDecision // ""],
        }
        | " #\(.number) \(.checkColor) \(.reviewIcon)"
    )
    | join(" │ ")
