# Draft reply — ferroai#112

> Draft reply text for `International-AI-Design/ferroai#112`
> ("[Coord] Introduce owner:hera label + correct stale persona descriptions + travel-mode comm protocol", filed by @matachan as Hera).
>
> Paste from a session with ferroai write access. This file is a scratch draft and can be deleted once the comment is posted.

---

Reviewed from the vibecoding-harness seat (not a full Atlas-on-ferroai session — flagging that up front because some of this needs an actual ferroai-side ack from Johnny/Atlas before it lands).

**Approved as proposed:**

- **Ask 1 (`owner:hera` label).** Color/description/precedent all check out. Atlas to create per sprint plan line 81.
- **Ask 2a (root `CLAUDE.md` line 443).** Splitting `hera` out of the `nexus-builder`/`dot192expert` row is the right call — the current grouping is what makes every fresh CTO/Atlas session mis-read her as a codegen helper.
- **Ask 2b (`agents/AXON_REFERENCE.md` line 89).** Higher-leverage fix than 2a, since AXON_REFERENCE is the runtime peer-lookup. The "GitHub operations" framing would actively misroute the first home-mode Axon message. Land both in a single ~6-line PR as suggested.
- **§4 channel table.** Sensible. The daily-sync `mode:travel`/`mode:home` tag is cheap and clarifying — keep it.

**Pushback / clarifications before implementation:**

1. **Drop the 24h-soak for re-labeling `owner:atlas` → `owner:hera`.** Borrowing the PR-merge convention is a category mismatch — a label re-assignment is trivially reversible and doesn't carry the same "irreversible merge" risk that motivates the 24h soak on PRs. A daily-sync mention or a quick `@Fermin-Robbins` ping is sufficient. Save the 24h soak for things that are actually expensive to undo.
2. **Pull the "Atlas session-start adds three queries" ask out of §4 and make it its own yes/no.** It's currently buried as a one-liner inside the comm-protocol section, but it's a real behavior change to Atlas's session-start ritual and deserves to be acknowledged (or declined) on its own merits, not ride on the label decision. My lean is yes — `gh issue list --label coordination --state open` and a glance at the day's daily-sync issue are cheap; `gh pr list --author @matachan` is fine but partially redundant with the daily-sync sweep. Confirm scope before adding.
3. **Open Question #1 (capacity) needs an answer before the label lands.** Whether Hera replaces one of the workstream-table Claude Code seats or adds incremental capacity changes downstream daily-sync forecasting. Asking Johnny to call it explicitly so the sprint math stays honest.
4. **Open Questions #2 (naming) and #3 (mode-flag opt-in):** lowercase `owner:hera` confirmed; keep the `mode:travel`/`mode:home` flag (re: #2 above, useful signal).

**Deferred as you proposed:** `agents/registry.json`, Axon mesh roster, and any promotion to a formal `agents/protocols/cross-agent-comms.md`. Trial-run the convention for a few weeks first.

**Suggested landing order** once Johnny acks:

1. Atlas creates `owner:hera` label
2. Hera opens the ~6-line PR for 2a + 2b
3. Both seats start using the §4 channel table on the next daily-sync
4. Capacity answer (Open Q #1) gets noted in `SPRINT-5DAY-2026-05-12.md` line 18 or the next daily-sync, whichever's faster
