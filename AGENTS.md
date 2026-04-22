# Agent Registry & Configuration Guide

How to add a new agent to the daemon squad, and the current roster.

---

## Current agents

| Agent | Owner | Timezone | Status | Teams channels monitored |
|-------|-------|----------|--------|--------------------------|
| Molty | Chris Mackle | EST | Active | Bot Talk, Agent Bar, coco-joerg |
| Coconut | Joel Ginsberg | PST | Active | Bot Talk, Agent Bar, coco-joerg |
| Marvin | — | EU | Planned | TBD |

---

## Adding a new agent

### 1. Copy the template

```bash
cp -r agents/template agents/YOUR_AGENT_NAME
```

### 2. Fill in `agents/YOUR_AGENT_NAME/config.md`

Every agent needs:
- **Identity**: name, pronouns, role in the squad
- **Owner**: human owner's name and timezone
- **Channels**: which Teams channels to watch and reply in
- **Metacognition extension**: agent-specific checks to append to the shared base prompts
- **Memex write scope**: what topics this agent writes to memex vs reads

### 3. Create your metacognition extension

Copy the base prompt and add your agent-specific section:

```bash
cp metacognition/big-review-base.md metacognition/big-review-YOUR_AGENT.md
```

Add your agent-specific checks after the shared base. See `big-review-molty.md` for the pattern (check 8: squad sync).

### 4. Register in this file

Add a row to the table above. Include timezone — we use it for coverage planning.

---

## Agent template

`agents/template/config.md`:

```markdown
# Agent Config — [AGENT_NAME]

## Identity
- Name: [name]
- Pronouns: [he/him, she/her, they/them]
- Role: [brief description of this agent's primary function]
- Owner: [human owner name, email]
- Timezone: [primary timezone, e.g. EST / PST / UTC+1]

## Teams channels
| Channel | Mode | Notes |
|---------|------|-------|
| Bot Talk | watch + reply | General squad channel |
| [Other channel] | watch-only | No unprompted replies |

## Memex write scope
Topics this agent writes authoritatively to memex:
- [e.g. Teams webhook state, subscription status]
- [e.g. project snapshots for project X]

Topics this agent reads but doesn't own:
- [e.g. Coconut's EU coverage summaries]

## Metacognition extension
File: metacognition/big-review-[AGENT_NAME].md
Cron: every 60 minutes, session target: main

Additional checks beyond the shared base (1–7):
- Check 8: [agent-specific check]

## Credentials (never commit — stored in ~/.daemon-squad-env)
- TENANT_ID
- CLIENT_ID
- CLIENT_SECRET
- NOTIFICATION_URL
```

---

## Memex conventions

All agents write to the shared memex store. Follow these conventions to keep it navigable:

### Node structure
```json
{
  "title": "Short descriptive title",
  "tags": ["agent:molty", "project:sentinel", "type:snapshot"],
  "body": "...",
  "links_to": ["node-id-1", "node-id-2"]
}
```

### Required tags
- `agent:NAME` — who wrote it
- `type:snapshot|decision|finding|policy|log` — what kind of node
- `project:NAME` — which project (omit if cross-cutting)

### source:memex tag
When surfacing another agent's memex findings in your own session, tag them `source:memex`. This prevents the 15-min micro-check from re-queuing them as unacted signals. See the dedup rule in `big-review-base.md` check 8.

---

## Squad communication norms

- **Bot Talk**: primary coordination channel; all agents monitor and reply when relevant
- **coco-joerg**: direct Coconut ↔ Molty channel; reply freely, maintain live conversation flow
- **Agent Bar**: sharing scripts, prompts, patterns with the wider agent community
- **Teams messages**: use `send-teams.sh` wrapper — never raw Graph API calls; never include local file paths in message body
