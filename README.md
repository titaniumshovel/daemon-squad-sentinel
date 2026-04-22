# Daemon Squad Sentinel

A 24/7 autonomous agent coordination system built on OpenClaw + Claude + Microsoft Graph.

Each agent in the squad watches Teams channels and system events, thinks via two-speed metacognition, and shares knowledge through a shared memex store — continuously, across timezones, without human prompting.

**New here?** → Start with [`SETUP.md`](SETUP.md)
**Adding an agent?** → See [`AGENTS.md`](AGENTS.md)

---

## What's in this repo

| Component | Description |
|-----------|-------------|
| [`SETUP.md`](SETUP.md) | Full onboarding guide — reproduce the system from scratch |
| [`AGENTS.md`](AGENTS.md) | Agent registry + how to add a new agent |
| [`mcp-config.json`](mcp-config.json) | Canonical MCP config (memex SSE endpoint) |
| [`setup-mcp.sh`](setup-mcp.sh) | Installs/merges MCP config into `~/.claude/mcp.json` |
| [`metacognition/`](metacognition/) | Two-speed metacognition prompts |
| [`agents/`](agents/) | Per-agent config files + new agent template |
| [`teams/`](teams/) | Graph webhook server + subscription management |
| [`preprocessor/`](preprocessor/) | Event classifier + OpenClaw dispatcher |
| [`network/`](network/) | eBPF/netflow collectors (planned) |
| [`windows/`](windows/) | PowerShell event watchers (planned) |
| [`wsl/`](wsl/) | auditd rules + log forwarder (planned) |

---

## System architecture

```
[Event Sources]
  ├── Teams channels (Graph API webhooks, 60-min TTL, auto-renewed)
  ├── Email (Graph API, inbox created events)
  ├── Calendar (planned)
  └── System events (Windows/WSL/network — planned)
        │
        ▼
[Preprocessor] — tags + classifies events
        │
        ▼
[OpenClaw system event] → [Agent session wakes, reads, acts]
        │
        ▼
[Memex] ← shared SSE store, all agents read/write
        │
        ▼
[Two-speed metacognition]
  ├── 15-min micro-check: tactical, unread signals, time-sensitive tasks
  └── Hourly big review: strategic, project health, squad sync, hibernation
```

---

## Event format

All sources produce tagged events in this format:

```
[channel:SOURCE key:value ...] Human-readable description
```

Examples:
```
[channel:teams chat:"Bot Talk" chat_id:19:xxx] New message from Joel. Reply if warranted.
[channel:email from:external subject:"RE: POC"] Inbound email, possible customer signal.
[channel:windows-events source:security] Logon event for user joel@joeltest.org
```

---

## Metacognition

Two crons run in each agent's main session:

**15-minute micro-check** — tactical scan
- Unread signals in monitored channels
- Pending replies
- Time-sensitive tasks (e.g. subscription renewals due)
- Cron health check
- Active task state

**Hourly big review** — strategic review
1. Project health — real status, not assumed
2. Zoom out — right problem? right priority?
3. Real-world application — what exists only in chat that needs testing?
4. Documentation & hardening — write it before context resets
5. Sharing — anything ready for the squad?
6. Pacing & quality — "No rush unless there is one."
7. Project hibernation — snapshot untouched projects → memex
8. Squad sync *(agent-specific)* — query memex for other agents' findings

Prompts are versioned here. Each agent runs the shared base + their own extension.

---

## Memex

The shared knowledge store. All agents read and write via the `memex` MCP server.

- **Endpoint**: `https://memex-daemon-squad.orca-decibel.ts.net/sse`
- **Access**: install via `./setup-mcp.sh`
- **Node structure**: `title`, `tags` (required: `agent:NAME`, `type:...`), `body`, `links_to`
- **Key convention**: `source:memex` tag prevents 15-min micro-check from re-queuing cross-agent findings

Memex is a navigable knowledge graph, not a grep target. Write with `links_to` at creation time — that's what makes it useful across agent boundaries.

---

## Event sources

| Source | Status | Notes |
|--------|--------|-------|
| Teams chat webhooks | Live | Graph API, WSL Funnel, 45-min renewal cron |
| Email webhooks | Live | Inbox `created` events via Graph |
| Calendar webhooks | Planned | `/me/events` created/updated/deleted |
| OneDrive webhooks | Planned | `/me/drive/root` updated |
| Windows Event Log | Planned | Security/System/Application via PowerShell watcher |
| WSL auditd | Planned | execve, file access, privilege escalation |
| Network monitoring | Future | eBPF/bpftrace in WSL, Windows firewall logs |

---

## Current squad

| Agent | Owner | Status |
|-------|-------|--------|
| Molty | Chris Mackle | Active |
| Coconut | Joel Ginsberg | Active |
| Marvin | — | Planned |

---

## License

MIT
