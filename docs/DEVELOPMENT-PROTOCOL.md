# Development Protocol — Stories, Acceptance Criteria, Definition of Done

> The verifier layer, operationalized. [THE-METHOD](THE-METHOD.md) says "give the model a way to verify its work." This is that way, written down.

**Applies to:** any task producing an artifact a human or downstream agent will use. Skip only for pure conversational scaffolding.

---

## Why this exists

Three failure modes recur, and they're expensive because they all *look like success*:

**1. Verification scope didn't match user-visible behavior.**
`curl -sI` returns `200` for a page with a dead form. `grep -c` returns the right count for HTML that renders broken on mobile. The check passed. The thing is broken. **"All clean" reports are technically true and operationally false.**

**2. "Done" was interpreted loosely.**
Without a checkable success criterion, "done" means whatever the implementer thinks it means — and a solo developer *or an agent* will rationalize partial completion when the bar is fuzzy. Not from dishonesty. From ambiguity.

**3. Edge cases were ignored because nobody surfaced them.**
Empty forms. JS disabled. Slow networks. Mobile viewports. Error states. **If they're not in the AC list, they don't get tested.**

Each section below makes one of these explicit, in the lightest form that still works.

---

## 1. User Stories

Every non-trivial task starts with at least one.

```
As [a specific role],
I want [to accomplish a specific outcome],
So that [a real benefit lands].
```

### Good

```
As a small-business owner browsing the site on my phone,
I want to tap "Book a demo" and reach a working contact path,
So that I can actually start a conversation about switching.
```

```
As a build agent verifying a website rebuild,
I want a checkable behavioral acceptance list,
So that I can't declare done by passing only string-presence checks.
```

### Bad

```
As a developer, I want to fix the website.   ← no role, no outcome, no benefit
As a user, I want a good experience.         ← every word vague
As the boss, I want this done.               ← no verifiable outcome
```

### INVEST — sanity-check the story

- **I**ndependent — delivers value without other in-flight stories
- **N**egotiable — details stay open until refined into AC
- **V**aluable — a clear benefit if shipped
- **E**stimable — you can guess the scope
- **S**mall — fits in one work session, ideally
- **T**estable — **has at least one observable success signal**

Fails INVEST → split it, refine it, or reject it.

---

## 2. Acceptance Criteria

Each story carries a list of **observable conditions that prove it's delivered.** Pick whichever format fits.

### Format A — Given / When / Then

Best for user flows, UI behavior, multi-step interactions.

```
Given I'm on /contact with name, email, and business filled,
 When I tap "Send"
 Then a POST is sent to /api/contact with all four fields,
  and I see a "Got it, we'll reply within 24 hours" state within 2 seconds,
  and a confirmation email is delivered within 60 seconds,
  and the input fields are cleared.
```

```
Given I'm on / at a 375px-wide viewport,
 When I tap the hamburger button
 Then the mobile menu opens at full height,
  and the background is opaque (no hero text bleeding through),
  and each menu item has a ≥44px touch target,
  and tapping outside dismisses the menu.
```

### Format B — Checkable outcome list

Best for backend, data, config, single-step actions.

```
- POST /api/contact with a valid body returns 200 within 2 seconds
- Response body includes { ok: true }
- The email provider's dashboard shows it queued within 5 seconds
- No new rows are written to the customer data table
- The console is silent during the request — no warnings, no errors
```

---

## 3. The discipline rules

These are what make ACs actually work. Each one exists because skipping it cost real time.

### Every AC item is an observation, not an aspiration

> ❌ "The form is good."
> ✅ "POST /api/contact returns 200 within 2 seconds."

If you can't observe it, you can't verify it, and it will be declared done on vibes.

### ACs are user-rooted, not code-rooted ← **the most important rule here**

Acceptance criteria describe what the **user experiences**. Not what the code does.

> ❌ "When `confirmBooking()` is called, `Booking.status` transitions to `confirmed`."
> ✅ "When the user taps Confirm, the booking shows as Confirmed in the list within 2 seconds."

**Why this matters more than it looks:** code-rooted ACs verify the implementation *in isolation* — and every real bug lives at the integration boundary the isolated test never crosses. The user-rooted version forces end-to-end verification because there's no way to satisfy it without actually running the flow.

Corollary: **if you can't write a user-rooted AC, the user value isn't clear yet.** Go back to the story.

### Name the verification mechanism *per AC*

Not "we'll test it." *How?*

| AC type | Mechanism |
|---|---|
| UI behavior | Drive it in a real browser at desktop + mobile widths; screenshot |
| API endpoint | Integration test against the real handler |
| Schema change | Migration applied + a real query exercising the new shape |
| Bug fix | A reproducer that **failed before** the fix and passes after |
| Refactor | Existing tests + a new one pinning the public API |
| Docs / memory | `grep` + `diff` proving presence and linkage |

### Edge cases are ACs or they don't exist

Empty input. Invalid input. The network is slow. The network is *gone*. The user double-taps. The session expired mid-flow.

Put them in the list, or accept that nobody will check them.

---

## 4. Definition of Done

> **Done = every AC item verified by execution.**

Not by inspection. Not by "it compiles." Not by "tests are green."

Tests passing is **necessary but not sufficient** — and the gap between those two is where shipped bugs live.

### The exit gate

Your PR body (or task summary) contains:

```markdown
## Story
As a [role], I want [outcome], so that [benefit].

## Acceptance criteria
- [x] AC1 — …  ✅ verified by: `booking.integration.test.ts::confirms within 2s`
- [x] AC2 — …  ✅ verified by: browser walk @1440 + @375 — screenshot below
- [x] AC3 — …  ✅ verified by: `grep -n "capacityOverride" src/ | diff …`

## Not covered
- [ ] Offline behavior — out of scope, filed as #123
```

**If you can't fill that in, it isn't done.**

The "Not covered" section is not optional either. Silent gaps read as coverage. If you bounded the work, *say where* — an honest boundary is worth more than an implied completeness that was never true.

---

## 5. Applying this to agents

When you brief a subagent, the brief carries the **story + AC + the named verification mechanism.**

Agents don't get to declare done unilaterally. Neither do you. The rule is symmetric on purpose — "the agent said it was done" is exactly as weak as "I felt like it was done," and for exactly the same reason.

> The point of the whole protocol, in one line: **make it impossible to be vague about whether something worked.**
