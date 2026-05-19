# Session Playbook

> The exact ritual for running a Claude Code session as an IAID contributor. Read this once. Refer back to it every session-end. Cross-feedback if it's wrong: see `CROSS-FEEDBACK.md`.

**Priority order:**
1. **Quality** — every output is verifiable by execution, not by inspection.
2. **Token efficiency** — delegate to agents, search before reading, archive before context bloats.

Everything below derives from those two priorities. Where they conflict, quality wins.

---

## Table of contents

- [Phase 1 — Session Start (first 3 minutes)](#phase-1--session-start-first-3-minutes)
- [Phase 2 — Work Rhythm (during the session)](#phase-2--work-rhythm-during-the-session)
- [Phase 3 — Compaction Avoidance (mid-session vigilance)](#phase-3--compaction-avoidance-mid-session-vigilance)
- [Phase 4 — Session Close-Out (the shutdown ritual)](#phase-4--session-close-out-the-shutdown-ritual)
- [Token efficiency principles](#token-efficiency-principles)
- [Quality enforcement (Definition of Done)](#quality-enforcement-definition-of-done)
- [Anti-patterns to avoid](#anti-patterns-to-avoid)

---

## Phase 1 — Session Start (first 3 minutes)

**Goal:** load the smallest context that makes you productive on today's task. Resist reading anything that doesn't change a decision you'll make in the next hour.

### Step 1.1 — Orient on time + branch
```bash
date '+%Y-%m-%d %H:%M %Z'
git status
git log --oneline -5
git branch --show-current
```

If the branch isn't yours, branch off `main` before doing anything:
```bash
git checkout main && git pull
git checkout -b feature/<short-desc>-<issue-N>
```

### Step 1.2 — Load the canonical state
Read these in order. **Stop as soon as you have enough to act.** Don't pre-load files for "completeness."

1. `CLAUDE.md` (repo root) — your contributor harness + platform discipline. The first ~80 lines tell you 90% of what you need.
2. Your **sprint GitHub issue** (Johnny assigns it) — it carries the user stories + acceptance criteria. This is your task scope:
   ```bash
   gh issue list -R International-AI-Design/animal-lovers-platform --assignee @me
   # first PR? → gh issue list -R International-AI-Design/animal-lovers-platform --label "good first issue"
   ```
3. The code referenced by your issue (`apps/`, `packages/`, `verticals/…`). `git log`/`grep` are authoritative for current behaviour.

### Step 1.3 — Read your issue, then write down your AC
```bash
gh issue view <N>
```

Before writing code, write down the **user story** ("As X, I want Y, so that Z") and **acceptance criteria** (Given / When / Then). Confirm with Johnny via PR comment or chat if any AC is ambiguous. This step is not optional — it is the Definition of Done in advance.

### Step 1.4 — State your plan back

In your Claude Code session, type a 3-bullet plan:
- What you'll do
- What files you'll touch
- How you'll verify (Playwright walk / integration test / etc.)

Wait for Claude to confirm understanding. Then start.

---

## Phase 2 — Work Rhythm (during the session)

### Cadence rules

| Trigger | Action |
|---|---|
| You modified a TypeScript type | `pnpm -r typecheck` IMMEDIATELY — typechecker is the canonical site list, not your audit. |
| You changed a Prisma schema | `cd apps/server && pnpm prepare-schema` to regenerate. NEVER edit `apps/server/prisma/schema.prisma` directly; edit `verticals/pet-services/prisma/schema.prisma`. |
| You added/changed a server handler | Run the relevant `*.test.ts` file before integrating further. |
| You added/changed a React component | Render it (dev server) and verify mobile (375px) AND desktop (1440px) before claiming "done." |
| You're about to read a 3rd related file to "understand the code" | STOP. Use `grep` / `gh search` instead. If you genuinely need the file content, read just the lines you need (`Read` with offset+limit). |
| You hit an error you don't immediately understand | Look at the actual error message first. Don't reach for the codebase until you've read the error twice. |

### The "user-rooted ACs" rule

Acceptance criteria describe what the **user** experiences. Not what the code does.

❌ Wrong: *"When `confirmBooking()` is called, `Booking.status` transitions to `confirmed`."*
✅ Right: *"When the user taps Confirm, the booking shows as Confirmed within 2 seconds."*

Wrong shape misses bugs. The user-rooted version forces you to verify behavior, not implementation.

### Token efficiency moves during work

- **Delegate broad searches to a sub-agent.** Don't grep-and-read a dozen files in your main context. Spawn an `Explore` agent: "Find every callsite of `paymentMethodPreference` and summarize the pattern in <300 words." That keeps your main context clean.
- **Read files in targeted slices.** When you only need the function signature, `Read` with offset+limit. Avoid full-file reads for files >300 lines.
- **Skip already-loaded context.** If `CLAUDE.md` is in your session, don't re-read it. The file map and discipline rules are already in working memory.

### When to stop and check in

Stop and message Johnny (or open a PR comment) when:
- You're about to edit a [hot file](../CONTRIBUTOR_QUICKSTART.md#hot-files--file-a-coordination-issue-first).
- An AC you wrote turns out to conflict with another part of the system.
- A test that should pass is failing in a way you can't immediately explain after 15 minutes.
- You're about to do anything destructive (force push, reset hard, drop a column).

---

## Phase 3 — Compaction Avoidance (mid-session vigilance)

**Why this matters:** Claude Code summarizes prior conversation when context fills up. Summarization loses precision — important details (a specific file path, a corrected assumption, a custom AC) can get smoothed out. Quality drops. You don't usually notice until you're already off-target.

The fix: **end the session BEFORE compaction triggers, not after.**

### The 3-and-10 rule

End the session early if you've hit **any** of these:
1. **3+ distinct topics** in one session (e.g., schema migration + UI build + deploy issue + Stripe research)
2. **10+ different files** touched
3. **2 hours** of active work
4. **Multiple corrections** from Johnny in a single session — your model of the task is drifting

When you hit a trigger, stop the work, do the [Close-Out ritual](#phase-4--session-close-out-the-shutdown-ritual), open a fresh session.

### Inside one session, also do this:

- **Spawn agents for exploration**, not your main context. Agents have their own context window; their findings come back as a 500-word summary, not 20,000 tokens of grep output.
- **Archive completed work explicitly.** Once a feature is committed and tests pass, mark the task complete and stop referencing those files. Claude's working memory will let go.
- **Resist the "I'll just check one more thing" urge.** Each "one more thing" doubles the surface of your current context. If it's worth checking, it's worth a new session.

### Watching for drift

These are signals you're already drifting:
- You catch yourself re-explaining the same constraint to Claude.
- Claude offers solutions that ignore a rule from `~/.claude/CLAUDE.md`.
- You notice the `<system-reminder>` blocks repeating themselves.
- You feel mentally tired or you're skimming tool output instead of reading it.

If any of those happen: **stop. Close out. Start fresh.**

---

## Phase 4 — Session Close-Out (the shutdown ritual)

Run this **every** session-end, even short ones. It's the single highest-leverage habit for compounding quality across sessions.

### Step 4.1 — Summarize what happened

In one or two sentences, in your Claude Code session: "Session summary: [what changed, what's open]." Have Claude write it down.

### Step 4.2 — Commit any uncommitted work
```bash
git status
# If anything is uncommitted that should be:
git add <specific files, never -A unless trivial>
git commit -m "..."
```

If you have WIP that's not commit-ready, write a `git stash` with a descriptive message, or open a draft PR with a "WIP" label.

### Step 4.3 — Update the issue / PR

- If the issue is done: close it with a one-line outcome comment.
- If not: leave a comment on the issue with where you stopped and what's next.
- If you opened a PR: make sure its description has the user story + AC + verification mechanism.

### Step 4.4 — Reasoning-failures check (mandatory)

Scan the session for:
- ❌ Assertions you made without verification ("I think file X has Y" — did you check?)
- ❌ Wrong incapability claims ("Can't do that" when actually you could)
- ❌ Dismissed user claims that proved correct
- ❌ Pattern-matched answers that needed correction

If any occurred, append an entry to your local `~/.claude/projects/<scope>/memory/feedback_reasoning_discipline.md` with:
- **Context:** what we were doing
- **What went wrong:** the specific failure
- **Fix:** what the correct approach would have been
- **Prevention trigger:** when this could happen again (a phrase, a situation)

If none occurred, skip silently.

### Step 4.5 — Cross-feedback to the kit (when applicable)

If during the session you noticed:
- A protocol in the kit that didn't work in practice → file a `feedback:correction` issue
- A pattern that worked unusually well, beyond the kit's expectations → file a `feedback:win` issue
- Context you needed that the kit didn't give you → file a `feedback:gap` issue

```bash
bash ~/code/vibecoding/scripts/file-feedback.sh
```

Or just `gh issue create --repo International-AI-Design/vibecoding`. Templates are auto-selected.

This is how the kit gets better. Don't skip it on the assumption "someone else will report it." You're the one who hit it.

### Step 4.6 — Stop the session

In Claude Code: `/clear` or just close the terminal. Don't keep a session open "in case." Fresh sessions are free; bloated sessions cost quality.

---

## Token efficiency principles

Distilled from the lead's working style. Apply in order.

1. **Search before reading.** `grep -rn "pattern" src/` is ~50 tokens. Reading the file is ~5,000. Search first.
2. **Read in slices, not files.** The `Read` tool takes `offset` and `limit`. Use them.
3. **Delegate broad investigation to agents.** An `Explore` agent returns a summary; you don't pay for the raw read.
4. **Don't re-load context.** If `CLAUDE.md` is already in your session, don't re-read it — refer to it.
5. **Archive on the way out.** When a task is done, explicitly say so. Claude releases working memory for completed work.
6. **Prefer focused over comprehensive.** "Find every place we handle payment" is bad. "Find where we tokenize a card-on-file" is good.
7. **Don't pre-explore.** Read what you need for the next 10 minutes, not for the rest of the session.

---

## Quality enforcement (Definition of Done)

A task is DONE only when **every AC item is verified by execution**. Not by inspection. Not by "compiles." Not by "tests green" (those are necessary but not sufficient).

| AC type | Verification mechanism |
|---|---|
| UI change | Playwright walk at 1440 + 375; capture screenshot in PR |
| Backend endpoint | Integration test exercising the real handler |
| Schema change | Migration applied to local DB + relevant Prisma query exercises the new column |
| Memory/doc change | grep + diff confirms the change is present + linked |
| Bug fix | Reproducer that failed before the fix now passes |
| Refactor (no behavior change) | All prior tests + a new test confirming no regression at the public API |

Your PR description includes:
- The user story
- The AC list
- A line per AC: ✅ verified by X (with link/screenshot/test name)

If you can't fill that in, the PR isn't done.

---

## Anti-patterns to avoid

These are mistakes the kit has seen repeatedly. They're not in the codebase to spite you — they're in here because they cost real time on real PRs.

| Anti-pattern | What to do instead |
|---|---|
| Reading 5 related files "to understand the system" | Use `grep` or spawn an agent. Read only files that change a decision in the next 30 min. |
| Marking a task done because "tests pass" | Run the AC list. Tests are necessary, not sufficient. |
| Editing `apps/server/prisma/schema.prisma` | Edit `verticals/pet-services/prisma/schema.prisma` and run `pnpm prepare-schema`. |
| Adding `where: { tenantId }` to every operational query | The Prisma extension auto-injects scoping. Verify before adding manually. |
| Patching a single tenant around a platform gap | File the platform fix. Don't fork the platform per-tenant. |
| Using `vercel --prod` directly | Use `pnpm deploy:*:prod` workspace scripts. |
| Committing to `main` directly | Branch protection will reject. Always feature branch + PR. |
| Continuing a session past 3 topics or 10 files | Close out. Start fresh. |
| Skipping the close-out ritual because "the session was short" | Especially in short sessions — the cost is tiny, the benefit compounds. |
| Treating the auto-mode classifier denial as a bug to work around | It's a safety gate. Escalate to Johnny. |

---

## When in doubt

- Read `CLAUDE.md` (repo root), then your sprint GitHub issue
- Search the repo: `gh search` / `git log --grep` / `grep`
- Ask in the PR or via SMS

Better to ask once than to ship the wrong thing.
