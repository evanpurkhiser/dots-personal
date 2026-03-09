---
name: context-share
description: Send context from this conversation to another chat session. Use this skill when Evan says things like "send this context to my ansible-personal chat", "create a new session with this debugging info", or "let's take what we learned and continue in the dots workspace".
---

# Skill: Context Share

Share conversation context between opencode chat sessions by summarizing and sending messages to other sessions via the opencode server API.

## Environment

The skill uses `$OPENCODE_HOST` to connect to the running opencode server. This should be configured in the systemd service file:

```bash
Environment="OPENCODE_HOST=http://localhost:9995"
```

If `$OPENCODE_HOST` is not set, default to `http://localhost:9995`.

## Workflow

### 1. Parse user intent

Extract from the user's request:
- **What context to share**: specific topic/summary or "all of this"
- **Where to send it**: project/workspace name OR "most recent" OR "new session"
- **Optional title** for new sessions

**Default behavior when ambiguous:**
- "send to X" / "send this to X" → **CREATE NEW SESSION** (default)
- "add to X" / "continue in X" → **FIND RECENT SESSION**
- "most recent" / "latest" / "current" → **FIND RECENT SESSION**
- "new session" / "create session" → **CREATE NEW SESSION** (explicit)

**Rationale:** Context-sharing typically means branching off to do new work with learned knowledge. Creating a new session is safer than potentially adding to the wrong existing session.

Examples:
- "send the tailscale DNS fix to my ansible-personal chat" → **NEW** session
- "add this context to my ansible-personal chat" → **RECENT** session
- "create a new session in dots-personal with this bug context" → **NEW** session (explicit)
- "take what we learned about the API and send it to my most recent chat" → **RECENT** session (explicit)

### 2. Summarize the context

**You** create the summary — no export/import needed. Based on the conversation:

- Identify the key findings, decisions, or information
- Write a clear, concise summary (3-10 sentences)
- Include code snippets or commands if relevant
- Frame it as "Context from another session:" so the receiving chat understands

**Good summary example:**
```
Context from debugging session:

We identified that the tailscale magic-dns issue was caused by systemd-resolved 
not properly handling .ts.net domains. The fix requires:

1. Configure /etc/systemd/resolved.conf with DNS=100.100.100.100
2. Add Domains=~ts.net to route queries properly  
3. Restart systemd-resolved

Now let's implement this fix in the ansible playbook.
```

### 3. Resolve the target destination

#### Option A: Create new session (DEFAULT)

If user said "send to X" without "recent" or "add to" keywords:

```bash
# Create session with optional directory/workspace/title
curl -s -X POST "$OPENCODE_HOST/session?directory=/home/evan/coding/$PROJECT" \
  -H "Content-Type: application/json" \
  -d "{\"title\": \"$TITLE\"}" | jq -r '.id'
```

**Title generation:**
- If user provided title, use it
- Otherwise, generate from context: "Bug fix from debugging" or "Tailscale DNS fix"

**Ambiguity handling:**
- For example, if they said "my-app", try:
  1. Directory: `/home/evan/coding/my-app`
  2. Workspace ID: `my-app`
- If neither exists, ask user: "Create new session in my-app as directory or workspace?"

#### Option B: Send to existing session

If user said "add to X", "continue in X", "most recent X", or "latest X chat":

```bash
# List sessions for that project/workspace
curl -s "$OPENCODE_HOST/session?directory=/home/evan/coding/$PROJECT&limit=10" | jq -r '.[0].id'
```

**Ambiguity handling:**
- For example, if they said "my-app", try:
  1. Directory: `/home/evan/coding/my-app`
  2. Workspace ID: `my-app`
- If no sessions found, ask user: "No recent sessions found for my-app. Create a new one?"

**Most recent across all projects:**
```bash
curl -s "$OPENCODE_HOST/session?limit=10" | jq -r '.[0].id'
```

### 4. Send the message

Use the **async** endpoint to avoid holding open a streaming connection:

```bash
SESSION_ID="ses_xxxxx"
SUMMARY=$(cat <<'EOF'
Context from debugging session:

[Your LLM-generated summary here]
EOF
)

curl -s -X POST "$OPENCODE_HOST/session/$SESSION_ID/prompt_async" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg text "$SUMMARY" '{
    parts: [{
      type: "text",
      text: $text
    }]
  }')"
```

**Why `prompt_async`?**
- Returns immediately with 204 No Content (fire-and-forget)
- Doesn't hold open a streaming connection waiting for AI response
- The session will process the message in the background
- Use `/message` endpoint only if you need to wait for and parse the AI's response

**Response handling:**
- 204 = success (message queued)
- Report the session ID so user can reference it

### 5. Confirm to user

**On success:**
```
✓ Context sent to session ses_xxxxx (ansible-personal)
  
  The assistant acknowledged: "Got it! I'll implement the systemd-resolved 
  configuration in the ansible playbook..."
```

**On failure:**
```
✗ Failed to send context: [error message]

Troubleshooting:
- Check OPENCODE_HOST is set correctly: $OPENCODE_HOST
- Verify opencode server is running: systemctl --user status opencode
- Try listing sessions: curl -s "$OPENCODE_HOST/session?limit=5"
```

## Advanced Usage

### List available sessions

Help user pick a destination:

```bash
# Show recent sessions with their projects
curl -s "$OPENCODE_HOST/session?limit=10" | \
  jq -r '.[] | "\(.id) | \(.title) | \(.directory // "no dir")"' | \
  column -t -s '|'
```

