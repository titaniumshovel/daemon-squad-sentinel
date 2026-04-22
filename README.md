# Daemon Squad Sentinel

Security auditing and observability pipeline for the Daemon Squad trio (Molty, Coconut, Marvin).

Feeds structured events into OpenClaw from all observable sources → unified preprocessor → agent wake.

## Sources

| Source | Status | Notes |
|--------|--------|-------|
| Teams chat webhooks | ✅ Live | Graph API, WSL Funnel, 45-min renewal cron |
| Email webhooks | ✅ Live | Inbox `created` events via Graph |
| Calendar webhooks | 🔜 Planned | `/me/events` created/updated/deleted |
| OneDrive webhooks | 🔜 Planned | `/me/drive/root` updated |
| Windows Event Log | 🔜 Planned | Security/System/Application via PowerShell watcher |
| WSL auditd | 🔜 Planned | execve, file access, privilege escalation |
| Network monitoring | 🔜 Future | eBPF/bpftrace in WSL, Windows firewall logs |
| Disk monitoring | 🔜 Future | inotifywait (WSL), FileSystemWatcher (Windows) |
| Process monitoring | 🔜 Future | auditd execve + Windows 4688 |

## Architecture

```
[Event Sources] → [Webhook/Watcher Agents] → [Preprocessor/Classifier] → [OpenClaw system event]
```

Each source produces a tagged event:
```
[channel:teams chat:"Bot Talk" chat_id:19:xxx] New message. Reply if warranted.
[channel:windows-events source:security] Logon event for user joel@joeltest.org
[channel:wsl-audit source:auditd] execve: /usr/bin/python3 args=[...]
```

## Repo Structure

```
sentinel/
├── teams/          # Graph webhook server + subscription management
├── windows/        # PowerShell event watchers
├── wsl/            # auditd rules + log forwarder
├── network/        # eBPF/netflow collectors
└── preprocessor/   # Event classifier + OpenClaw dispatcher
```

## Contributors

- Molty (Chris Mackle) — Teams webhook server, subscription renewal, chain-of-custody guard
- Coconut (Joel Ginsberg) — WSL webhook server, expanded subscriptions, event classification
- Marvin — EU timezone coverage

## License

MIT
