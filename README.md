# VibeCoding
**v0.2**

> A reproducible Claude Code setup for the IAID team — built around the way Johnny Fermin-Robbins ships software-on-demand for SMBs.

This repo is the **harness**, not the application. It gives a new contributor a productive Claude Code environment on their Mac in about 5 minutes. The actual platform code lives in a separate (private) repo; this kit gets your AI dev loop running, gives you the session playbook, and connects you back to the team's lessons-learned loop.

**Priority order, in force:**
1. **Quality** — every output verifiable by execution, not by inspection.
2. **Token efficiency** — delegate to agents, search before reading, archive before context bloats.

If you're new here, start with the bootstrap prompt below.

## The 30-second mental model

```
   ┌───────────────────────────────────────────────────────────────┐
   │  Your Mac                                                     │
   │                                                               │
   │   ~/.claude/        ◄── installed by install.sh               │
   │     CLAUDE.md       (always-loaded base instructions)         │
   │     MEMORY.md       (starter memory index)                    │
   │     settings.json   (permissions + model)                     │
   │                                                               │
   │   ~/code/vibecoding/  ◄── this repo, cloned                   │
   │     docs/SESSION-PLAYBOOK.md   (lazy-loaded; read at start)   │
   │     docs/LESSONS_LEARNED.md    (lazy-loaded; curated wisdom)  │
   │     docs/CROSS-FEEDBACK.md     (when you want to file)        │
   │     scripts/file-feedback.sh   (one-command feedback)         │
   │                                                               │
   │   ~/code/ferroai/   ◄── private; the platform you work on    │
   │                                                               │
   └────────────────────────────┬──────────────────────────────────┘
                                │  feedback issues
                                ▼
                  github.com/International-AI-Design/vibecoding
                                │
                                ▼
                  Johnny curates → kit gets sharper → next session
```

---

## The bootstrap prompt

Paste this into a fresh Claude Code session on your Mac. Claude does the rest.

```text
You're helping me get set up as a new contributor on the Animal Lovers App
SaaS platform built by IAID (International AI Design).

This is a two-phase onboarding: (A) install + understand the kit, then
(B) start work on a real issue. Confirm each step before moving on.
If anything fails, explain why and ask me what to do.

=== PHASE A — INSTALL + ORIENT ===

1. Verify I have these installed on my Mac: node, pnpm, git, gh (GitHub CLI),
   and `claude` (Claude Code CLI). If any are missing, give me the brew/npm
   command to install them.

2. Clone https://github.com/International-AI-Design/vibecoding to
   ~/code/vibecoding (or `git pull` to refresh if already there).

3. Run `bash ~/code/vibecoding/install.sh`. It backs up any existing
   ~/.claude config files, then installs the contributor's CLAUDE.md,
   MEMORY.md, and settings.json templates.

4. Verify the install by reading ~/.claude/CLAUDE.md and confirming it's
   the IAID VibeCoding contributor kit (starts with
   "# Animal Lovers App — Contributor CLAUDE.md").

5. Read ~/code/vibecoding/docs/SESSION-PLAYBOOK.md and summarize for me:
   - the 4 phases of a session
   - the 3-and-10 rule for compaction avoidance
   - the close-out ritual's 6 steps

6. Read ~/code/vibecoding/docs/LESSONS_LEARNED.md and pick out the 3
   patterns most likely to bite me on a first PR. Tell me what they are.

7. Read ~/code/vibecoding/docs/CROSS-FEEDBACK.md. Confirm you know how
   to file `feedback:correction` / `feedback:win` / `feedback:gap` issues
   if we hit friction.

=== PHASE B — START REAL WORK ===

8. Ask me my GitHub handle so I can request access to the private platform
   repo. If I don't have access yet, tell me to message Johnny
   (@Fermin-Robbins) for an invite on International-AI-Design/ferroai.

9. Once I have access:
       gh repo clone International-AI-Design/ferroai
       cd ~/code/ferroai/workspaces/platform
       claude

10. In the new Claude Code session, walk me through Phase 1 of the
    SESSION-PLAYBOOK explicitly:
    - read workspaces/platform/CLAUDE.md (first 80 lines is enough)
    - read the most recent HANDOFF-*.md
    - run `gh issue list --label status:ready --no-assignee` and help me
      pick a `good-first-issue` / `area:customer-app` / `area:tests` issue

11. Help me write the user story + acceptance criteria for the issue
    BEFORE I write any code. Confirm with me before starting implementation.

12. Then walk me through the work-rhythm cadence in SESSION-PLAYBOOK
    Phase 2 as I implement.

13. At the end, run the close-out ritual (SESSION-PLAYBOOK Phase 4) with me.

Throughout: NEVER skip the verification steps. If install.sh fails, do not
paper over it — show me the exact error. If the auto-mode safety classifier
denies an action, escalate to Johnny — that's a feature, not a bug.
```

