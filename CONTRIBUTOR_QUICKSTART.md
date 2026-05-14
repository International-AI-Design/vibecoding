# Animal Lovers App — Contributor Quickstart
**Time to read:** ~10 minutes
**Audience:** New IAID contributor working on the Animal Lovers App SaaS platform

> This is the post-install orientation. If you haven't run `install.sh` yet, see the [README](README.md).

---

## What the project is

A multi-tenant SaaS platform for pet-services SMBs (dog daycare, grooming, boarding). Live at `animalloversapp.com` with per-tenant subdomains like `<tenant>.animalloversapp.com` (customer-facing) and `<tenant>.admin.animalloversapp.com` (staff-facing).

**Tenant #1 is Happy Tail Happy Dog (HTHD)** — a Denver-area daycare. Their staff gave us on-site walk-throughs of their workflow. The current Gingr SaaS they use is the *baseline we're replacing* — keep its data points, modernize its presentation, fix its pain.

**Status:** HTHD is deployed in pre-launch. The customer rows in the dev DB are Gingr-migrated test fixtures, NOT real users transacting. Treat HTHD as "deployed in pre-launch" — safe to test against live URLs.

For the current state, always read the most recent `workspaces/platform/HANDOFF-*.md` in the platform repo. It rotates per-session.

---

## Repo layout (the platform repo, not this kit)

```
ferroai/                                  ← repo root (International-AI-Design/ferroai)
├── workspaces/
│   └── platform/                         ← THE platform monorepo (your workspace)
│       ├── apps/
│       │   ├── customer-app/             ← Vite + React, customer-facing
│       │   ├── admin-app/                ← Vite + React, tenant-staff-facing
│       │   └── server/                   ← Node + Express + Prisma, single API
│       ├── packages/                     ← Shared libraries (@ferro/*)
│       ├── clients/                      ← Per-tenant config + branding
│       ├── verticals/
│       │   └── pet-services/
│       │       └── prisma/schema.prisma  ← CANONICAL Prisma schema. Edit here.
│       ├── e2e/                          ← Playwright end-to-end tests
│       ├── scripts/                      ← Build + deploy scripts
│       ├── CLAUDE.md                     ← Load-bearing technical state — READ FIRST
│       ├── VERCEL_DEPLOY.md              ← Authoritative deploy runbook
│       └── HANDOFF-*.md                  ← Time-stamped state snapshots, rotating
└── outputs/                              ← Business deliverables
```

Other dirs you may see (`production/`, `internal/`, `archive/`) are **not your concern** unless Johnny points you there.

---

## The five must-read files (in order)

1. `workspaces/platform/CLAUDE.md` — load-bearing technical-state snapshot. Updated whenever a load-bearing fact changes.
2. The most recent `workspaces/platform/HANDOFF-*.md` — session-time live state (find by `ls -t HANDOFF-*.md | head -1`).
3. Any `workspaces/platform/docs/<session>/USER-STORIES-*.md` for the current sprint's stories with ACs.
4. The matching `workspaces/platform/docs/<session>/SPRINT-PLAN-*.md` for daily milestones.
5. `workspaces/platform/VERCEL_DEPLOY.md` — what to do (and not do) for deploys.

---

## Daily workflow

```bash
# 1. Pull latest
cd workspaces/platform && git checkout main && git pull

# 2. See today's sprint board
# The SessionStart hook in Claude Code auto-prints this
gh issue list --label "status:ready" --label "area:customer-app" --no-assignee

# 3. Pick an issue
gh issue view <N>

# 4. Branch
git checkout -b feature/<short-desc>-<issue-N>

# 5. Work (in Claude Code, following the user-story → AC discipline)

# 6. Run checks locally
pnpm -r typecheck && pnpm -r test

# 7. Open PR
git push -u origin HEAD
gh pr create --title "<type>(<area>): <subject> — issue #<N>"

# 8. Update the daily-sync issue with what you shipped
```

---

## Branch protection on `main`

You **cannot push directly to `main`**. Always work on a feature branch and open a PR. PRs require:
- Typecheck clean
- Tests green
- Either: 24h "soak" with no objections + self-merge OR explicit Johnny/Ernesto approval

In your first week, all your PRs need a human approval before merge. After PR #1 lands cleanly, the trust ratchets up.

---

## Hot files — file a coordination issue FIRST

Editing any of these without a coordination issue is a fast way to break the build for everyone:

