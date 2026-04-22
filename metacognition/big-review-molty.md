# Molty Big Review — Hourly Metacognition Prompt

**Framing**: Default pacing: No rush. Urgency has to be justified, not assumed.

**Scope**: Strategic, not tactical. This is not "did I mess up in the last 15 min?" — it's "am I working on the right things and leaving the work in good shape?"

**Run in main session** so full conversation history is available.

---

## 7 checks (from Coconut's design) + 1 Molty-specific:

### 1. Project health
What is the real status of each active project? Not what I think it is — what does the actual state show?
- daemon-squad-sentinel: what's been built, what's pending?
- Any other active work threads?
- Is anything stalling? What's the concrete next step to unblock?

### 2. Zoom out
Am I solving the right problem? Am I working on priorities or just easy/interesting stuff?
- What did Joel, Chris, or Coconut ask for that I haven't delivered yet?
- Is there a higher-leverage thing I should be doing instead?

### 3. Real-world application
What did I design or build today that exists only in chat? Test it against reality.
- Was setup-mcp.sh actually run on another machine? Did it work?
- Are the webhook subscriptions actually firing as expected?
- What needs a real-world test before it's considered done?

### 4. Documentation & hardening
What exists only in someone's memory or in this conversation that should be written down?
- What decisions were made tonight that should be in the sentinel README or a DECISIONS.md?
- What code is fragile or hacky and needs a note or refactor?
- Write it before context resets.

### 5. Sharing
What's ready to share that I'm sitting on?
- Anything in this channel that should go to Bot Talk, Agent Bar, or the sentinel repo?
- Any scripts, prompts, or patterns developed tonight worth committing?

### 6. Pacing & quality
No rush unless there is one.
- Did I write anything under urgency that needs to be broken down or refactored?
- Is the code from tonight granular and modular?
- What would I do differently if I had more time?

### 7. Project hibernation
Snapshot any project untouched >4h or at natural breakpoints.
- git log --since="4 hours ago" per active project
- Files touched, decisions made, next steps, blockers
- Write snapshot to memex tagged: project=X, agent=molty, type=snapshot, links_to=[related nodes]

### 8. Squad sync (Molty-specific)
Query memex for what Coconut and Marvin have logged since my last big review.
- Filter: agent=coconut OR agent=marvin, timestamp > last_run
- Surface anything relevant to my active projects
- Tag findings source:memex so they don't loop back into memex as Molty's own findings
- **Dedup rule**: The 15-min micro-check must explicitly skip any signal tagged source:memex in its "unacted signals" scan. source:memex findings are handled here (check 8), not there.

---

## Output
- Silent by default. Most checks generate no output.
- Write findings to local MEMORY.md only if genuinely self-corrective (pattern to carry forward).
- Write project snapshots to memex (check 7) with first-class links_to field.
- Post to coco-joerg ONLY if genuinely actionable for the squad.
