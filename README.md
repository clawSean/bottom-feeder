# 🦞 Bottom Feeder

**A knowledge research pipeline skill for OpenClaw** that researches topics using all available tools and writes durable knowledge files.

Small sips by default. Fleet mode when you need scale. 🌊

---

## What it does

4-stage pipeline: **Select → Collect → Synthesize → Write**

1. **Topic Selection** — context-driven (your projects, people, decisions), seed lists, or external topic files
2. **Research Collection** — uses ALL available tools: web search, page fetching, local knowledge, internal tools (Asana, Slack, etc.), code repos, APIs, social, MCP tools
3. **Synthesis** — durable, actionable markdown with quality gates
4. **Output** — to `knowledge/topics/` or `knowledge/research/`, with audit trail

Works with any provider — Anthropic, OpenAI, Venice/Diem, local models.

---

## Modes

| Mode | Topics | Sources | Parallelism |
|------|--------|---------|-------------|
| **Routine** (default) | 1-2 | Cost-conscious | Sequential |
| **Burn** | N (explicit) | All available | Sequential |
| **Fleet** | External list | All available | Preferred when available |

**Fleet mode** accepts a topic list file (markdown or plain text), dispatches topics via sub-agents when available, falls back to serial when not. The orchestrator assigns, tracks, and reports.

---

## Folder structure

```text
skills/bottom-feeder/
├── SKILL.md                          ← main instruction file
├── config/
│   ├── defaults.yaml                 ← modes, budget, sources, paths
│   └── topics.md                     ← seed topic list
├── references/
│   ├── research-sources.md           ← unified source strategy
│   ├── topic-selection/
│   │   ├── context-driven.md         ← PRIMARY selection method
│   │   ├── department-playbooks.md   ← per-team operational guides
│   │   └── hardcoded-list.md         ← seed list + external file support
│   ├── quality-gate/
│   │   └── completion-checklist.md   ← must-pass before next topic
│   └── output/
│       ├── knowledge-writer.md       ← file format spec
│       ├── run-progress.md           ← audit trail format
│       ├── strategic-synthesis.md    ← cross-topic action plans
│       ├── burn-continuity.md        ← cron safety nets, long runs
│       └── lobsearch-index.md        ← search index refresh
└── scripts/
    ├── provider-usage.sh             ← best-effort budget probe
    ├── check-balance.sh              ← balance extraction (never fails)
    └── estimate-cost.sh              ← rough cost estimate (never fails)
```

Output goes to:
- `knowledge/topics/` — research files
- `knowledge/research/` — deep dives
- `knowledge/.runs/` — audit trail

---

## Quick start

1. Copy this folder into `workspace/skills/bottom-feeder`
2. Customize `config/topics.md` or let context-driven selection find topics
3. Test: "Run bottom feeder" (routine mode, 1 topic)
4. Review output. Calibrate.
5. Scale: "Run bottom feeder on [topic1, topic2, ...]" or fleet mode with a topic file

---

## Budget

Budget tracking is **informational only** — it never blocks runs.

- Scripts probe available balance best-effort
- If probes fail (missing tools, wrong provider), runs continue normally
- `min_reserve_usd` is a soft stop suggestion, not a hard gate
- Venice/Diem legacy fields preserved for backward compatibility

---

## Lessons from production

- Context-driven selection produces 10x better topics than generic seed lists
- Department playbooks have highest value per file (name real people, real tasks)
- Quality degrades after ~20 topics in one session — use checkpoints
- Cron safety nets save continuity for long burns
- Strategic synthesis should come last (ingredients before the meal)
- 20 deep files > 40 thin ones

---

**Ran rah. Click clack.** 🦞
