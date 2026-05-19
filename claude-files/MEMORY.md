# Contributor Auto Memory — Starter

## Critical Corrections (always inline)
- **Animal Lovers App** is the multi-tenant pet-services SaaS platform you're contributing to. Domain: `animalloversapp.com`. Owned by IAID (International AI Design), a DBA of Ferro Consulting LLC.
- **HTHD (Happy Tail Happy Dog)** is Tenant #1 — Denver-area dog daycare. URLs: `hthd.animalloversapp.com` (customer-facing) + `hthd.admin.animalloversapp.com` (staff-facing). Pre-launch, no live transacting customers yet.
- **Lead:** Johnny Fermin-Robbins (`@Fermin-Robbins` on GitHub).
- **Other contributor:** Ernesto (`@matachan` on GitHub) — backend/infra-strong, ~20h/wk.
- **HTHD tenant staff** (Gabriel = daycare ops, Becky = grooming/front-of-house) are platform USERS, not contributors. Don't conflate them with team members.

## Project Context Pointers
- Platform repo: `International-AI-Design/animal-lovers-platform` (private). **Repo root IS the platform** — `apps/`, `packages/`, `verticals/` at the top level (no nested wrapper directory).
- Working dir: the repo root after `gh repo clone International-AI-Design/animal-lovers-platform`
- Sprint board: GitHub Issues with `area:server` / `area:admin-app` / `area:customer-app` / `area:core` / `area:infra` labels. First PR: `gh issue list -R International-AI-Design/animal-lovers-platform --label "good first issue"`
- Daily-sync issue: `daily-sync-2026-MM-DD` per day, async-only

## Patterns (read on demand)
None yet — you'll accumulate patterns as you ship. When you find a non-obvious approach that worked, save it here so future-you doesn't re-derive.

## Feedback / Preferences
None yet — same. Save corrections you receive so you don't repeat the same mistake.

## Reference Docs
- `CLAUDE.md` (repo root) — your stable contributor harness + platform discipline
- Your **sprint GitHub issue** (Johnny assigns it) — carries the user stories + acceptance criteria for your task. This is your scope.
- The contributor repo intentionally does **not** carry the lead's internal HANDOFF/strategy docs, deploy runbooks, or client transcripts. Need context beyond the code + your issue? Ask Johnny.

## About
You're a contributor on the IAID team, helping build the Animal Lovers App SaaS platform.
