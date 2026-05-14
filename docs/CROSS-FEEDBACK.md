# Cross-Feedback Protocol

> How the kit gets better. Every contributor's friction is the next contributor's smoother path — if they file it.

The vibecoding kit isn't a static document; it's a living harness. The mechanism for keeping it living = **GitHub issues on this repo**, curated periodically by Johnny, propagated into:
- `LESSONS_LEARNED.md` (this repo)
- `claude-files/CLAUDE.md` (the contributor base)
- Johnny's local environment (his `~/.claude/projects/-Users-johnny-code/memory/` + `~/memory/`)

---

## The three feedback types

### `feedback:correction` — "the kit said X, but actually Y"

File this when a kit instruction was **wrong, stale, or misleading**. Examples:
- README says to run `pnpm dev` but the actual command is `pnpm start`
- CLAUDE.md mentions a "T-02 migration not shipped" but it actually has shipped
- A "do not" rule prevented you from doing something that turned out to be correct

This is the highest-value feedback because it prevents the **next** contributor from hitting the same wall.

### `feedback:win` — "this pattern worked unusually well"

File this when something the kit suggests (or doesn't yet suggest) **paid off beyond expectation**. Examples:
- The `Explore` agent saved you an hour of grep-reading
- The compaction-avoidance protocol caught you before drift
- A specific bash one-liner solved a class of problem and should be promoted

Wins are how patterns earn their place in `LESSONS_LEARNED.md`. Don't be shy.

### `feedback:gap` — "I needed context that wasn't in the kit"

File this when you had to ask Johnny (or guess) because the kit was **silent on something it should cover**. Examples:
- You couldn't figure out the right Stripe Connect test mode flag
- The deploy runbook didn't mention a step that turned out to matter
- A discipline rule existed implicitly but wasn't written down

Gaps are how the kit grows in scope.

---

## How to file

### Option 1 — Helper script
```bash
bash ~/code/vibecoding/scripts/file-feedback.sh
```
Walks you through type + title + body, opens the issue in your browser for final review.

### Option 2 — Direct `gh`
```bash
gh issue create --repo International-AI-Design/vibecoding
```
Pick the template that matches your feedback type.

### Option 3 — Web
https://github.com/International-AI-Design/vibecoding/issues/new/choose

---

## What makes a good feedback issue

Short. Specific. Actionable.

**Title:** What the kit should change. ("README's bootstrap prompt should mention `gh auth login` first.")

**Body:** Three sections, ~3-5 lines each.
1. **What happened.** The actual situation you hit, including any error message verbatim.
2. **What you expected.** What the kit (or implicit assumption) led you to expect.
3. **Proposed fix.** A specific change — file path, suggested wording, or "add a section on X."

A great issue can be turned into a PR by Johnny (or you) in under 10 minutes.

---

## What's NOT cross-feedback

Don't use this protocol for:
- ❌ Platform code bugs — those go in `International-AI-Design/ferroai` issues
- ❌ Customer-facing bug reports — those go to Johnny on a 1:1 channel
- ❌ Secrets, credentials, customer PII — never in any public issue
- ❌ Personal complaints about the codebase — use a PR, not an issue

The vibecoding repo is for **the harness**, not the platform.

---

## How Johnny curates feedback

Approximately weekly, Johnny reviews open `feedback:*` issues and either:

1. **Patches the kit directly** — small fix lands in a PR, issue closes.
2. **Promotes the pattern** — wins move into `LESSONS_LEARNED.md` with attribution; sometimes into `claude-files/CLAUDE.md` if universal.
3. **Adds a discipline rule** — gaps that reveal an implicit rule get explicit.
4. **Declines with reason** — sometimes a "correction" is actually correct as-stated and the feedback reveals a doc could be clearer about *why*. Comment + close.

The full feedback log is searchable in the repo's Issues tab forever, so you can see how prior feedback became kit changes.

---

## Anti-fragile loop diagram

```
    Contributor session
            │
            ▼
    Hit friction / win
            │
            ▼
    File feedback:* issue
            │
            ▼
       Johnny curates ──── propagates ────► claude-files/CLAUDE.md
            │                                     │
            ▼                                     │
   LESSONS_LEARNED.md  ◄─────────────────────────┘
            │
            ▼
    Next contributor session loads improved kit
            │
            ▼
        (loop)
```

The kit gets sharper with every contributor who files. The cost of filing is ~5 minutes. The benefit accrues to every contributor after you (including future-you).

---

## Privacy + safety

- Issues are public by default (this repo is public). **Never put credentials, customer names, or PII in a feedback issue.**
- Use placeholder names: `<tenant>`, `<customer>`, `<staff-member>`.
- If you need to share something sensitive, file the issue with a redacted version and DM Johnny the details.
- If you accidentally put something sensitive in an issue, edit it immediately and tell Johnny — he can purge the history.

---

## Performance signals (what "the kit is working" looks like)

Not formal metrics — just things to notice over time:
- Number of feedback issues filed (more = more eyes on the kit, good)
- Time-to-merge for first-PR (lower = better onboarding)
- Sessions per closed issue (lower = more focused contributors)
- Number of `feedback:correction` issues filed against the same paragraph (higher = that paragraph needs a rewrite)

Johnny tracks these informally; future versions may add a `metrics/` directory.
