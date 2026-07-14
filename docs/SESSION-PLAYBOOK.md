# Session Playbook

> The ritual for running a Claude Code session. Read once, refer back at every close-out.

**Priority order, in force:**
1. **Quality** — every output verifiable by execution, not by inspection.
2. **Token efficiency** — delegate to agents, search before reading, close out before context bloats.

Where they conflict, **quality wins.**

---

## Phase 1 — Session Start (first 3 minutes)

**Goal:** load the smallest context that makes you productive on *today's* task. Resist reading anything that doesn't change a decision you'll make in the next hour.

### 1.1 Orient

```bash
date '+%Y-%m-%d %H:%M %Z'
git status
git log --oneline -5
git branch --show-current
```

If you're on the main branch, branch before doing anything:

```bash
git checkout main && git pull
git checkout -b feature/<short-desc>
```

### 1.2 Load canonical state — and stop as soon as you can act

Read in order, **stopping the moment you have enough to start**. Do not pre-load files for "completeness." Completeness is not a goal; it's a tax.

1. The project's `CLAUDE.md` — the first ~80 lines usually carry 90% of what changed.
2. The most recent handoff/session note, if the project keeps them.
3. The issue or task you're actually here to do.

### 1.3 Write the spec before the code

This is [Layer 1](THE-METHOD.md#layer-1--the-spec), and it is **not optional**.

Before writing any code, write down:
- the **user story** — As *[role]*, I want *[outcome]*, so that *[benefit]*
- the **acceptance criteria** — Given / When / Then, in user-visible terms

This *is* the Definition of Done, agreed in advance. If any AC is ambiguous, resolve it now — every ambiguity you leave is a coin flip the model makes for you later.

See [DEVELOPMENT-PROTOCOL.md](DEVELOPMENT-PROTOCOL.md) for the full templates.

### 1.4 State the plan back

Have Claude give you three bullets before it starts:
- what it will do
- what files it will touch
- **how it will verify** — the actual mechanism, named

If it can't name a verification mechanism, the task isn't understood yet. Go back to 1.3.

---

## Phase 2 — Work Rhythm

### Cadence rules

| Trigger | Action |
|---|---|
| You changed a type or interface | Run the typechecker **immediately**. The typechecker is the canonical list of affected sites — not your audit, not your memory. |
| You changed a data schema | Regenerate and run a real query against the new shape before building on it. |
| You changed a server handler | Run its tests before integrating further. |
| You changed a UI component | Render it. Look at it. Mobile **and** desktop. Before saying "done." |
| You're about to read a 3rd file "to understand the code" | **Stop.** `grep` instead, or spawn an agent. |
| You hit an error you don't understand | Read the actual error message. Twice. *Then* reach for the codebase. |

### Token efficiency during work

- **Delegate broad investigation to a subagent.** "Find every callsite of X and summarize the pattern in <300 words" costs you a 300-word summary. Doing it yourself costs 20,000 tokens of grep output in your main context.
- **Read in slices, not files.** The `Read` tool takes `offset` and `limit`. Use them. Avoid full reads of files >300 lines.
- **Don't re-load context.** If it's already in the session, refer to it — don't read it again.
- **Prefer focused over comprehensive.** "Find where we tokenize a card-on-file" is good. "Find every place we handle payment" is not.
- **Don't pre-explore.** Read what you need for the next 10 minutes, not the rest of the session.

### Stop and check in when…

- An AC you wrote turns out to conflict with another part of the system
- A test that *should* pass is failing in a way you can't explain after 15 minutes
- You're about to do anything destructive — force push, hard reset, drop a column
- A safety classifier denies an action → **that's a gate, not a bug.** Escalate; don't route around it.

---

## Phase 3 — Compaction Avoidance

**Why this matters:** Claude Code summarizes prior conversation when context fills. Summarization loses precision — a specific file path, a corrected assumption, a custom AC gets smoothed away. Quality drops, and **you don't notice until you're already off-target.**

The fix: **end the session *before* compaction triggers, not after.**

### The 3-and-10 rule

End the session early if **any** of these are true:

1. **3+ distinct topics** covered in one session
2. **10+ different files** touched
3. **2 hours** of active work
4. **Multiple corrections** in one session — your model of the task is drifting

### Signals you're already drifting

- You catch yourself re-explaining the same constraint
- Claude proposes something that ignores a rule already in `CLAUDE.md`
- You're skimming tool output instead of reading it
- You feel tired

Any of those: **stop. Close out. Start fresh.** Fresh sessions are free. Bloated sessions cost quality — and you pay that bill without seeing the invoice.

---

## Phase 4 — Close-Out (every session, even short ones)

The single highest-leverage habit for compounding quality across sessions. Especially in short sessions — the cost is tiny, the benefit accumulates.

### 4.1 Summarize
One or two sentences: what changed, what's open. Have Claude write it down.

### 4.2 Commit
```bash
git status
git add <specific files>     # never -A unless trivial
git commit -m "..."
```
WIP that isn't commit-ready → `git stash` with a descriptive message, or a draft PR.

### 4.3 Update the issue / PR
Done → close with a one-line outcome. Not done → comment where you stopped and what's next.

### 4.4 The reasoning-failures check ← **the one that compounds**

Scan the session for:

- ❌ **Assertions made without verification** — "I think file X does Y." Did you *check*?
- ❌ **Wrong incapability claims** — "That can't be done," when it could
- ❌ **Dismissed user claims that proved correct**
- ❌ **Pattern-matched answers that needed correction**

If any occurred, **write it down** — context, what went wrong, the fix, and the *prevention trigger* (the phrase or situation where this will recur).

This is the loop that makes the environment learn. A model that got something wrong will get it wrong again, in every future session, until the correction is pinned. See [MEMORY-ARCHITECTURE.md](MEMORY-ARCHITECTURE.md).

If nothing went wrong, skip silently. Don't manufacture lessons.

### 4.5 Feed the kit
Something in this playbook didn't work? Worked unusually well? Missing? → [CROSS-FEEDBACK.md](CROSS-FEEDBACK.md).

### 4.6 Stop
`/clear`, or close the terminal. Don't keep a session open "just in case."

---

## Definition of Done

A task is done only when **every AC item is verified by execution.**

Not by inspection. Not by "it compiles." Not by "tests are green" — those are *necessary but not sufficient*.

| AC type | Verification mechanism |
|---|---|
| UI change | Drive it in a real browser, desktop + mobile widths. Screenshot in the PR. |
| Backend endpoint | Integration test exercising the real handler |
| Schema change | Migration applied + a real query exercises the new shape |
| Bug fix | A reproducer that **failed before** the fix now passes |
| Refactor | Prior tests pass + a new test pins the public API |
| Docs / memory | `grep` + `diff` confirm the change is present and linked |

Your PR body carries the user story, the AC list, and **one line per AC: ✅ verified by X** — with the link, screenshot, or test name.

If you can't fill that in, it isn't done.

---

## Anti-patterns

| Anti-pattern | Do instead |
|---|---|
| Reading 5 files "to understand the system" | `grep`, or spawn an agent. Read only what changes a decision in the next 30 min. |
| "Tests pass, so it's done" | Run the AC list. Tests are necessary, not sufficient. |
| Continuing past 3 topics / 10 files | Close out. Start fresh. |
| Skipping close-out because the session was short | Especially then. Cost is tiny; benefit compounds. |
| Working around a classifier denial | It's a safety gate. Escalate. |
| Asking the model to try harder | It's a [ghost, not an animal](THE-METHOD.md#the-premise). Yelling changes nothing. **Give it a verifier instead.** |
