# Memory Architecture

> Layer 3 of [THE-METHOD](THE-METHOD.md), made concrete. This is how a workshop compounds instead of resetting.

A single long chat thread is not memory. It doesn't accumulate — it just gets long, and then it gets summarized, and the summary quietly loses the one detail that mattered.

Real memory is **layered, ranked, and small**. Every layer below has a job, and the ordering matters: when two layers disagree, you need to know which one wins *before* the disagreement happens.

---

## The layers (top wins on contradiction)

```
┌──────────────────────────────────────────────────────────────┐
│ 1. CRITICAL CORRECTIONS                          always loaded│
│    Hand-curated. Things that were wrong and must never        │
│    be wrong again. Costs tokens every session — earn it.      │
├──────────────────────────────────────────────────────────────┤
│ 2. MEMORY INDEX                                  always loaded│
│    One line per memory. Pointers, not content.                │
├──────────────────────────────────────────────────────────────┤
│ 3. MEMORY FILES                                   on demand   │
│    One fact per file. Loaded when relevant.                   │
├──────────────────────────────────────────────────────────────┤
│ 4. ROOT CLAUDE.md                                always loaded│
│    Wide, deep context for the domain you work in.             │
├──────────────────────────────────────────────────────────────┤
│ 5. PROJECT CLAUDE.md                     loaded in that repo  │
│    Narrower scope. Must reconcile with everything above.      │
├──────────────────────────────────────────────────────────────┤
│ 6. THE VAULT                                   searched only  │
│    Everything else. Never auto-loaded. Retrieved on demand.   │
└──────────────────────────────────────────────────────────────┘
```

**The rule that makes this work:** each layer must *reconcile* with the ones above it. If a project `CLAUDE.md` contradicts a critical correction, the correction wins and **the project file is a bug to be fixed** — not a difference of opinion to be tolerated.

---

## What earns a slot in always-loaded context

Almost nothing. Be ruthless here — every always-loaded token is a tax on every session forever, and dilutes attention on the task that's actually in front of you.

A fact earns permanent residency only if:

1. **Getting it wrong is expensive**, and
2. **The model will get it wrong by default** (it's counterintuitive, or contradicts a plausible assumption), and
3. **It won't be discovered by looking** (it isn't derivable from the code, the git history, or a quick search)

That third test kills most candidates. Code structure, past fixes, what a function does — the model can just *look*. Don't spend permanent context on something a `grep` would answer.

### What passes the test

Corrections. Specifically: **the things the model confidently got wrong once already.**

That's the highest-signal memory there is, because a wrong-by-default fact will keep being wrong by default, in every future session, until you pin it down. Everything else can be looked up.

> **The habit that makes this compound:** every time the model gets something wrong, write the correction down *immediately*, in the always-loaded layer. Not "later." Later never comes, and the next session makes the same mistake.

---

## One fact per file

Memory files are **not documents.** Resist the urge to write a nice essay about a topic. One file = one fact = one thing that can be true or false.

```markdown
---
name: short-kebab-case-slug
description: One line. This is what gets matched during recall — write it well.
metadata:
  type: user | feedback | project | reference
---

The fact itself, stated plainly.

**Why:** the reason it matters (for feedback/project types).
**How to apply:** the trigger — when should this change what I do?

Related: [[another-memory-slug]]
```

**Why one-fact-per-file matters:** retrieval. A file about seven things matches every query about any of them, and drags six irrelevant facts into context each time. A file about one thing matches precisely and costs precisely.

**The `description` line is the most important line in the file.** It's what a retrieval system reads to decide whether to load the rest. A vague description means a good fact that never gets recalled — which is the same as not having written it.

### The four types

| Type | What it holds |
|---|---|
| `user` | Who the person is — role, expertise, preferences |
| `feedback` | Guidance on *how to work* — corrections and confirmed approaches. **Always include the why.** |
| `project` | Ongoing work, goals, constraints not derivable from the code |
| `reference` | Pointers to external resources — URLs, dashboards, tickets |

---

## Link liberally

Use `[[slug]]` to link related memories. A link to a memory that **doesn't exist yet** is not an error — it's a marker for something worth writing later. Let the graph tell you where the holes are.

---

## Memory hygiene

Memory rots. An unmaintained memory system is worse than none, because it lends stale facts the authority of having been written down.

Three standing rules:

**Convert relative dates to absolute.** "Last week" is a time bomb. It was true when written and is a lie forever after. Write `2026-07-14`.

**Delete what turns out to be wrong.** Not "update with a note." *Delete.* A memory that says "X, but actually now Y" makes the reader hold two things and pick. Just say Y.

**Verify before recommending.** A memory that names a file, a flag, or a function is a claim about a system that has changed since. It reflects what was true *when written*. Check that it still exists before you act on it.

---

## The failure mode to watch for

The most dangerous thing a memory system can do is **launder a hallucination into a fact.**

It happens like this: a model infers something plausible, writes it to memory, and a later session reads it back as ground truth — now with the authority of a written record and no trace of how thin the original claim was. Do it twice and the system is citing itself.

Two defenses:

1. **Never let a model write to canonical memory unattended.** Proposals are fine. Auto-commits to the always-loaded layer are not. There must be a human approval gate.
2. **Distrust self-citation.** If the only support for a claim is another file in your own memory, it isn't verified — it's just repeated. Trace it to a real external source or a live check.

> Memory that compounds correctly is the most valuable thing you build. Memory that compounds *incorrectly* is the most expensive.

---

## Getting started (you don't need all of this on day one)

Genuinely — start with **one file**:

1. `~/.claude/CLAUDE.md` with a **Corrections** section. Every time Claude gets something wrong, add a line. That's it.
2. When it passes ~30 lines, split the detail into memory files and leave pointers.
3. When *those* pass a dozen, add an index.

The architecture above is what this grows into over months of real use. It is **not** what you build on day one. Building the whole thing up front, before you have the corrections to fill it, is exactly the "more infrastructure without more understanding" trap from [THE-METHOD](THE-METHOD.md#the-one-thing-underneath-all-three).

Let the leaks tell you where to put the pipes.
