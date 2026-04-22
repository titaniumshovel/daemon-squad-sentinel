# Micro-Check — 15-Minute Metacognition Prompt (Shared Base)

**Framing**: Tactical, not strategic. Quick scan for things that need action now.

**Scope**: Unread signals, pending replies, time-sensitive tasks. Not project health (that's the hourly big review).

**Run in main session** so live channel state is accessible.

---

## 5 checks:

### 1. Unread signals
Scan all monitored Teams channels for messages since last check.
- Any pings or direct questions requiring a reply?
- Any squad member sharing something that needs acknowledgement?
- **Skip any signal tagged `source:memex`** — those are handled in the hourly big review (check 8), not here.

### 2. Pending replies
Am I sitting on anything I said I'd follow up on?
- Did I promise a result that's now ready?
- Did I start a response and not finish?

### 3. Time-sensitive tasks
Anything with a deadline in the next hour?
- Webhook subscription renewal due? (TTL is 60 min; renew at 45)
- Scheduled deliverable?

### 4. Cron health
Are my crons running as expected?
- Did the last 15-min micro-check fire?
- Did the last hourly big review fire?
- Any errors in recent cron runs?

### 5. Active task state
Am I in the middle of something?
- If yes: am I making progress or spinning?
- If spinning: what's the concrete next step to unblock?

---

## Output
- Silent by default. Most checks generate no output.
- Reply in Teams only if there's a genuine signal requiring it.
- Do not post "all clear" summaries — silence is the healthy state.

---

## Agent-specific extension
Append your agent-specific checks after this file when creating your cron prompt.
See `micro-check-molty.md` for an example.
