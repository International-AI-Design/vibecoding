# Lessons Learned

> Append-only log of curated wisdom from contributor cross-feedback (`CROSS-FEEDBACK.md`). Each entry describes a pattern + the trigger condition for applying it. Read this when you start your day; it's where the kit's hard-won knowledge lives.
>
> **Format:** dated H2 sections, newest at top. Each entry has: **Pattern**, **Trigger**, **Why** (one paragraph), **Anti-pattern this replaces** (optional). Keep entries under 200 words each.

---

## 2026-05-13 · The tenant is the oracle, not the codebase

**Pattern.** When determining intended behavior on a tenant-specific feature, compare against the *legacy single-tenant deploy* of that tenant (for HTHD: `hthd.internationalaidesign.com`), NOT against the current state of the multi-tenant platform.

**Trigger.** You're unsure how a tenant feature is supposed to look or behave.

**Why.** The platform is mid-migration from N legacy single-tenant deploys to a unified multi-tenant SaaS. The legacy deploys are the *spec*; the new platform is the *implementation*. If the implementation diverges from the spec, the implementation is wrong unless explicitly documented otherwise.

**Anti-pattern this replaces.** Treating the current platform's behavior as authoritative just because it's the newer code.

---

## 2026-05-13 · User-rooted ACs only

**Pattern.** Acceptance criteria describe what the **user** experiences, not what the **code** does. Use Given/When/Then with user-visible nouns and verbs.

**Trigger.** Writing AC for a story before implementation.

**Why.** Code-rooted ACs verify the implementation in isolation but miss bugs at the integration boundary. User-rooted ACs force you to verify behavior end-to-end. If you can't write a user-rooted AC, the user value isn't yet clear.

**Examples.**
- ❌ "When `confirmBooking()` is called, `Booking.status` transitions to `confirmed`."
- ✅ "When the user taps Confirm, the booking shows as Confirmed in the list within 2 seconds."

---

## 2026-05-13 · Behavioral verification > code inspection

**Pattern.** Don't claim "done" because the code compiles or unit tests pass. Verify behavior by execution at the right layer: Playwright for UI, integration tests for backend, grep+diff for memory/docs.

**Trigger.** About to mark a task complete.

**Why.** Typechecker + unit tests are necessary but not sufficient. Real bugs live at integration boundaries. Without behavioral verification, you're shipping unverified work.

**Anti-pattern this replaces.** "All clean" / "tests green" as a Definition of Done.

---

## 2026-05-13 · Verify schema before trusting handoff prescriptions

**Pattern.** If a doc says "add `where: { tenantId }` here" or "this column exists" — verify against the actual schema before acting. Run `pnpm prepare-schema` first, then grep the regenerated `apps/server/prisma/schema.prisma`.

**Trigger.** Implementing a prescription from a stale doc.

**Why.** The platform's Prisma schema regenerates from a canonical source. Docs go stale. Audits go stale. Schema files in apps/ are in `.gitignore` and can lag behind the canonical source arbitrarily. The schema *as regenerated* is the only source of truth.

**Anti-pattern this replaces.** Following "obvious" instructions in HANDOFF/audit docs without verifying current state.

---

## 2026-05-13 · Don't patch one tenant around a platform gap

**Pattern.** If a tenant exposes a missing feature, *file the platform feature*; don't fork the platform to give that one tenant a workaround.

**Trigger.** Tempted to add a tenant-specific code path because the platform doesn't support what the tenant needs.

**Why.** Per-tenant patches accumulate as technical debt that compounds. Each new tenant exposes more gaps; each gap becomes a fork; eventually the platform isn't a platform anymore. Filing the platform feature is slower for *this* tenant but compounds wins for every future tenant.

**Anti-pattern this replaces.** "Just add a quick `if (tenantId === 'hthd')` here, we'll clean it up later."

---

## 2026-05-13 · The 3-and-10 rule for compaction avoidance

**Pattern.** End your Claude Code session when you've covered 3+ distinct topics OR touched 10+ different files OR worked 2+ hours OR received multiple corrections in the same session.

**Trigger.** Mid-session, you notice you've drifted.

**Why.** Claude Code summarizes context when it fills up. Summarization loses precision — specific file paths, corrected assumptions, custom ACs get smoothed. Quality drops invisibly. Starting fresh is cheap; recovering from compacted-context drift is expensive.

**How to apply.** Do the [close-out ritual](SESSION-PLAYBOOK.md#phase-4--session-close-out-the-shutdown-ritual), commit work, `/clear`, start new.

---

## 2026-05-13 · Auto-mode classifier denials are features, not bugs

**Pattern.** When Claude's safety classifier blocks an action with "this needs explicit auth" — don't work around it. Escalate to Johnny.

**Trigger.** A bash command, schema edit, or destructive op fails with a classifier denial.

**Why.** The classifier exists because shared-resource writes (canonical schema, prod DB, `~/.claude/*`, GitHub-org repos) need a human-in-the-loop gate. Working around it defeats the entire safety system. If you genuinely need to perform the action, ask Johnny for explicit auth; he can pre-approve specific operations via settings.json or the `/allow` command.

**Anti-pattern this replaces.** "Let me try this with `env HOME=/tmp ...`" / "Maybe a subshell will let me through."

---

## 2026-05-13 · Delegate broad investigation to sub-agents

**Pattern.** When you need to "understand a system" or "find every callsite" — spawn an `Explore` or `general-purpose` sub-agent. It returns a summary; you don't pay the token cost of the raw read.

**Trigger.** You're about to read >3 related files just to map a feature.

**Why.** Sub-agents have their own context window. Their findings come back as a 500-word summary instead of 20,000 tokens of grep output. Main context stays clean; quality on the main task stays high.

**Anti-pattern this replaces.** Reading 8 files in your main session to "get oriented."

---

## How to add a lesson

When `feedback:win` issues get curated by Johnny, the pattern is extracted and added here as a new H2 dated entry at the TOP of this file. Keep:
- One pattern per entry
- Trigger condition crisp (one sentence)
- Why concise (one paragraph)
- Anti-pattern explicit when applicable

Don't delete old entries — date them and let the file grow. If a lesson becomes contradicted by a newer one, write a new H2 entry that supersedes it; leave the old one in place for archaeology.
