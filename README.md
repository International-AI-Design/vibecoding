# The AI Design System

**v0.3** · a reproducible Claude Code setup

> Most people using Claude Code are getting a fraction of what it can do — not because they're prompting badly, but because they're missing the machinery around the prompt.
>
> This is that machinery. It's the system [Johnny Fermin-Robbins](https://github.com/Fermin-Robbins) uses to ship production software as a solo operator, packaged so you can install it in five minutes and use it on your own work.

**This is the design system itself — not a project built with it.** Nothing here assumes any particular codebase, language, framework, or domain. It's how the work gets done, not what the work is.

---

## The idea, in 60 seconds

LLMs are **superhuman at what can be verified** and unreliable at everything else. That's not a prompting problem — it's a direct consequence of how they were trained.

Which means the levers that work on people — motivation, urgency, telling it to try harder — do **nothing**. As Karpathy puts it, these are "ghosts," not animals: *"if you yell at them, they're not going to work better or worse."*

There is basically one lever that reliably changes output quality, and it's **how you've engineered verification.**

Three layers make that operational:

| Layer | The question it answers |
|---|---|
| **1. Spec** | Does the model actually know what you want — precisely enough that ambiguity isn't silently resolved by a coin flip? |
| **2. Verifier** | Can it check its own work against **reality**, before telling you it's done? |
| **3. Environment** | Does your setup **compound** across sessions, or do you rebuild the workshop every morning? |

The claim that justifies the whole thing, from **Boris Cherny — the person who built Claude Code**:

> "Give Claude a way to verify its work. If Claude has that feedback loop, it will **2–3x the quality** of the final result."

👉 **[Read THE METHOD →](docs/THE-METHOD.md)** — the one file to read if you read nothing else.

---

## Install

```bash
git clone https://github.com/International-AI-Design/vibecoding.git ~/code/vibecoding
cd ~/code/vibecoding
bash install.sh
```

**It's safe to run even if you already use Claude Code.** The installer will *never* silently overwrite an existing `CLAUDE.md`, `MEMORY.md`, or `settings.json` — if you have them, it leaves them alone and drops a `.suggested` copy next to each so you can diff and merge on your own terms. Re-running is safe. `--dry-run` shows you what it would do.

### What lands where

```
~/.claude/
├── CLAUDE.md          ← base harness — the forcing rules  (only if you don't have one)
├── MEMORY.md          ← memory index                       (only if you don't have one)
└── ads/
    ├── THE-METHOD.md            ← ★ start here
    ├── SESSION-PLAYBOOK.md      ← the session ritual
    ├── DEVELOPMENT-PROTOCOL.md  ← stories → acceptance criteria → done
    ├── MEMORY-ARCHITECTURE.md   ← how memory compounds
    ├── LESSONS_LEARNED.md       ← patterns that cost real time to learn
    └── templates/
        ├── project-CLAUDE.md    ← drop into any repo
        └── spec.md              ← the Layer-1 spec template
```

Nothing is auto-loaded except `CLAUDE.md` and `MEMORY.md`. The rest is read on demand — **that's the point.** Context you load "for completeness" is context you're not spending on the task.

---

## What's in it

### [`THE-METHOD.md`](docs/THE-METHOD.md) — the core
The three layers, with the primary sources traced. If you read one file, read this.

**The single most useful idea in here:** a rule in `CLAUDE.md` is a **request** — the model can ignore it. A **hook** is a **rule** — enforced mechanically, at the tool layer. Sentences are requests. Hooks are rules. Sort everything you care about into *always do* / *ask first* / **never do — and make that last bucket a hook.**

### [`SESSION-PLAYBOOK.md`](docs/SESSION-PLAYBOOK.md) — the ritual
Four phases: start, work, compaction-avoidance, close-out.

Contains the **3-and-10 rule** (end the session at 3+ topics or 10+ files — context degrades through summarization, and it does so *invisibly*), and the **reasoning-failures check**, which is the habit that makes the whole system compound.

