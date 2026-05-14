# Animal Lovers App — Contributor CLAUDE.md
**Audience:** IAID team contributors (employees, freelancers, friends-of-Johnny)
**Maintained by:** Johnny Fermin-Robbins / Ferro Consulting LLC
**This file lives at:** `~/.claude/CLAUDE.md` on your Mac (installed by VibeCoding's `install.sh`)

> This is a stripped-down version of the lead's CLAUDE.md, focused on what you need to ship contributions to the Animal Lovers App SaaS platform without context bloat. The deeper project state lives in the repo at `workspaces/platform/CLAUDE.md` and rotates with `HANDOFF-*.md` files; this file is your stable harness.

---

## Your role

You are a contributing engineer on the IAID team. Your code lands in pull requests that the lead (Johnny, `@Fermin-Robbins`) or another senior contributor (Ernesto, `@matachan`) reviews before merging to `main`. You do not have unilateral merge authority in your first week; you do after your first PR lands cleanly and the team trust-ratchets up.

Treat Claude in your session as a pair-programmer with full repo context but no merge authority. **You** decide what gets pushed; **Johnny or Ernesto** decide what gets merged.

---

## The project (one paragraph)

Multi-tenant SaaS platform for pet-services SMBs at `animalloversapp.com`. One Node/Express server, two React/Vite frontends (customer-app, admin-app), shared Prisma/Postgres on Neon, Stripe Connect for payments. Tenant #1 is **Happy Tail Happy Dog (HTHD)** — Denver-area dog daycare. We're replacing their legacy Gingr SaaS in a calibrated couple-months parallel-run. The platform supports any future pet-services tenant.

For the load-bearing technical-state snapshot, read `workspaces/platform/CLAUDE.md` in the repo. For session-time state, read the most recent `workspaces/platform/HANDOFF-*.md`.

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

Per platform discipline (see `workspaces/platform/CLAUDE.md` for full list):

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

## When in doubt

- Read `workspaces/platform/CLAUDE.md` first.
- Read the most recent `workspaces/platform/HANDOFF-*.md` (`ls -t HANDOFF-*.md | head -1`).
- Search the repo via `gh search` / `git log` / `grep` — these are authoritative for code state.
- Then ask in the PR or via SMS.

---

## What this file is NOT

This file is intentionally narrow. It does NOT contain:
- The lead's personal memory / inference engine
- Cross-project context (other Ferro Consulting work)
- Customer pricing or financial details
- Tenant owner-side communication history
- Private feedback corrections accumulated over many sessions

Those live in the lead's environment for good reason. If you need any of that to do your job, ask Johnny — don't try to reverse-engineer.
