# run-progress

Maintain a per-run progress log separate from knowledge output.

## Location
`knowledge/.runs/<YYYY-MM-DD>-<mode>-<HHMM>.md`

Example: `knowledge/.runs/2026-03-30-burn-1430.md`

The `HHMM` suffix (24h local time at run start) prevents collisions when multiple runs happen on the same day.

## Format

```markdown
# Bottom Feeder Run — YYYY-MM-DD (mode)

**Started:** <ISO timestamp>
**Model:** <model used>
**Mode:** routine | burn | fleet
**Topics planned:** <count or "all from list">
**Parallelism:** <1 = sequential, N = concurrent sub-agents>
**Budget:** <balance if available, otherwise "not tracked">

## Topics

### 1. <Topic Name> — <status>
- **Status:** done | partial | skipped | in-progress
- **Sources used:** brave, perplexity, ...
- **Output:** `knowledge/topics/<slug>.md`
- **Confidence:** high | medium | low
- **Duration:** ~Xm
- **Notes:** <anything notable>

### 2. <Topic Name> — ...

## Run Summary
- **Topics planned:** X
- **Topics done:** X
- **Topics partial:** X
- **Topics skipped:** X
- **Total sources queried:** X
- **Follow-up candidates:** <topics needing a second pass>
- **Budget used:** <estimate if available, otherwise omit>
- **Ended:** <ISO timestamp or "interrupted">
```

## Rules
- Update this file AFTER each topic completes (not batched at end).
- If the run is interrupted, the log still reflects everything completed so far.
- This file is the audit trail; knowledge files are the deliverables.
- For fleet runs with 10+ topics, use compact table format instead of per-topic sections:
  `| # | topic-slug | status | confidence | duration | output-path |`
  Save detail for the knowledge files themselves.
- If a run resumes from a prior interruption, append a `## Resumed` section rather than overwriting.
