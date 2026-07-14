# Memory Index — starter

**Installed at:** `~/.claude/MEMORY.md`

> This is the **index**, not the content. One line per memory: a pointer and a hook.
>
> It's loaded every session, so every line here is a tax you pay forever. Earn it. Detail goes in individual memory files; this file just tells the model what exists and when to go get it.
>
> Architecture, and how this grows: `~/.claude/ads/MEMORY-ARCHITECTURE.md`

---

## Critical Corrections (always inline)

> Facts that are **expensive to get wrong** and that a model will get wrong **by default**.
>
> This is the highest-value section in your entire setup. A wrong-by-default fact stays wrong in every future session until it's pinned here.
>
> Bar for entry: *(1)* costly if wrong, *(2)* the model won't guess it correctly, *(3)* it isn't discoverable by just looking. That third test kills most candidates — if a `grep` would answer it, don't spend permanent context on it.

<!-- Examples of the shape (delete these, they're not yours):

- **Tool X is deprecated here — use Y.** X looks right and silently no-ops.
- **"Staging" means the client's QA box, not our preview deploy.** Getting this wrong has emailed real customers.
- **Never run <command> against the prod DB.** It bypasses the audit log.

-->

_(empty — fill as you go)_

---

## Projects

<!-- - [Project name](path/to/memory.md) — one-line hook: why you'd open it -->

_(none yet)_

---

## People

<!-- Who they are, and the thing about them that's easy to get wrong. -->

_(none yet)_

---

## Feedback / Preferences

<!-- How you like to work. Corrections you've given that should stick.
     Always include the WHY — a rule without a reason gets misapplied at the edges. -->

_(none yet)_

---

## Reference

<!-- Pointers outward: dashboards, runbooks, docs, tickets. -->

_(none yet)_

---

## How this file grows

Don't build the whole structure up front — the sections above are mostly empty on purpose.

1. **Start with Critical Corrections.** Every time Claude gets something wrong, add one line.
2. When a line needs more than a line, **split it into its own memory file** and leave a pointer here.
3. When you have a dozen memory files, the categories above start earning their keep.

Let the leaks tell you where to put the pipes.
