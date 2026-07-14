# The Method

> The core of the AI Design System. Everything else in this kit is machinery for making these three layers automatic.

If you read one file, read this one.

---

## The premise

LLMs are **superhuman at things that can be verified**, and unreliable at things no one ever gave them a signal for. That asymmetry is not a bug you can prompt your way out of — it's a direct consequence of how the models were trained (reinforcement learning against measurable reward). Code and math are dense with verifiable signal. "Is this the right call for my business?" has none.

Andrej Karpathy's framing of what LLMs actually are is worth internalizing, because it kills a whole category of wasted effort:

> They are not "animals" — evolved intelligences with intrinsic motivation you can appeal to. They are **ghosts**: "imperfect replicas, a kind of statistical distillation of humanity's documents."

Practical consequence, in his words: *"if you yell at them, they're not going to work better or worse."* Motivation, pride, urgency, flattery, threats — the levers that move people — do **nothing** here. There is exactly one lever that reliably changes output quality, and it's how you've engineered verification.

That's the whole game. Three layers make it operational.

```
   SPEC          →   what you actually want, precisely enough that
                     ambiguity isn't silently resolved by a coin flip

   VERIFIER      →   a feedback loop against reality, so "done" is
                     observed, not claimed

   ENVIRONMENT   →   a workshop that compounds instead of resetting
                     every session
```

---

## Layer 1 — The Spec

**Plan Mode is not a spec.** Plan Mode is a feature; a spec is a discipline. Karpathy is explicit that he doesn't even like plan mode — *"there's something more general here where you have to work with your agent to design a spec that is very detailed."* Collaborative, detailed, and treated as durable documentation — not a disposable pre-flight checklist.

### 1. Uncover the goal, not the task

A **task** is "create an end-of-month report." A **goal** is the decision that report is supposed to drive. The model cannot infer this. If you don't hand it over explicitly, it will optimize for the wrong thing — *convincingly*, which is what makes it expensive.

> **Try this:** *"Interview me to identify the actual goal of this project before we write a spec."*

### 2. Be agile, not waterfall

Handing over the whole task at once *feels* efficient. It isn't — every unreviewed step compounds drift. Tight scope → checkpoint → review → adjust → repeat.

> **Try this:** *"Bias toward smaller, compartmentalized specs. Stop and show me the result at each checkpoint before continuing."*

### 3. Be precise

Every ambiguity in a spec is a coin flip the model makes on your behalf — and you don't get to see the coin land until much later. Precision isn't pedantry. It's the act of transferring your understanding into a form that removes assumptions.

> **Try this:** *"Make me verify key decisions explicitly before you proceed, so nothing gets assumed silently."*

### The composite prompt

```text
Before building anything: interview me to find the real goal behind this
request (not just the task). Then draft a detailed spec — biased toward
small, compartmentalized chunks with a clear checkpoint after each one.
Flag every key decision explicitly and let me confirm it before you proceed.
```

---

## Layer 2 — The Verifier

This is the highest-leverage layer, and the one most people skip.

From **Boris Cherny**, who actually created Claude Code at Anthropic:

> "Give Claude a way to verify its work. If Claude has that feedback loop, it will **2–3x the quality** of the final result."

That is not a figure of speech about being thorough. It is a claim about a mechanism. Verification isn't a checklist the model fills in at the end — it's a **loop the model runs against reality** before it reports back: a bash command, a test suite, a live browser, a real deploy, a phone simulator. Whatever actually touches the thing being built.

### 1. Set evaluation criteria up front, precisely

Vague: *"make this report look good."*
Precise: *"the report must have three sections, each ending in a recommendation."*

Precision *before* the work starts is what gives verification something concrete to check against. This is the same discipline as Layer 1, pointed at the finish line instead of the start.

### 2. Use a second model as critic

A different model has different training data and therefore **different blind spots**. It catches what the first model is systematically unable to see — the same reason human code review works between two equally skilled engineers. The point is model diversity, not any particular vendor.

### 3. Pull in real external signal

Self-report is not verification.

"Did the deploy succeed?" — answered by re-reading your own deploy script — is **not** the same as querying the actual running system. Connect the session to the real target. Let it check real state.

> **The test:** if the model's claim that something works would survive you personally clicking the thing, it's verified. If it wouldn't, it's a guess with good grammar.

### The composite prompt

```text
State precise evaluation criteria before starting. Where the build is
complex, get a second model's independent read before declaring it done.
Wherever possible, verify against the real system (live deploy, running
tests, an actual browser) rather than self-report — don't tell me
something works until you've actually watched it work.
```

---

## Layer 3 — The Environment

Spec = the blueprint. Verifier = the quality-check station. **Environment = the workshop itself.**

Most people rebuild the workshop from scratch every session. A single long chat thread is *not* an environment — it doesn't compound, it just gets long.

### 1. A real `CLAUDE.md`

Injected automatically, first thing read, every session. Treat it as **durable working memory, not documentation**.

