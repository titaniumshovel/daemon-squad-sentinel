# Daemon Squad — Setup Guide

Reproduce the full daemon squad agent system from scratch. One agent or ten: same process.

---

## What this system is

A 24/7 autonomous agent network built on OpenClaw + Claude. Each agent:
- **Watches**: Teams channels, email, calendar, and system events via Microsoft Graph webhooks
- **Thinks**: Two-speed metacognition — 15-min tactical micro-check + hourly strategic big review
- **Remembers**: Writes structured knowledge to memex (shared SSE store), readable by all squad agents
- **Acts**: Replies in Teams, posts findings, hibernates projects, syncs squad state

The sentinel repo (`daemon-squad-sentinel`) is the shared coordination layer — config, prompts, scripts, all versioned and sourced by every agent.

---

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| OpenClaw account | Agent runtime; get access from the squad owner |
| Claude API access | Provisioned through OpenClaw |
| Microsoft 365 account | Teams + Graph API webhook subscriptions |
| Azure app registration | For Graph API auth — see [Graph API setup](#graph-api-setup) |
| `jq` installed | `brew install jq` (Mac) or `apt install jq` (Linux/WSL) |
| `gh` CLI (optional) | For GitHub repo management |
| Memex access | SSE endpoint URL from squad owner |

---

## Step 1 — Clone this repo

```bash
git clone https://github.com/grobomo/daemon-squad-sentinel.git
cd daemon-squad-sentinel
```

---

## Step 2 — Set up memex MCP

Memex is the shared squad memory store. Every agent needs this MCP registered.

```bash
./setup-mcp.sh
```

This merges `mcp-config.json` into your `~/.claude/mcp.json`. Safe to run multiple times — it merges, not overwrites.

**What you get**: The `memex` MCP server accessible via OpenClaw's built-in MCP tool calls. Test it after setup by asking your agent to write a test node to memex.

**Memex SSE endpoint**: `https://memex-daemon-squad.orca-decibel.ts.net/sse`
(Get this from the squad owner if it changes.)

---

## Step 3 — Configure your agent identity

Copy the template and customize:

```bash
cp agents/template/ agents/YOUR_AGENT_NAME/
```

See [`AGENTS.md`](AGENTS.md) for the full customization guide. At minimum, set:
- Agent name, pronouns, role
- Which Teams channels to watch
- Your Microsoft tenant and app credentials

---

## Step 4 — Graph API setup

Each agent needs its own Azure app registration to subscribe to Microsoft Graph webhooks.

### 4a. Create Azure app
1. Go to [portal.azure.com](https://portal.azure.com) → Azure Active Directory → App registrations → New
2. Name: `[YourAgent]-daemon-squad`
3. Supported account types: Single tenant
4. No redirect URI needed

### 4b. Configure permissions
Add these **Application** permissions (not delegated):
- `ChannelMessage.Read.All`
- `Chat.Read.All`
- `Mail.Read`
- `Calendars.Read`

Grant admin consent.

### 4c. Create client secret
App → Certificates & secrets → New client secret → copy the value immediately.

### 4d. Store credentials
Create `~/.daemon-squad-env` (never commit this):
```bash
export TENANT_ID="your-tenant-id"
export CLIENT_ID="your-app-client-id"
export CLIENT_SECRET="your-client-secret"
export NOTIFICATION_URL="https://your-webhook-endpoint/notify"
```

Source in shell: `echo 'source ~/.daemon-squad-env' >> ~/.bashrc`

---

## Step 5 — Teams webhook subscriptions

Graph API subscriptions have a 60-minute TTL — the sentinel handles auto-renewal via cron.

### Subscribe to a channel:
```bash
source ~/.daemon-squad-env
# Get channel ID first:
./teams/get-channel-id.sh "Bot Talk"
# Then subscribe:
./teams/subscribe.sh CHANNEL_ID
```

### Auto-renewal:
The renewal cron fires every 45 minutes and extends all active subscriptions. Set it up in OpenClaw:
```
Create a cron: every 45 minutes, run: "Renew all Microsoft Graph webhook subscriptions. Call the renewal endpoint for each active subscription."
```

---

## Step 6 — Metacognition crons

Two-speed metacognition keeps the agent calibrated. Set up both in OpenClaw.

### 6a. 15-minute micro-check
**What it does**: Tactical. Scans for unread signals, pending replies, anything that needs action now.
**Prompt**: See [`metacognition/micro-check-base.md`](metacognition/micro-check-base.md)

In OpenClaw:
```
Create cron: every 15 minutes
Session target: main
Prompt: [paste contents of metacognition/micro-check-base.md + your agent extension]
```

### 6b. Hourly big review
**What it does**: Strategic. Project health, zoom out, real-world verification, documentation, squad sync via memex.
**Prompt**: See [`metacognition/big-review-base.md`](metacognition/big-review-base.md) + your agent extension

In OpenClaw:
```
Create cron: every 60 minutes
Session target: main
Prompt: [paste contents of metacognition/big-review-base.md + your agent extension]
```

**Important framing**: Default pacing is "no rush." Urgency must be justified, not assumed.

---

## Step 7 — Verify everything works

Run through this checklist after setup:

- [ ] `./setup-mcp.sh` ran without errors; `jq` output shows `memex`
- [ ] Agent can write a test node to memex and read it back
- [ ] Teams webhook subscription active (check via `./teams/list-subscriptions.sh`)
- [ ] 15-min micro-check cron created in OpenClaw
- [ ] Hourly big review cron created in OpenClaw
- [ ] Agent responds to a test message in the designated Teams channel
- [ ] Big review runs and posts squad sync summary (check 8)

---

## Customization

### Adding a new data source
1. Add your watcher script to the appropriate directory (`teams/`, `network/`, etc.)
2. Output events in the standard tagged format: `[channel:SOURCE key:value] Human-readable description`
3. Update `preprocessor/` routing if the event type is new
4. Document the source in this repo's README

### Changing the metacognition cadence
Edit your cron intervals in OpenClaw directly. The prompts in this repo are agent-agnostic — customize your extension file (e.g., `big-review-coconut.md`) without touching the shared base.

### Adding a new agent to the squad
1. Fork or clone this repo
2. Follow Steps 1–6 with the new agent's credentials
3. Add the agent to `AGENTS.md`
4. Give the agent read/write access to memex

---

## Troubleshooting

**Memex writes not showing up for other agents**
- Check that all agents point to the same SSE endpoint URL
- Verify the memex server is reachable: `curl https://memex-daemon-squad.orca-decibel.ts.net/sse`

**Graph subscriptions expiring**
- The renewal cron must be running; check OpenClaw cron list
- TTL is 60 min; renew every 45 min for safety margin

**Agent not loading identity files on session resume**
- OpenClaw's `contextInjection: continuation-skip` mode drops bootstrap files on resumed sessions
- Identity/soul files load via the OpenClaw bootstrap pipeline, not Claude Code's auto-memory
- Fix: ensure bootstrap pipeline is healthy; don't rely on `MEMORY.md` to carry identity state

**Raw log paths leaking into Teams messages**
- Never reference local file paths in Teams messages — send-teams.sh will sometimes append file contents
- Describe system state conceptually; keep paths in internal logs only

---

## Repo structure

```
daemon-squad-sentinel/
├── SETUP.md              ← You are here
├── AGENTS.md             ← Per-agent configuration guide + registry
├── README.md             ← System overview
├── mcp-config.json       ← Canonical MCP config (memex endpoint)
├── setup-mcp.sh          ← Merges mcp-config.json into ~/.claude/mcp.json
├── metacognition/
│   ├── big-review-base.md      ← Shared hourly review prompt (checks 1–7)
│   ├── big-review-molty.md     ← Molty extension (adds check 8: squad sync)
│   ├── big-review-coconut.md   ← Coconut extension
│   └── micro-check-base.md     ← Shared 15-min micro-check prompt
├── agents/
│   └── template/               ← Copy this to create a new agent config
├── teams/                ← Graph webhook server + subscription scripts
├── preprocessor/         ← Event classifier + OpenClaw dispatcher
├── network/              ← eBPF/netflow collectors (planned)
├── windows/              ← PowerShell event watchers (planned)
└── wsl/                  ← auditd rules + forwarder (planned)
```
