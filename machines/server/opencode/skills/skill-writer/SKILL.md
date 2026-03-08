---
name: skill-writer
description: Create or update opencode skills. Use this skill when asked to write, add, or update a skill for opencode.
---

# Writing opencode Skills

Skills are markdown files that give opencode context and instructions for specific tasks.

## Location

Skills live in the dotfiles source tree (not directly in `~/.config`):

```
~/.local/etc/machines/server/opencode/skills/<skill-name>/SKILL.md
```

After editing, run `dots install` to install them to `~/.config/opencode/skills/`.

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

1. Create the directory and `SKILL.md` in `~/.local/etc/machines/server/opencode/skills/<name>/`
2. Write the skill content
3. Run `dots install` to install it
4. Restart opencode to pick up the new skill: `sudo systemctl restart opencode`
5. Test the skill by asking opencode something that should trigger it
6. Iterate until satisfied
7. When committing changes, **always read `~/.local/etc/AGENTS.md` first** to follow the correct commit message format: `<component>: <imperative description>`
8. Ask Evan if he'd like to commit and push the skill