The move most people miss: put **forcing rules** in it. A line like *"before building anything multi-step, include a verification plan"* makes Layer 2 non-optional instead of something you have to remember to ask for every time.

Check it into git. Edit it **every time the model gets something wrong** — that's the loop that makes the environment learn.

### 2. A knowledge base that compounds

Not a folder of raw files. An *incremental compilation* of your material into **summaries, entity pages, concept pages, contradictions, cross-links, and an evolving synthesis**.

The point isn't storage — it's making your own understanding **retrievable**, so the model can pull the right slice instead of you re-explaining context every session. In Karpathy's words: *"your data is your moat."* This is the beginning of durable intellectual property, not a convenience feature.

See [`MEMORY-ARCHITECTURE.md`](MEMORY-ARCHITECTURE.md) for how to actually build one.

### 3. Skills for anything you do twice

If you'll do it more than once, it becomes a skill — a handbook for a specific task, not a one-off instruction.

Skills only get good through **repeated real use exposing where they break**. The plumbing rule: *the best way to find a leak in a hose is to run water through it.*

### 4. Guardrails, enforced at the right layer

This distinction is the one that actually matters:

| | |
|---|---|
| A rule in `CLAUDE.md` — *"don't touch `/dont-edit/`"* | **A request.** The model can still violate it. It's a prompt-level suggestion. |
| A **PreToolUse hook** that inspects the path and blocks the write | **A rule.** Enforced mechanically, at the tool layer. |

**Sentences are requests. Hooks are rules.**

Sort everything you care about into three buckets:

- **Always do** → autopilot, no confirmation needed (pre-allow specific permissions)
- **Ask first** → worth a human glance before it happens
- **Never do** → **must be a hook**, not a sentence

> ⚠️ Pre-allow *specific* safe commands rather than reaching for `--dangerously-skip-permissions`. Turning the safety system off entirely is not the same as configuring it.

### Concrete environment moves

Straight from Cherny's own practice:

- **One `CLAUDE.md` shared with the team, checked into git.** Everyone contributes to it several times a week.
- **`.claude/commands/`** — slash commands for repetitive inner-loop actions (`/commit-push-pr`).
- **`.claude/agents/`** — named, reusable subagent workflows (`code-simplifier`, `verify-app`).
- **PostToolUse hook for auto-formatting** — catches the mechanical last 10% without asking the model to remember.
- **MCP for real tool access** — this is how Layer 2's "external signal" actually gets wired up.
- **Stop hooks** to verify long-running tasks actually finished *correctly*, not just that the process exited.
- **Start in Plan Mode**, switch to auto-accept once the plan is right. (Layer 1 → execution, as a keybinding habit.)
- **Run several sessions in parallel** when work is genuinely parallelizable. What makes this safe is Layers 1 and 2 — not the parallelism.

### The audit prompt

Point this at your own setup once a quarter:

```text
Audit my current CLAUDE.md, hooks, skills/subagents, and permission
settings. Tell me: (1) what's currently a prompt-level request that
should be a hook-enforced rule, (2) what I do repeatedly that has no
skill/subagent/slash-command yet, (3) whether my CLAUDE.md is actually
git-tracked and shareable, and (4) anything stale or dead still running
that I've stopped relying on.
```

---

## The one thing underneath all three

> "You can outsource your thinking, but you can't outsource your understanding."
> — Andrej Karpathy

All three layers exist to get **your** understanding into a form the model can act on (spec), be checked against (verifier), and that compounds instead of resetting (environment).

They are **not a substitute for having a clear model of the goal yourself.** They're the plumbing for delivering that model.

More infrastructure without more of your own understanding behind it doesn't move the needle. That's the trap — and it's a seductive one, because building infrastructure *feels* like progress.

---

## Sourcing note

This method is a synthesis, and it's worth knowing what came from where — partly for intellectual honesty, partly because the primary sources are richer than any summary of them.

- **Andrej Karpathy** — the verifiability thesis, "animals vs ghosts," spec design, the knowledge-base concept, and the closing line. His own framework (Sequoia AI Ascent 2026) is actually *five* skills, not three layers: spec design, diff review, judgment/taste, security oversight, fundamental understanding.
- **Boris Cherny** — Claude Code's creator at Anthropic. The verification-loop claim and nearly all the concrete environment tactics. A different person from Karpathy; his material is the most directly relevant here because it's about Claude Code specifically rather than AI coding in general.
- **The "three layers" shape itself** is a third-party repackaging of the above. It holds up as a teaching frame, but it's thinner than the primaries — especially on the environment layer.

**Sources:**
- [Karpathy — Sequoia Ascent 2026](https://karpathy.bearblog.dev/sequoia-ascent-2026/)
- [Karpathy — Animals vs Ghosts](https://karpathy.bearblog.dev/animals-vs-ghosts/)
- [Boris Cherny — 13 tips](https://x.com/bcherny/status/2007179861115511237)
- [Anthropic — Claude Code best practices](https://www.anthropic.com/engineering/claude-code-best-practices)
