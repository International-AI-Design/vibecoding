# VibeCoding

> A reproducible Claude Code setup for the IAID team — built around the way Johnny Fermin-Robbins ships software-on-demand for SMBs.

This repo is the **harness**, not the application. It gives a new contributor a productive Claude Code environment on their Mac in about 5 minutes. The actual platform code lives in a separate (private) repo; this kit just gets your AI dev loop running so you can contribute.

If you're new here, start with the bootstrap prompt below.

---

## The bootstrap prompt

Paste this into a fresh Claude Code session on your Mac. Claude does the rest.

```text
You're helping me get set up as a new contributor on the Animal Lovers App
SaaS platform built by IAID (International AI Design).

Walk me through these steps in order. Confirm completion of each step before
moving on to the next. If anything fails, explain why and ask me what to do.

1. Verify I have these installed on my Mac: node, pnpm, git, gh (GitHub CLI),
   and `claude` (Claude Code CLI). If any are missing, give me the brew/npm
   command to install them.

2. Clone https://github.com/International-AI-Design/vibecoding to
   ~/code/vibecoding (or, if it's already there, `git pull` to refresh).

3. Run `bash ~/code/vibecoding/install.sh`. It will back up any existing
   ~/.claude config files, then install the contributor's CLAUDE.md, MEMORY.md,
   and settings.json templates.

4. Verify the install by reading ~/.claude/CLAUDE.md and confirming it's the
   IAID VibeCoding contributor kit (the file starts with the line
   "# Animal Lovers App — Contributor CLAUDE.md").

5. Read ~/code/vibecoding/CONTRIBUTOR_QUICKSTART.md and summarize for me:
   - the project's tech stack
   - the "things you should NOT do" list
   - the three discipline rules

6. Ask me my GitHub handle so I can request access to the private platform
   repo. If I don't have access yet, tell me to message Johnny
   (@Fermin-Robbins) to be added as a collaborator on
   International-AI-Design/ferroai.

7. Once I have access, walk me through:
       gh repo clone International-AI-Design/ferroai ~/code/ferroai
       cd ~/code/ferroai/workspaces/platform
       claude

8. When the new Claude Code session opens in `workspaces/platform`, the
   SessionStart hook will print today's sprint board. Help me pick an open
   issue I should start with — prefer `area:customer-app`, `area:tests`,
   or anything labeled `good-first-issue`.

9. Help me set up a feature branch and open my first PR.

Throughout this process: NEVER skip the verification steps. If `install.sh`
fails, do not paper over it — show me the exact error.
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
├── README.md                    ← you are here (GitHub homepage)
├── CONTRIBUTOR_QUICKSTART.md    ← 10-min orientation after install
├── install.sh                   ← idempotent installer; only touches ~/.claude/
├── claude-files/
│   ├── CLAUDE.md                ← contributor's ~/.claude/CLAUDE.md template
│   └── MEMORY.md                ← starter memory index
└── settings/
    └── settings.json            ← permissions + model template
```

---

## Status + license

**Status:** v0.1, working. The first contributor (Rob) hasn't run it end-to-end yet — when he does, expect a quick polish PR or two.

**License:** Not yet open-source licensed. This repo is published for the convenience of the IAID team and the developers Johnny works with directly. If you want to fork it or use the pattern, message Johnny first.

**Maintainer:** Johnny Fermin-Robbins ([@Fermin-Robbins](https://github.com/Fermin-Robbins)) / IAID — Ferro Consulting LLC.
