---
name: git-status
description: Show uncommitted and unpushed changes in ~/workspace repositories with git diffs. ONLY use when explicitly invoked by name or with very explicit requests like "use the git status skill" or "show me everything uncommitted in ~/workspace".
---

# Git Status Skill

This skill finds and displays uncommitted and unpushed changes across all git repositories in ~/workspace.

## When to Use

**ONLY use this skill when:**
- User explicitly says "use the git status skill"
- User says something very explicit like "show me everything uncommitted in ~/workspace"
- User explicitly invokes this skill by name

**DO NOT use for general git questions or requests.**

## Workflow

1. Find all git repositories in ~/workspace (up to 2 levels deep)
2. For each repository, check:
   - Uncommitted changes (modified, staged, untracked files)
   - Unpushed commits
3. Display results with full diffs in markdown code blocks

## Commands

### Find all git repos
```bash
find ~/workspace -maxdepth 2 -name .git -type d -exec dirname {} \;
```

### For each repository:

**Check for uncommitted changes:**
```bash
cd <repo> && git status --short
```

**Get diff for uncommitted changes:**
```bash
cd <repo> && git diff HEAD
```
This shows both staged and unstaged changes.

**Check for unpushed commits:**
```bash
cd <repo> && git log --branches --not --remotes --oneline
```

**Get diff for unpushed commits:**
```bash
cd <repo> && git diff origin/$(git branch --show-current)..HEAD
```
Or if there are multiple unpushed commits, show each:
```bash
cd <repo> && git log --branches --not --remotes --patch
```

## Output Format

For each repository with changes, display:

```markdown
## **<repo-name>**

### Uncommitted Changes
<list of files from git status --short>

#### Diff
\```diff
<output from git diff HEAD>
\```

### Unpushed Commits
<list of commits from git log>

#### Diff
\```diff
<output from git diff or git log --patch>
\```
```

## Important Notes

- **Never commit or push** - only show status and diffs
- Show full diffs in ```diff``` code blocks
- Skip repositories with no uncommitted or unpushed changes
- Handle merge conflicts gracefully (UD, UU status codes)
