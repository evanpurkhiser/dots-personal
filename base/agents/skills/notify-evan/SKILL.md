---
name: notify-evan
description: Send Evan a Telegram notification via purkhiser-bot. Use proactively when Evan is AFK or has said he'll be away and something important needs his attention — SSH agent auth prompts, blocked tasks, errors requiring a decision, long-running tasks completing, or any situation where work cannot proceed without him.
---

## One-way channel — Evan cannot reply

This is a **one-way** notification channel. purkhiser-bot delivers messages to
Evan's phone, but there is **no back-channel** for him to reply through it.

- Notifications must be **statements**, not questions.
- **Never pause** waiting for an answer to a notification — no reply is ever coming.
- If a decision is needed:
  - Prefer making the call yourself with whatever judgment you have, and proceed.
  - If you genuinely cannot proceed, stop and surface the question in your
    terminal output where Evan will see it next time he checks — but do not
    block waiting for a Telegram reply.

## Checking if Evan is AFK

On macOS, always check keyboard/mouse idle time before notifying. If Evan is
actively at his machine, print a message to the terminal instead and wait — only
send a push notification when he's actually away.

```sh
idle=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print int($NF/1000000000); exit}')
```

**If idle > 120 seconds**: send the notification via purkhiser-bot.
**If idle ≤ 120 seconds**: print to terminal and wait — Evan can see it.

### Full pattern

```sh
idle=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print int($NF/1000000000); exit}')

if [ "$idle" -gt 120 ]; then
  echo "Claude: <your message>" | ping-purkhiser-bot
else
  echo "Evan is likely at his computer — no notification sent"
fi
```

## How to send a notification

```sh
echo "Your message here" | ping-purkhiser-bot
```

## Message guidelines

- Identify yourself — different agents send notifications via purkhiser-bot
- Include enough context that Evan can act without reading the full conversation
- Be specific: say what happened and what's needed
- Keep it short — this is a push notification, not a report
- Telegram style markdown is supported, but be careful
- **Never end with "?"** expecting a response — this channel is one-way
- **Never** phrase things as "let me know", "what do you want me to do",
  "should I…", or any other prompt for a reply. Evan cannot reply here.

### Examples

```sh
echo "Claude: SSH agent auth needed to push — please approve the 1Password prompt" | ping-purkhiser-bot

echo "Claude: Ansible playbook failed on 'Install purkhiser-bot service' — waiting for you to check" | ping-purkhiser-bot

echo "Claude: Deploy finished successfully. All tests passed." | ping-purkhiser-bot
```
