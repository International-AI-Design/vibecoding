# Spec — <feature name>

> **Template.** [Layer 1](../docs/THE-METHOD.md#layer-1--the-spec) of the method.
>
> Fill this in **with Claude, collaboratively** — not alone, and not by having it guess. The point isn't the document; it's the conversation that produces it. A spec you wrote by yourself in five minutes has all the same assumptions your head had.

---

## The real goal

<!-- NOT the task. The decision this is supposed to enable, or the outcome it's supposed to change.
     "Create an end-of-month report" is a task. The goal is the decision that report drives.
     The model cannot infer this. If you don't say it, it optimizes for the wrong thing — convincingly. -->

**The task, as stated:**

**The actual goal underneath it:**

**How I'll know it worked:**

> 💡 Stuck on this section? Ask Claude: *"Interview me to identify the actual goal here before we write anything."*

---

## Out of scope

<!-- Explicit non-goals. This is doing more work than it looks like — it's the fence
     that keeps a small change from quietly becoming a large one. -->

-

---

## User stories

```
As [a specific role],
I want [a specific outcome],
So that [a real benefit lands].
```

---

## Acceptance criteria

<!-- Observable conditions. User-rooted, not code-rooted.
     ❌ "confirmBooking() sets status to confirmed"
     ✅ "the user sees the booking as Confirmed within 2 seconds" -->

| # | Criterion | How it gets verified |
|---|---|---|
| 1 | | |
| 2 | | |
| 3 | | |

### Edge cases
<!-- Empty input. Bad input. Slow network. No network. Double-tap. Expired session.
     If it's not listed here, it will not be tested. -->

-

---

## Checkpoints

<!-- Agile, not waterfall. Small chunks, each ending in a review.
     Handing over the whole thing at once feels efficient and isn't —
     every unreviewed step compounds drift. -->

| # | Chunk | Stop and show me |
|---|---|---|
| 1 | | |
| 2 | | |

---

## Key decisions requiring explicit sign-off

<!-- Every ambiguity left here is a coin flip Claude makes on your behalf,
     and you don't get to see it land until later. Surface them now. -->

| Decision | Options | Chosen | Confirmed by |
|---|---|---|---|
| | | | |

---

## The prompt to open with

```text
Before building anything: interview me to find the real goal behind this
request (not just the task). Then draft a detailed spec — biased toward
small, compartmentalized chunks with a clear checkpoint after each one.
Flag every key decision explicitly and let me confirm it before you proceed.
```
