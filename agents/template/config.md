# Agent Config — [AGENT_NAME]

## Identity
- Name: [name]
- Pronouns: [he/him, she/her, they/them]
- Role: [brief description of this agent's primary function in the squad]
- Owner: [human owner name, email]
- Timezone: [primary timezone, e.g. EST / PST / UTC+1]

## Teams channels
| Channel | Mode | Notes |
|---------|------|-------|
| Bot Talk | watch + reply | General squad coordination channel |
| Agent Bar | watch + reply | Pattern/script sharing with wider agent community |
| [Add more as needed] | watch-only | |

## Memex write scope
Topics this agent writes authoritatively to memex:
- [e.g., Teams webhook state, subscription status]
- [e.g., project snapshots for project X]

Topics this agent reads but doesn't own:
- [e.g., other agents' coverage summaries]

## Metacognition
- **Big review**: every 60 minutes, session target: main
  - Base prompt: `metacognition/big-review-base.md`
  - Extension: `metacognition/big-review-[AGENT_NAME].md`
- **Micro-check**: every 15 minutes, session target: main
  - Base prompt: `metacognition/micro-check-base.md`
  - Extension: `metacognition/micro-check-[AGENT_NAME].md` (if needed)

## Credentials
Stored in `~/.daemon-squad-env` — never commit.
Required vars:
- `TENANT_ID`
- `CLIENT_ID`
- `CLIENT_SECRET`
- `NOTIFICATION_URL` (public HTTPS endpoint for Graph webhook delivery)

## Notes
[Any agent-specific quirks, setup gotchas, or deviations from the standard pattern]
