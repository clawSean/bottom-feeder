---
name: bottom-feeder
description: >
  Knowledge research pipeline. Selects topics, researches using all available tools, synthesizes durable notes, and writes to knowledge/topics and knowledge/research. Modes: routine (1-2 topics), burn (N topics), fleet (external topic list, parallel dispatch). Works with any provider.
---

# Bottom Feeder

4-stage pipeline: select → collect → synthesize → write.
Depth over breadth. Write after every topic. Never batch.

## Inputs

1. `config/defaults.yaml`
2. `config/topics.md` — seed topic list
3. `config/next-topic.md` — force-priority override (if present)

## Modes

### Routine (default)
- 1-2 topics, cost-conscious source usage, concise output.
- Quiet completion unless user asked for a report.

### Burn (explicit request)
- N topics, all available sources enabled.
- Steps:
  1. Run `scripts/provider-usage.sh` (best-effort, continues on failure).
  2. Keep reserve from config (`min_reserve_usd`) if balance data is available.
  3. Use all available sources aggressively.
  4. Write after every topic.
  5. Stop gracefully if provider limit is hit.
  6. Set cron safety nets per `references/output/burn-continuity.md`.
  7. After 80%+ complete, shift to strategic synthesis.

### Fleet (explicit request or topic list file provided)
- Accepts a topic list file path (markdown or plain text).
- Steps:
  1. Parse the topic list file. H2/H3 headings = topic names, body text under heading = context. Bullet items = topics, sub-bullets = context. Plain text: one topic per line. Extract topic name + any per-topic description.
  2. Run `scripts/provider-usage.sh` (best-effort, continues on failure).
  3. Create run progress log: `knowledge/.runs/<date>-fleet-<HHMM>.md`.
  4. Set cron safety nets per `references/output/burn-continuity.md`.
  5. Dispatch topics using orchestrator pattern (see below).
  6. Checkpoints at 25%, 50%, 75% or hourly — whichever comes first.
  7. After 80%+ complete, shift to strategic synthesis.
- **Orchestrator pattern:** the main session assigns topics, tracks completion, and reports. Each topic research is self-contained.
- **Parallelism preferred, not required.** When `sessions_spawn`, sub-agents, or similar tools are available, dispatch topics concurrently up to `parallelism` from config. When unavailable (single-session, limited provider), process sequentially through the same pipeline. Never block or fail because parallelism is unavailable.
- **Sub-agent context:** each spawned sub-agent needs: (1) topic name + description from the list, (2) the knowledge-writer format spec from `references/output/knowledge-writer.md`, (3) the quality gate from `references/quality-gate/completion-checklist.md`, (4) output directory paths from config. Do not inject the full SKILL.md — keep prompts focused.
- **Sub-agent failure handling:** if a sub-agent dies, times out, or returns an error: log the topic as `status: failed` in the run progress log with the error reason, then continue with the next topic. Do not retry automatically — failed topics become follow-up candidates in the run summary. The orchestrator should never crash because a sub-agent failed.
- The orchestrator maintains the run progress log and writes strategic synthesis after all topics complete.

## Pipeline

### Stage 1: Select topic

**Skip when topics are provided directly** (ad-hoc, burn with explicit list, fleet mode, or `config/next-topic.md`). Go straight to Stage 2.

When selection is needed:
1. `references/topic-selection/context-driven.md` — mine workspace context (PRIMARY)
2. `references/topic-selection/department-playbooks.md` — per-department guides
3. `references/topic-selection/hardcoded-list.md` — seed list + external file fallback

Combine candidates, dedupe, score by Urgency × Impact × Knowledge Gap, pick top N.

Before finalizing, check `knowledge/` for existing coverage. Strong + recent coverage → skip to next candidate.

### Stage 2: Collect research

Follow `references/research-sources.md`.

**Core principle: use ALL tools available in your current environment.** Do not default to a single search provider. Triangulate across source categories.

Before external searches, check local knowledge (`knowledge/`, `memory/`) for existing coverage.

Source strategy by topic type:
- **Operational/team topics:** internal tools first (Asana, Slack, Intercom), then web for best practices.
- **Technical/code topics:** clone repos, read source code, then web for docs and community context.
- **Market/competitive topics:** web search + structured APIs, then social for sentiment.
- **Strategic/synthesis topics:** local knowledge + internal tools, then web to validate.

**Cost awareness:** routine mode uses 1-2 search queries + local knowledge. Burn/fleet mode uses everything aggressively.

### Stage 3: Synthesize + quality gate

One durable, standalone knowledge artifact per topic:
- What it is
- Current state
- Why it matters (for the user's ecosystem/team/work)
- Key entities/projects
- Open questions + what to watch
- Sources with dates

For updates, prepend a "What's new" section. For department playbooks, follow `references/topic-selection/department-playbooks.md`.

**Quality gate:** run `references/quality-gate/completion-checklist.md` before advancing. Every section must pass or be tagged `[INCOMPLETE: reason]`.

**Checkpoints (burn/fleet):**
- After topic 5 (or 25% in fleet): offer user calibration review of 2-3 files.
- After topic 15 (or 50% in fleet): check context — if >60%, consider fresh session; if >70%, strongly prefer it.
- Hourly: `session_status` for context % and provider state.

### Stage 4: Write output

Use:
- `references/output/knowledge-writer.md` — file format
- `references/output/run-progress.md` — audit trail
- `references/output/lobsearch-index.md` — search index refresh (best-effort)
- `references/output/strategic-synthesis.md` — cross-topic action plans
- `references/output/burn-continuity.md` — cron safety nets for long runs

Write immediately after each topic clears quality gate.
Update run progress log after every write: `knowledge/.runs/<date>-<mode>-<HHMM>.md`.

## Ad-hoc topic injection

"Run bottom feeder on [topic1, topic2, ...]"
- Skips Stage 1. No limit on topic count.
- Quality gate and progress logging still apply.

## Phased burn (team deployments)

**Phase 1 — Context gathering (15-30 min):** Mine workspace, score topics.
**Phase 2 — Topic burn (bulk):** Priority order. Checkpoints after 5 and 15.
**Phase 3 — Department playbooks (15-20%):** Per-department guides with live task data.
**Phase 4 — Strategic synthesis (10-15%):** Priority matrix, competitive positioning, action items. See `references/output/strategic-synthesis.md`.

## Guardrails

- Never spend to zero unless user explicitly says to.
- Skip duplicate rewrites when no meaningful updates exist.
- Prefer local/free sources before paid ones.
- Weak sources → write partial with `[INCOMPLETE: reason]` tags.
- Split oversized output into follow-up research files.
- Log all sources used (tool, URL, date) in every output file.
- Link every synthesis recommendation to its supporting knowledge file.
