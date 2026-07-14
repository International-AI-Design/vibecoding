# Lessons Learned

> Append-only log of hard-won patterns. Each entry: the **pattern**, the **trigger** that should make you reach for it, and **why** it's true.
>
> Newest at top. Don't delete old entries — if one gets superseded, write a new entry that supersedes it and leave the old one for archaeology.

These are generalized from real failures on real projects. They cost time to learn. They're free to read.

---

## Behavioral verification beats code inspection

**Pattern.** Don't claim "done" because the code compiles or unit tests pass. Verify behavior by execution, at the right layer: a real browser for UI, an integration test for backend, `grep` + `diff` for docs and memory.

**Trigger.** You're about to mark a task complete.

**Why.** The typechecker and unit tests are *necessary but not sufficient*. Real bugs live at integration boundaries — precisely the seams that isolated tests don't cross. Without behavioral verification you're shipping unverified work with a green checkmark on it, which is worse than shipping it with a known question mark.

**Replaces.** "All clean" / "tests green" as a Definition of Done.

---

## Stubbed tests can't find stacked bugs

**Pattern.** When a code path is broken in more than one place, unit tests that stub the dependencies will find **only the first bug**. Each fix reveals a new layer that the stub was hiding. For money, auth, and permission paths, a real behavioral run against the real system is non-negotiable.

**Trigger.** You just unblocked a path that was completely dead.

**Why.** This is a real and brutal one. A rewards-redemption flow was 100% broken. Unit tests passed. Adversarial code review passed. It took **three stacked latent bugs** — client contract, server write-path scoping, and a database query throwing on a composite key — to actually fix, and each one was *only reachable after the previous fix landed*. The stub mocked away the layers where all three lived.

**Corollary, and this is the expensive half:** when you unblock a path, **audit the whole downstream chain you just enabled.** Nobody was exercising it before. Everything past the blockage is unverified by construction.

---

## User-rooted ACs only

**Pattern.** Acceptance criteria describe what the **user** experiences, not what the **code** does.

**Trigger.** Writing AC before implementation.

**Why.** Code-rooted ACs verify the implementation in isolation and miss bugs at the boundary. User-rooted ACs force end-to-end verification, because you can't satisfy them without running the actual flow.

- ❌ "When `confirmBooking()` is called, `Booking.status` becomes `confirmed`."
- ✅ "When the user taps Confirm, the booking shows as Confirmed within 2 seconds."

---

## Don't trust a doc for runtime state — query the system

**Pattern.** Before asserting that something is deployed, running, working, stale, or broken — **probe it.** A hand-maintained doc is a claim about the past, not a description of the present.

**Trigger.** You're about to say "X is live" / "the sync is running" / "that's still broken."

**Why.** Docs go stale silently and *keep their confident tone while doing so*. A status file said a system was healthy; the job had not fired in 81 hours. A CLAUDE.md said a test was skipped in CI; it had been merge-blocking for two weeks. Both were written accurately and both became lies without anyone touching them.

**How to apply.** Ask what live query would settle it — an HTTP endpoint, `launchctl list`, `git log`, a real DB read — and run *that*. Verifying takes 10 seconds. Being confidently wrong costs a session.

---

## Don't chase the alert text — find the root cause

**Pattern.** When something fails, the error message tells you where it *surfaced*, not where it *broke*. Resist fixing the surface.

**Trigger.** You have a plausible explanation for a failure that you haven't actually confirmed.

**Why.** A scheduled job stopped firing. The obvious hypothesis — "the data extraction stage broke" — was wrong, and would have sent someone rewriting a healthy script. The real cause was that the scheduler used an interval timer that the OS silently suppresses across sleep. Everything downstream was correctly idle. The "broken" component was fine.

**How to apply.** Prove the mechanism before you fix it. "This explains the symptom" is not the same as "this caused the symptom" — many things explain a symptom, and only one caused it.

---

## Delegate broad investigation to subagents

**Pattern.** Need to "understand a system" or "find every callsite"? Spawn a subagent. It returns a summary; you don't pay the token cost of the raw read.

**Trigger.** You're about to read a 3rd file just to get oriented.

**Why.** Subagents have their own context window. Findings come back as a 500-word summary instead of 20,000 tokens of grep output. Main context stays clean, and quality on the main task stays high — context spent on orientation is context not spent on the work.

---

## The 3-and-10 rule

**Pattern.** End the session at 3+ distinct topics, OR 10+ files touched, OR 2 hours, OR multiple corrections in one session.

**Trigger.** Mid-session, you notice drift.

**Why.** Claude Code summarizes context when it fills. Summarization loses precision — specific paths, corrected assumptions, custom ACs get smoothed away. **Quality drops invisibly.** Starting fresh is cheap; recovering from compacted-context drift is not.

---

## Safety-classifier denials are features

**Pattern.** When a safety gate blocks an action, don't engineer around it. Escalate.

**Trigger.** A command, edit, or destructive op fails with a classifier denial.

**Why.** The gate exists because writes to shared or irreversible resources need a human in the loop. Routing around it defeats the entire system — and the workaround is always available, which is exactly why the discipline has to come from you.

**Replaces.** *"Let me try that with a different HOME…"* / *"Maybe a subshell gets through."*

---

## Don't patch one consumer around a platform gap

**Pattern.** If one client/tenant/caller exposes a missing capability, **build the capability**. Don't fork the platform to give that one caller a workaround.

**Trigger.** You're tempted to write `if (client === 'X')`.

**Why.** Per-consumer patches compound. Each new consumer exposes more gaps; each gap becomes a fork; eventually the platform isn't a platform — it's N codebases wearing a trenchcoat. Filing the real fix is slower for *this* caller and faster for every future one.

---

## How to add a lesson

New H2 at the **top**. Keep it to one pattern, a one-sentence trigger, a tight why, and the anti-pattern it replaces when there is one. Under 200 words.

The best source of entries is the **[reasoning-failures check](SESSION-PLAYBOOK.md#44-the-reasoning-failures-check--the-one-that-compounds)** at session close-out. What you got wrong today is what you'll get wrong again in three weeks — unless it's written here.
