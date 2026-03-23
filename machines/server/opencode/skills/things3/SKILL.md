---
name: things3
description: Manage Evan's Things 3 todo list. Use this skill when Evan asks to add tasks, review or triage the inbox, organize todos, check what's scheduled, edit tasks, mark things done, or anything related to his personal task management and projects.
---

# Skill: Things 3 Todo Management

Evan uses Things 3 as his primary task management system, synced via Things Cloud.
The CLI tool is `things3` (installed via `uv tool`).

## Evan's Workflow

- **Inbox**: Quick capture - anything that needs to get out of his head goes here first. No detail required.
- **Today**: What he's actively working on or committed to today. Includes an "Evening" section.
- **Anytime**: The general backlog - tasks he intends to do but hasn't scheduled.
- **Upcoming**: Tasks scheduled for a specific future date.
- **Someday**: Templates and aspirational/low-priority items (e.g. "Cleaning" project template to duplicate later).
- **Projects**: Discrete sets of tasks with a clear "done" state (travel packing, cleaning runs, etc.)
- **Areas**: Ongoing areas of responsibility (Vivian, Memory Lists, travel recs).

### Scheduling Logic

When helping Evan organize or triage:
- **No context / just needs to be remembered** -> Inbox (or `--when anytime` if adding directly to backlog)
- **Has a specific date or pertinent time** -> `--when YYYY-MM-DD` or `today`
- **Needs to be done by a date** -> `--deadline YYYY-MM-DD`
- **Vague future backlog** -> `--when anytime`
- **Template / aspirational** -> `--when someday`

## CLI Reference

### View Commands

```bash
things3 inbox [--detailed]
things3 today [--detailed]
things3 upcoming [--detailed]
things3 anytime [--detailed]
things3 someday [--detailed]
things3 logbook [--detailed]
things3 projects list
things3 project <id>          # show tasks in a specific project
things3 areas list
things3 area <id>
things3 tags
```

`--detailed` shows notes and checklist items beneath each task.

### IDs

Tasks and projects are identified by short UUID prefixes (e.g. `PV6`, `EzC`). These are shown in the left column of list output. You only need enough characters to be unique.

### Creating Tasks

```bash
things3 new "Task title"
things3 new "Task title" --in inbox          # default
things3 new "Task title" --when anytime
things3 new "Task title" --when today
things3 new "Task title" --when 2026-04-15
things3 new "Task title" --deadline 2026-04-10
things3 new "Task title" --notes "Some context"
things3 new "Task title" --tags "tag1,tag2"
things3 new "Task title" --in <project-id>   # add directly to a project
things3 new "Task title" --in <area-id>
```

### Editing Tasks

```bash
things3 edit <id> --title "New title"
things3 edit <id> --notes "New notes"        # replaces existing notes
things3 edit <id> --notes ""                 # clears notes
things3 edit <id> --move <project-id>        # move to project
things3 edit <id> --move inbox               # move back to inbox
things3 edit <id> --move clear               # remove from project/area
```

### Scheduling

```bash
things3 schedule <id> --when today
things3 schedule <id> --when anytime
things3 schedule <id> --when someday
things3 schedule <id> --when evening
things3 schedule <id> --when 2026-04-15
things3 schedule <id> --deadline 2026-04-10
things3 schedule <id> --clear-deadline
```

### Marking Status

```bash
things3 mark <id> --done
things3 mark <id> --incomplete
things3 mark <id> --canceled
things3 mark <id1> <id2> <id3> --done        # multiple at once

# Checklist items (use short IDs shown in --detailed output)
things3 mark <task-id> --check <checklist-id>
things3 mark <task-id> --uncheck <checklist-id>
things3 mark <task-id> --check-cancel <checklist-id>
```

### Projects

```bash
things3 projects new "Project title"
things3 projects new "Project title" --in <area-id>
things3 projects new "Project title" --when anytime --deadline 2026-05-01
```

### Reordering

```bash
things3 reorder <id> --before <other-id>
things3 reorder <id> --after <other-id>
```

### Deleting

```bash
things3 delete <id>
```

### Global Flags

```bash
things3 --no-sync <command>    # skip cloud sync, use local cache (faster)
things3 --no-color <command>   # plain text output
```

## Tips

- Always run a view command first (e.g. `things3 inbox`) to get current IDs before editing.
- Use `--no-sync` for read-only lookups when speed matters.
- When triaging the inbox, read it first, then batch schedule/move/edit tasks.
- Use `--detailed` to see notes before editing them.