---

## What this repo installs on your Mac

`install.sh` is idempotent (safe to re-run) and only touches `~/.claude/`. It:

1. Verifies prerequisites (`node`, `pnpm`, `git`, `gh`).
2. Installs Claude Code CLI via brew if not present.
3. Copies `claude-files/CLAUDE.md` → `~/.claude/CLAUDE.md` (backs up any existing one with a timestamp).
4. Copies `claude-files/MEMORY.md` → `~/.claude/MEMORY.md` (same backup behavior).
5. Copies `settings/settings.json` → `~/.claude/settings.json` (same backup behavior).
6. Checks that `gh auth status` is OK; prompts you to run `gh auth login` if not.

After running it, you're ready to clone the platform repo and start contributing.

---

## What's deliberately NOT in this repo

For your safety and to keep this kit shareable:

- ❌ No private Claude memory feedback files (`feedback_*.md`). Those encode Johnny's personal corrections-history and aren't generalizable.
- ❌ No Cabinet, Sentinel, Aliro, or other historical internal architecture content.
- ❌ No real customer PII — placeholder names only. Get real contact info from Johnny on a 1:1 channel.
- ❌ No credentials. Stripe, Resend, Neon, Railway, Anthropic API keys — none of those are in this repo. Get them from Johnny when you need them, and never commit them.
- ❌ No Anthropic API key. Use your own Claude Code subscription via interactive auth (`claude auth login`). Johnny will share API access only if scope requires.
- ❌ No `~/memory/personal/` content. That's Johnny's personal layer.

If you find any of these in the repo by accident, flag it to Johnny immediately.

---

## Manual install (if you'd rather skip the bootstrap prompt)

```bash
git clone https://github.com/International-AI-Design/vibecoding.git ~/code/vibecoding
cd ~/code/vibecoding
bash install.sh
```

Then read `CONTRIBUTOR_QUICKSTART.md` for the 10-minute orientation.

---

## What you do next (after install)

1. Ask Johnny (@Fermin-Robbins) to add you as a collaborator on `International-AI-Design/ferroai`. That's where the actual platform code lives.
2. `gh repo clone International-AI-Design/ferroai ~/code/ferroai`
3. `cd ~/code/ferroai/workspaces/platform && claude`
4. The SessionStart hook prints today's sprint board.
5. Pick an open issue, branch, work, open a PR.

Full daily workflow + branch protection rules + hot-files list + DoD gate are in [`CONTRIBUTOR_QUICKSTART.md`](CONTRIBUTOR_QUICKSTART.md).

---

## File map

```
vibecoding/
├── README.md                       ← you are here (GitHub homepage)
├── CONTRIBUTOR_QUICKSTART.md       ← 10-min orientation after install
├── install.sh                      ← idempotent installer; only touches ~/.claude/
├── claude-files/
│   ├── CLAUDE.md                   ← contributor's ~/.claude/CLAUDE.md template
│   └── MEMORY.md                   ← starter memory index
├── settings/
│   └── settings.json               ← permissions + model template
├── docs/
│   ├── SESSION-PLAYBOOK.md         ← THE ritual — read at first session start
│   ├── LESSONS_LEARNED.md          ← curated wisdom from prior contributors
│   └── CROSS-FEEDBACK.md           ← how to feed lessons back to the kit
├── scripts/
│   └── file-feedback.sh            ← one-command feedback filing
└── .github/
    └── ISSUE_TEMPLATE/             ← correction / win / gap / feature
```

## Cross-feedback loop

The kit gets better as contributors use it. If during a session you notice:

- A protocol that didn't work → file a `feedback:correction` issue
- A pattern that worked unusually well → file a `feedback:win` issue
- Context you needed that wasn't there → file a `feedback:gap` issue

```bash
bash ~/code/vibecoding/scripts/file-feedback.sh
```

Or [open an issue directly](https://github.com/International-AI-Design/vibecoding/issues/new/choose).

Johnny curates issues weekly. Patterns get promoted into [`docs/LESSONS_LEARNED.md`](docs/LESSONS_LEARNED.md) or `claude-files/CLAUDE.md`. The next contributor inherits a sharper kit. Full protocol in [`docs/CROSS-FEEDBACK.md`](docs/CROSS-FEEDBACK.md).

---

## Status + license

**Status:** v0.2 — adds the session playbook, lessons-learned log, and cross-feedback protocol that v0.1 was missing. Ready for first contributor end-to-end.

**License:** Not yet open-source licensed. This repo is published for the convenience of the IAID team and the developers Johnny works with directly. If you want to fork it or use the pattern, message Johnny first.

**Maintainer:** Johnny Fermin-Robbins ([@Fermin-Robbins](https://github.com/Fermin-Robbins)) / IAID — Ferro Consulting LLC.