### [`DEVELOPMENT-PROTOCOL.md`](docs/DEVELOPMENT-PROTOCOL.md) — the verifier, operationalized
User stories → acceptance criteria → Definition of Done.

The rule that matters most: **ACs describe what the *user* experiences, not what the code does.** Code-rooted ACs verify the implementation in isolation — and every real bug lives at the integration boundary the isolated test never crosses.

### [`MEMORY-ARCHITECTURE.md`](docs/MEMORY-ARCHITECTURE.md) — how the environment compounds
Layered memory, what earns always-loaded context (almost nothing), one-fact-per-file, and the failure mode to fear: **a system that launders its own hallucinations into facts by citing itself.**

### [`LESSONS_LEARNED.md`](docs/LESSONS_LEARNED.md) — scar tissue
Patterns that cost real time on real projects. Free to read, expensive to learn. Sample: *stubbed tests can't find stacked bugs* — a payment path was broken in **three** places, each only discoverable after fixing the one above it, and every unit test passed the whole time.

---

## Try it right now

Don't start by building. Start by making it interview you:

```text
Before building anything: interview me to find the real goal behind this
request (not just the task). Then draft a detailed spec — biased toward
small, compartmentalized chunks with a clear checkpoint after each one.
Flag every key decision explicitly and let me confirm it before you proceed.
```

Then, once you're building, the other half:

```text
Don't tell me something works until you've actually watched it work.
```

If those two prompts are all you ever take from this repo, it was worth cloning.

---

## The honest caveat

More infrastructure is not more understanding, and building infrastructure *feels* like progress in a way that's genuinely seductive.

> "You can outsource your thinking, but you can't outsource your understanding."
> — Andrej Karpathy

The three layers exist to get **your** understanding into a form the model can act on and be checked against. They are not a substitute for having a clear model of the goal yourself. If you install this and skip [`THE-METHOD.md`](docs/THE-METHOD.md), you have a folder of markdown and nothing else.

**Start small.** One `CLAUDE.md` with a Corrections section you actually update. That single habit beats the entire rest of this repo. The architecture is what it grows into after months of real use — not what you build on day one.

Let the leaks tell you where to put the pipes.

---

## Feedback loop

The kit only gets good through use — *the best way to find a leak in a hose is to run water through it.*

- A protocol that didn't work → `feedback:correction`
- A pattern that worked unusually well → `feedback:win`
- Context you needed that wasn't here → `feedback:gap`

```bash
bash ~/code/vibecoding/scripts/file-feedback.sh
```

Or [open an issue](https://github.com/International-AI-Design/vibecoding/issues/new/choose). Patterns get promoted into [`LESSONS_LEARNED.md`](docs/LESSONS_LEARNED.md), and the next person inherits a sharper kit. Protocol: [`CROSS-FEEDBACK.md`](docs/CROSS-FEEDBACK.md).

---

## Credit

The method is a synthesis, and the primary sources are better than any summary:

- **[Andrej Karpathy](https://karpathy.bearblog.dev/sequoia-ascent-2026/)** — the verifiability thesis, ["animals vs ghosts"](https://karpathy.bearblog.dev/animals-vs-ghosts/), spec design, the knowledge-base-as-moat idea
- **[Boris Cherny](https://x.com/bcherny/status/2007179861115511237)** — Claude Code's creator at Anthropic. The verification-loop claim and most of the concrete environment tactics.
- **[Anthropic — Claude Code best practices](https://www.anthropic.com/engineering/claude-code-best-practices)**

Everything else is scar tissue from shipping.

---

**Status:** v0.3 — the design system, standalone. Project onboarding lives with the projects, where it belongs. Non-destructive installer.
**License:** not yet open-source licensed. Published for the people Johnny works with directly. Want to fork it? Just ask.
**Maintainer:** Johnny Fermin-Robbins ([@Fermin-Robbins](https://github.com/Fermin-Robbins)) / IAID — Ferro Consulting LLC.
