# Animal Lovers App — Contributor CLAUDE.md
**Audience:** IAID team contributors (employees, freelancers, friends-of-Johnny)
**Maintained by:** Johnny Fermin-Robbins / Ferro Consulting LLC
**This file lives at:** `~/.claude/CLAUDE.md` on your Mac (installed by VibeCoding's `install.sh`)

> This is the stable harness — always-loaded base instructions, kept narrow on purpose to save tokens. The detailed playbooks live at `~/code/vibecoding/docs/` and are lazy-loaded only when you need them.

## Priority order (in force, every session)

1. **Quality first.** Every output verifiable by execution, not by inspection.
2. **Token efficiency second.** Delegate to agents, search before reading, archive before context bloats.

Where they conflict, quality wins.

## Lazy-loaded reference docs (read on demand, NOT at session start)

- **`~/code/vibecoding/docs/SESSION-PLAYBOOK.md`** — The 4-phase ritual: Start / Work / Compaction-Avoidance / Close-Out. Read this at the start of your FIRST session, then refer back at every close-out. Includes the 3-and-10 rule and the reasoning-failures check.
- **`~/code/vibecoding/docs/LESSONS_LEARNED.md`** — Curated patterns from prior contributors. Search before solving a new class of problem.
- **`~/code/vibecoding/docs/CROSS-FEEDBACK.md`** — How to feed friction back to the kit. File issues when something didn't work, worked unusually well, or was missing.
- **`CLAUDE.md`** (repo root) — your stable contributor harness + platform discipline. Read at session start.
- **Your sprint GitHub issue** (Johnny assigns it) — the user stories + acceptance criteria for your task. This is your scope; read it second.

**Don't pre-load these. Don't summarize them.** Read when the next task makes them relevant.

---

## Your role

You are a contributing engineer on the IAID team. Your code lands in pull requests that the lead (Johnny, `@Fermin-Robbins`) or another senior contributor (Ernesto, `@matachan`) reviews before merging to `main`. You do not have unilateral merge authority in your first week; you do after your first PR lands cleanly and the team trust-ratchets up.

Treat Claude in your session as a pair-programmer with full repo context but no merge authority. **You** decide what gets pushed; **Johnny or Ernesto** decide what gets merged.

---

## The project (one paragraph)

Multi-tenant SaaS platform for pet-services SMBs at `animalloversapp.com`. One Node/Express server, two React/Vite frontends (customer-app, admin-app), shared Prisma/Postgres on Neon, Stripe Connect for payments. Tenant #1 is **Happy Tail Happy Dog (HTHD)** — Denver-area dog daycare. We're replacing their legacy Gingr SaaS in a calibrated couple-months parallel-run. The platform supports any future pet-services tenant.

For the load-bearing technical-state snapshot, read `CLAUDE.md` at the repo root. For your task's scope (user stories + acceptance criteria), read the GitHub issue Johnny assigned for your sprint. The contributor repo does not carry the lead's internal HANDOFF/strategy docs by design.

---

## Tech stack (preferred, in force)

- **Web Apps**: Vite + React (TypeScript), Node/Express, PostgreSQL/Prisma, Tailwind
- **Multi-tenant deployment**: Vercel (frontends) + Railway (server) + Neon (Postgres)
- **Payments**: Stripe Connect destination charges
- **Email**: Resend (Templates API + idempotency keys)
- **Package manager**: pnpm 10 (workspace-root lockfile only)
- **Testing**: vitest (unit), Playwright (e2e + behavioral verification)

---

## Code preferences

- TypeScript strict mode always.
- Prefer explicit over clever.
- **Mandatory patterns:**
  - **Parse, don't validate** — Zod `.safeParse()` at every system boundary (HTTP, DB→app, queue)
  - **Errors as values** — `neverthrow` Result types in service layer; never silently throw across boundaries
  - **Exhaustive matching** — `ts-pattern` with `.exhaustive()` on all discriminated unions
  - **Illegal states unrepresentable** — discriminated unions over loose optional fields
  - **Functional core, imperative shell** — pure business logic, thin I/O orchestration
- New code always follows these. Existing code converts when touched (no forced refactor of unrelated code).

---

## Development protocol — user stories + AC + Definition of Done

**Mandatory for all non-trivial dev work:**

- Every non-trivial task starts with at least one user story: "As <role>, I want <action>, so that <outcome>."
- Every story carries an acceptance criteria list (Given/When/Then or checkable outcomes).
- **Definition of Done** = every AC verified **by execution**, not by inspection.
- **Behavioral verification is mandatory at the exit gate**:
  - Playwright for UI
  - Integration tests for backend
  - Grep + diff for memory/docs/config changes
- "All clean" / "smoke tests passed" / "tests green" are NOT done unless the AC list passed by execution.
- The PR description includes user stories + AC + the named verification mechanism.

Trigger to apply: any task that produces an artifact a human or downstream agent will use. Skip only for pure conversational scaffolding.

---

## Things to NOT do

Per platform discipline (see `CLAUDE.md` for full list):

- ❌ Touch `production/happy-tail/` — that's the legacy single-tenant deploy.
- ❌ Use `vercel --prod` directly — use the workspace-root `pnpm deploy:*:prod` scripts.
- ❌ Edit `apps/server/prisma/schema.prisma` by hand — it's generated. Edit `verticals/pet-services/prisma/schema.prisma` and run `pnpm prepare-schema`.
- ❌ Touch prod Neon (DATABASE_URL = prod) — only the lead does that with explicit reason.
- ❌ Patch one tenant around platform gaps — if a tenant needs a feature, file the platform feature.
- ❌ Re-introduce per-app lockfiles.
- ❌ Skip the GitHub `coordination` issue when editing a hot file.

If your Claude Code session ever hits the auto-mode classifier saying "this needs explicit auth" — **that's a feature, not a bug.** Don't work around it. Escalate to Johnny.

---

## Working modes

- **Interactive** (default): you and Claude collaborate, Claude explains, you guide.
- **Autonomous** is for the lead only — don't run multi-hour unsupervised loops in your first month.

---

## Security principles

- **Never commit secrets** — API keys, passwords, JWT secrets stay out of git.
- **Always use `.env.example`** — document required vars without real values.
- **Pre-commit secret-scan hooks are mandatory** — install before your first commit.
- **Rotate exposed keys immediately** — If a secret is ever exposed, rotate first, ask questions later.
- Get credentials from Johnny on a private channel; never via PR / issue / email.

---

## Communication

- Explain technical "why" in plain language when Johnny asks.
- Johnny is a domain expert + AI consultant, not a traditional dev — don't over-engineer or over-explain; assume he has the business logic and gets the architecture.
- Ask clarifying questions about business logic before assuming.

---

## Session ritual (summary; full version in SESSION-PLAYBOOK.md)

**Start (3 min):**
1. `date`, `git status`, `git log --oneline -5`, `git branch --show-current`
2. Read `CLAUDE.md` (repo root, first 80 lines)
3. Read your assigned sprint GitHub issue (it has the user stories + ACs)
4. Write/confirm the user story + AC BEFORE writing code

**Work:**
- TypeScript types changed → `pnpm -r typecheck` immediately
- Prisma schema changed → `pnpm prepare-schema` (edit the canonical, never the generated)
- New React component → render at 1440 AND 375 before claiming done
- About to read a 3rd related file → STOP, use `grep` or spawn an `Explore` agent

**Compaction avoidance (the 3-and-10 rule):**
End the session early if you've hit ANY of:
- 3+ distinct topics in one session
- 10+ different files touched
- 2+ hours of active work
- Multiple corrections from Johnny in one session
Close out cleanly + start a fresh session. Quality drops invisibly when context fills.

**Close-out (every session, mandatory — even short ones):**
1. Summarize: what changed, what's open
2. Commit any uncommitted work
3. Update the issue / PR description with AC verification
4. Reasoning-failures check: any assertion-without-verification or pattern-matched-without-checking? Log to `~/.claude/projects/<scope>/memory/feedback_reasoning_discipline.md`.
5. Cross-feedback: if you hit kit friction, file an issue → `bash ~/code/vibecoding/scripts/file-feedback.sh`
6. `/clear` or close the terminal

Full version: `~/code/vibecoding/docs/SESSION-PLAYBOOK.md`.

## When in doubt

- Read `CLAUDE.md` (repo root) first, then your sprint GitHub issue.
- Search the repo via `gh search` / `git log` / `grep` — these are authoritative for code state.
- Then ask in the PR or via SMS.

If you hit something that should be in the kit but isn't → file a `feedback:gap` issue on `International-AI-Design/vibecoding`. The kit gets better when you tell it where it's broken.

---

## What this file is NOT

This file is intentionally narrow. It does NOT contain:
- The lead's personal memory / inference engine
- Cross-project context (other Ferro Consulting work)
- Customer pricing or financial details
- Tenant owner-side communication history
- Private feedback corrections accumulated over many sessions

Those live in the lead's environment for good reason. If you need any of that to do your job, ask Johnny — don't try to reverse-engineer.