- `apps/server/src/index.ts`
- `verticals/pet-services/prisma/schema.prisma` (the CANONICAL schema — edits here propagate to all clients via `pnpm prepare-schema`)
- `apps/server/prisma/schema.prisma` (generated; don't edit by hand — edit the canonical, then regenerate)
- Top-level `package.json`
- `clients/*/branding.json`
- `tsconfig.base.json`
- `.github/*` (CI workflows)

For these files: open a GitHub issue labeled `coordination`, describe the change, wait for a thumbs-up.

---

## Things you should NOT do

Per `workspaces/platform/CLAUDE.md` and the team's hard-learned discipline:

- ❌ Touch `production/happy-tail/` in the platform repo. That's the legacy single-tenant deploy. The new platform's tenant config lives at `clients/<slug>/`.
- ❌ Re-introduce per-app `pnpm-lock.yaml` files. The workspace-root lock is the only authoritative one.
- ❌ Use `vercel --prod` directly. Use `pnpm deploy:customer-app:prod` / `pnpm deploy:admin-app:prod` (workspace-root scripts).
- ❌ Link Vercel projects from the workspace root. The CLI link must live at `apps/<app>/.vercel/`.
- ❌ Write `where: { tenantId }` against operational tables blindly. The Prisma extension auto-injects tenant scoping on most operational reads — you usually don't need to add it manually.
- ❌ Touch prod Neon (DATABASE_URL pointing at prod). Only Johnny does that, with an explicit reason and a snapshot first.
- ❌ Skip `pnpm prepare-schema` before reading `apps/server/prisma/schema.prisma`. That file is generated; it can lag if you haven't regenerated.
- ❌ Patch a single tenant around platform gaps. If a tenant reveals a missing platform feature, file the platform feature, don't fork the platform.

---

## Three discipline rules to internalize

1. **The tenant is the oracle, not the codebase.** When in doubt about intended behavior, compare against the legacy single-tenant deploy (`hthd.internationalaidesign.com` for HTHD) — not against the platform's current state.
2. **User-rooted ACs only.** Acceptance criteria must describe what the *user* experiences, not what the *code* does internally. "When the user taps Confirm, the booking shows as Confirmed within 2 seconds" — not "When `confirmBooking()` is called, `Booking.status` transitions to `confirmed`."
3. **Behavioral verification > code inspection.** Playwright for UI claims. Integration tests for backend. Grep + diff for memory/docs. "Compiles + types pass" is not done.

---

## Common operations

### Run the customer-app locally
```bash
cd apps/customer-app && pnpm dev
# Opens http://localhost:5173
```

### Run the admin-app locally
```bash
cd apps/admin-app && pnpm dev
```

### Run the server locally
```bash
cd apps/server && pnpm dev
# Needs DATABASE_URL set. Get from Johnny.
```

### Hit a tenant locally
```bash
# Browser: http://hthd.localhost:5173/  (after adding hthd.localhost to /etc/hosts → 127.0.0.1)
# OR: pass ?host=hthd.animalloversapp.com to override
```

### Deploy a preview (Johnny is the gatekeeper for prod — never run :prod yourself)
```bash
pnpm deploy:customer-app:preview
pnpm deploy:admin-app:preview
```

### Run all tests
```bash
pnpm -r typecheck
pnpm -r test
```

### Run Playwright e2e
```bash
cd e2e && pnpm test
```

---

## Where the sandbox is

For destructive experiments, work on `dev` Neon database (DATABASE_URL = `dev_neon_url`) — NEVER prod. Johnny can hand you the dev URL on a private channel.

To reset the dev DB to a known state:
```bash
cd apps/server && pnpm db:seed
```

---

## Triggering Claude correctly

Claude Code on your Mac will load `~/.claude/CLAUDE.md` (from this kit) + `workspaces/platform/CLAUDE.md` + the recent HANDOFF docs on session start. That gives it project context.

For specific issues, the platform repo has a paste-ready prompt generator (when present):
```bash
bash workspaces/platform/scripts/sprint-5day/start-on-issue.sh <N>
```

This produces a prompt that includes the user story, AC, and acceptance gate — feed it to Claude, then iterate.

---

## How to escalate

- PR question → comment on the PR, tag `@Fermin-Robbins` or `@matachan`
- Stuck on a class of problem → SMS Johnny (don't burn your Claude session in circles)
- Production looks broken → STOP, do not deploy, SMS Johnny immediately
- Hit an `auto-mode classifier` denial → that's your safety gate — escalate, don't work around

---

## What to do first

After install:
1. Ask Johnny to add you as a collaborator on `International-AI-Design/ferroai`.
2. Clone it: `gh repo clone International-AI-Design/ferroai ~/code/ferroai`
3. `cd ~/code/ferroai/workspaces/platform && claude`
4. Read the platform CLAUDE.md + most recent HANDOFF.
5. Pick an `area:customer-app`, `area:tests`, or `good-first-issue` from the GitHub issue list.
6. Branch, work, open a PR. Tag Johnny for review.

---

## Welcome 🐾
