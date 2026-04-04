---
name: bottom-feeder
description: Depth-first knowledge crawling workflow that selects 1-2 high-value topics, researches with configured sources, synthesizes durable notes, and writes/updates files in knowledge/topics and knowledge/research. Use when asked to build or refresh knowledge files, run a scheduled knowledge-crawl, detect knowledge gaps, run budget-aware research passes, or generate department playbooks and strategic synthesis documents. Supports any provider (Anthropic, OpenAI, Venice/Diem, etc.).
---

# Bottom Feeder

Run a modular 4-stage pipeline:
1) topic selection
2) research collection
3) synthesis
4) output writing

Prioritize depth over breadth. Default to 1 topic (max 2).

## Inputs to Load First

1. `config/defaults.yaml`
2. `config/topics.md`
3. If present, `config/next-topic.md` (force-priority override)

## Workflow

### 1) Select topic

Use these modules in order:
- `references/topic-selection/context-driven.md` (mine workspace context: project management, conversations, team profiles)
- `references/topic-selection/department-playbooks.md` (generate per-department operational guides)
- `references/topic-selection/hardcoded-list.md`
- `references/topic-selection/conversation-mining.md`
- `references/topic-selection/knowledge-gaps.md`
- `references/topic-selection/knowledge-refresh.md`
- `references/topic-selection/trending.md`

Combine candidates, dedupe, score, and pick top 1-2.

**Context-driven selection** should run first in any team/workspace deployment. Generic seed lists are fallback — real value comes from mining the workspace's actual projects, people, and decisions.

Before finalizing topic, run a quick duplicate check:
- Search `knowledge/` for existing coverage.
- If coverage is already strong and recent, skip and pick next candidate.

### 2) Collect research

Pick sources by topic type using:
- `references/research-sources/brave.md` (baseline)
- `references/research-sources/perplexity.md` (optional deep synth)
- `references/research-sources/twitter.md` (optional sentiment/news pulse)
- `references/research-sources/coingecko.md` (optional crypto data)
- `references/research-sources/coinmarketcap.md` (optional crypto metadata)
- `references/research-sources/browser.md` (optional page extraction)

Low-cost default: brave only, plus local knowledge lookup.

**For department playbooks and context-driven topics:** also pull from project management tools (Asana, Linear, Jira) and team communication history. Internal context is more valuable than web searches for operational topics.

### 3) Synthesize

Create one durable, standalone knowledge artifact per topic:
- What it is
- Current state
- Why it matters (for the user's ecosystem/team/work)
- Key entities/projects
- Open questions + what to watch
- Sources with dates

For updates, include a short "What's new since last update" section.

**For department playbooks:** follow the structure in `references/topic-selection/department-playbooks.md` (problem → current tasks → specific workflows → time savings → how to start).

### 3.5) Quality gate

Before advancing to the next topic, run:
- `references/quality-gate/completion-checklist.md`

Every section must pass or be explicitly tagged `[INCOMPLETE: reason]`.
Do not start topic N+1 until topic N clears the gate.

**Quality checkpoints during burn mode:**
- After topic 5: pause and offer the user a chance to review 2-3 files for calibration
- After topic 15: check context usage — if >60%, consider fresh session or reduced depth
- Every hour: run `session_status` to monitor context % and provider profile

### 4) Write output

Use:
- `references/output/knowledge-writer.md`
- `references/output/run-progress.md`
- `references/output/lobsearch-index.md`
- `references/output/strategic-synthesis.md` (for connecting multiple topics into action plans)
- `references/output/burn-continuity.md` (for maintaining long burn sessions)

Write immediately after each topic (incremental write, never batch all topics first).

After writing each topic, update the run progress log (`knowledge/.runs/<date>-<mode>.md`).
This is your audit trail — always current, even if the run is interrupted.

## Modes

### Routine mode (default)
- 1 topic
- low-cost sources
- concise synthesis
- quiet completion unless user asked for report

### Burn mode (explicit only)
Use when user explicitly asks to consume remaining credits/budget aggressively.

Steps:
1. Run `scripts/provider-usage.sh` to check current usage (supports Tide Pool, legacy lobster, or generic `openclaw status` fallback)
2. Run `scripts/check-balance.sh` if you have balance JSON input to parse (supports generic fields: `remaining`, `balance`, `credits`, or Venice-specific `venice.data.diem`)
3. Keep reserve from config (`min_reserve_usd`) if set
4. Use heavier model + more sources (all optional sources enabled)
5. Save after every topic (incremental write — never batch)
6. Stop gracefully if balance or provider limit is hit
7. If multiple auth profiles are available, monitor for exhaustion and note when rotation is needed
8. Set up cron safety nets for continuity (see `references/output/burn-continuity.md`)
9. After completing 80%+ of topics, shift to strategic synthesis documents

### Phased burn (recommended for team deployments)

For first-time deployments or large topic lists:

**Phase 1: Context gathering (15-30 min)**
- Mine workspace: project management data, team profiles, conversations
- Map context signals to potential topics
- Score by Urgency × Impact × Knowledge Gap
- Build prioritized topic list (replaces or supplements seed list)

**Phase 2: Depth-first topic burn (bulk of time)**
- Work through topics in priority order
- Quality checkpoint after topic 5
- Monitor context usage hourly
- Cron safety nets every 30-60 min

**Phase 3: Department playbooks (15-20% of time)**
- Generate per-department operational playbooks
- Pull live task data per team member
- Design specific AI-assisted workflows with time savings estimates

**Phase 4: Strategic synthesis (final 10-15%)**
- Priority matrix connecting all topics
- Release scope recommendations
- Competitive positioning narrative
- Next-meeting action items

## Ad-hoc topic injection

Users can pass topics directly instead of using the seed list:
- "Run bottom feeder on [topic1, topic2, ...]"
- Ad-hoc topics skip the selection stage entirely — go straight to research.
- Still subject to quality gate and progress logging.

## Guardrails

- Never spend down to zero unless user explicitly says to.
- Avoid duplicate rewrites when no meaningful updates exist.
- Prefer free/local sources first.
- If source collection is weak, write a partial with clear uncertainty notes.
- Keep files readable; split oversized output into follow-up research files.
- In burn mode with multiple auth profiles, track which profile is active and flag when switching is needed.
- **Name real people in recommendations.** "Sam should do X" is more useful than "the engineering team should do X."
- **Link every recommendation to a knowledge file.** Synthesis documents should reference the research that supports them.

## Quick manual run recipe

1. Pick one topic from `config/topics.md`
2. Run brave search (3-6 results)
3. Synthesize into `knowledge/topics/<slug>.md`
4. Log run note in `memory/daily/YYYY-MM-DD.md`
5. Report: topic, files changed, estimated cost mode used
