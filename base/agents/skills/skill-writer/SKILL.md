---
name: skill-writer
description: Create or update opencode skills. Use this skill when asked to write, add, or update a skill for opencode.
---

# Writing Agent Skills

Skills are markdown files that give Claude and OpenCode context and instructions for specific tasks.

## Location

Skills live in the dotfiles source tree (not directly in `~/.config`):

```
~/.local/etc/<group>/agents/skills/<skill-name>/SKILL.md
```

After editing, run `dots install` to install them to `~/.config/agents/skills/` (which is shared by Claude and OpenCode).

## Choosing the right group

Place skills based on scope:

- `base/agents/skills/` -- default for broadly useful skills you want available across machines/contexts
- `machines/server/agents/skills/` -- server-only skills (home infra, media automation, server operations)
- `machines/work/agents/skills/` -- work-laptop-specific skills (for example `pr-workflow`)

Rule of thumb: start in `base` unless the skill is clearly tied to one machine/profile.

**Note:** See the `dotfile-management` skill for detailed information about working with the dotfiles repository and the `dots` utility.

## Frontmatter

Every skill **must** have frontmatter with `name` and `description`:

```markdown
---
name: skill-name
description: One sentence describing when to use this skill.
---
```

- `name`: must match the directory name
- `description`: used by opencode to decide when to load the skill — make it specific about the trigger condition

## When to create a new skill vs update an existing one

- **New skill**: the task is distinct enough to warrant its own trigger condition
- **Update existing**: the new info belongs to an existing skill's domain (e.g. adding a new service to `server-admin`)

## Workflow

1. Choose group scope (`base`, `machines/server`, or `machines/work`)
2. Create the directory and `SKILL.md` in `~/.local/etc/<group>/agents/skills/<name>/`
3. Write the skill content
4. Run `dots install` to install it
5. Restart/reload the relevant agent service if needed
6. Test the skill by asking something that should trigger it
7. Iterate until satisfied
8. When committing changes, **always read `~/.local/etc/AGENTS.md` first** to follow the correct commit message format: `<component>: <imperative description>`
9. Ask Evan if he'd like to commit and push the skill