### Send to specific session ID

If user provides explicit session ID:

```bash
curl -s -X POST "$OPENCODE_HOST/session/ses_xxxxx/message" ...
```

### Check session exists before sending

```bash
SESSION_ID="ses_xxxxx"
if ! curl -s "$OPENCODE_HOST/session/$SESSION_ID" | jq -e '.id' >/dev/null 2>&1; then
  echo "Session $SESSION_ID not found"
  exit 1
fi
```

## API Reference Quick Guide

These are the most useful endpoints for this skill. For full API documentation:

```bash
# Get OpenAPI spec
curl -s "$OPENCODE_HOST/doc" | toonify

# List all endpoints
curl -s "$OPENCODE_HOST/doc" | jq -r '.paths | keys[]'

# Get specific endpoint details
curl -s "$OPENCODE_HOST/doc" | jq '.paths["/session"]' | toonify
```

### Key Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/session` | GET | List sessions (filter by `directory`, `workspace`, `search`, `limit`) |
| `/session` | POST | Create new session (query: `directory`, `workspace`; body: `title`, `parentID`) |
| `/session/{sessionID}` | GET | Get session details |
| `/session/{sessionID}/message` | GET | Get all messages in session |
| `/session/{sessionID}/message` | POST | Send message to session (body: `parts` array) |
| `/experimental/session` | GET | List sessions across all projects with advanced filters |

### Message Part Types

When sending messages, `parts` is an array of objects. Most common types:

```json
{
  "parts": [
    {
      "type": "text",
      "text": "Your message here"
    },
    {
      "type": "file", 
      "path": "/absolute/path/to/file"
    }
  ]
}
```

## Error Handling

| Situation | Action |
|-----------|--------|
| No sessions found for project | Ask user if they want to create new session |
| Multiple sessions match ambiguous name | List them and ask user to pick one |
| OPENCODE_HOST not set | Use default `http://localhost:9995` |
| Server not responding | Check `systemctl --user status opencode`, suggest restart |
| API returns 404 for session | Session may have been deleted, list available sessions |
| API returns 500 | Show error details, suggest checking server logs |

## Examples

### Example 1: Send to project (default: NEW session)

**User:** "send the DNS fix context to my ansible-personal chat"

**You:**
1. Recognize "send to" pattern → DEFAULT to creating NEW session
2. Summarize the DNS findings from current conversation
3. Generate title: "Tailscale DNS fix"
4. `curl -X POST "$OPENCODE_HOST/session?directory=/home/evan/coding/ansible-personal" -d '{"title": "Tailscale DNS fix"}'`
5. Get new session ID from response
6. Send summary to new session using `prompt_async`
7. Report success with session ID

### Example 2: Add to recent session (explicit)

**User:** "add this context to my most recent ansible-personal chat"

**You:**
1. Recognize "add to" + "most recent" → FIND existing session
2. Summarize the relevant context
3. `curl -s "$OPENCODE_HOST/session?directory=/home/evan/coding/ansible-personal&limit=1"`
4. Extract session ID: `ses_xxxxx`
5. Send POST with summary to `/session/ses_xxxxx/prompt_async`
6. Report success with session ID

### Example 3: Explicit new session

**User:** "create a new session in dots-personal with this bug info"

**You:**
1. Recognize explicit "create new session"
2. Summarize the bug details
3. Generate title: "Bug fix from debugging"
4. `curl -X POST "$OPENCODE_HOST/session?workspace=dots-personal" -d '{"title": "Bug fix from debugging"}'`
5. Get new session ID from response
6. Send summary to new session using `prompt_async`
7. Report success

### Example 4: Ambiguous target resolution

**User:** "send this to my web-app chat"

**You:**
1. Recognize "send to" → DEFAULT to NEW session
2. Try directory: `/home/evan/coding/web-app`
3. If directory doesn't exist, try workspace: `web-app`
4. If neither exists, ask: "I couldn't find web-app as a directory or workspace. Where should I create the new session?"

## Notes

- **Always summarize** — don't try to export/import full conversation history
- **Confirm before sending** — show the summary and ask "Send this context to [destination]?"
- **Session IDs** start with `ses_` and are returned by most API calls
- **Message IDs** start with `msg_` (not needed for basic context sharing)
- **The API streams responses** when posting messages, but we typically just need confirmation it worked
- **jq is your friend** for parsing JSON responses from the API

## Expanding This Skill

The opencode server API is extensive. To explore more capabilities:

```bash
# Download full OpenAPI spec
curl -s "$OPENCODE_HOST/doc" | toonify

# List all endpoints
curl -s "$OPENCODE_HOST/doc" | jq -r '.paths | keys[]'

# Get specific endpoint details
curl -s "$OPENCODE_HOST/doc" | jq '.paths["/session"]' | toonify

# List session-related endpoints
curl -s "$OPENCODE_HOST/doc" | jq -r '.paths | keys[] | select(contains("session"))'

# Get parameter details
curl -s "$OPENCODE_HOST/doc" | jq '.paths["/session"].get.parameters' | toonify
```

**Potential enhancements:**
- Session forking: `POST /session/{sessionID}/fork` to create child session with full history
- Session summarization: `POST /session/{sessionID}/summarize` to AI-compact history before sharing
- File attachments: Include file parts in message for code references
- Workspace management: `GET /experimental/workspace` to list/create workspaces
- Search sessions by title: Use `search` parameter in session list endpoint
