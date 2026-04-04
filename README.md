# 🦞 Bottom Feeder

**A depth-first knowledge crawler skill for OpenClaw** that researches high-value topics without nuking your balance.
Small sips by default. Big feast mode only when you say so. 🌊

---

## ✨ What it does

Bottom Feeder runs a modular pipeline:

1. 🎯 **Topic Selection** — context-driven (your projects, people, decisions) or from seed lists
2. 🔎 **Research Collection** — Brave baseline + optional modules (Perplexity, Twitter, CoinGecko, CMC, browser)
3. 🧠 **Synthesis** — durable, actionable markdown (not blog posts — decision support documents)
4. 📝 **Output Writing** — to `knowledge/topics/` or `knowledge/research/`
5. 🏢 **Department Playbooks** — per-team operational guides showing how AI helps each person
6. 📊 **Strategic Synthesis** — priority matrices, release scope, competitive positioning

**Works with any provider** — Anthropic, OpenAI, Venice/Diem, or whatever you're running.

---

## 🆕 What's New (v2)

### Context-Driven Topic Selection
Don't just crawl generic topics. Mine your workspace: project management data (Asana, Linear, Jira), team conversations, existing knowledge files, and team profiles. Topics that reference real people, real deadlines, and real decisions are 10x more useful than encyclopedia entries.

### Department Playbooks
Generate per-department operational playbooks: Engineering, QA, Growth, Support, Security, Product. Each playbook names the specific person, pulls their actual tasks, designs AI-assisted workflows, and estimates time savings.

### Strategic Synthesis
After individual topics, generate synthesis documents that connect everything: priority matrices, release scope recommendations, competitive positioning, and meeting action items.

### Burn Mode Continuity
Cron safety nets, run progress logs, quality checkpoints, and parallel sub-agent support for long burn sessions (4+ hours).

### Phased Burn
Recommended flow for team deployments:
1. **Context gathering** (15-30 min) — mine workspace, build prioritized topic list
2. **Depth-first burn** (bulk) — research and write, quality checkpoints every 5 topics
3. **Department playbooks** (15-20%) — per-team operational guides
4. **Strategic synthesis** (10-15%) — connect everything into action plans

---

## 📦 Folder placement

```text
workspace/
├── skills/
│   └── bottom-feeder/
│       ├── SKILL.md
│       ├── config/
│       │   ├── defaults.yaml
│       │   └── topics.md
│       ├── references/
│       │   ├── topic-selection/
│       │   │   ├── context-driven.md      ← NEW
│       │   │   ├── department-playbooks.md ← NEW
│       │   │   ├── hardcoded-list.md
│       │   │   ├── conversation-mining.md
│       │   │   ├── knowledge-gaps.md
│       │   │   ├── knowledge-refresh.md
│       │   │   └── trending.md
│       │   ├── research-sources/
│       │   ├── quality-gate/
│       │   └── output/
│       │       ├── knowledge-writer.md
│       │       ├── run-progress.md
│       │       ├── lobsearch-index.md
│       │       ├── strategic-synthesis.md  ← NEW
│       │       └── burn-continuity.md      ← NEW
│       └── scripts/
└── knowledge/
    ├── topics/          ← research output goes here
    ├── research/        ← deep dives go here
    └── .runs/           ← audit trail
```

---

## 🚀 Quick start

1. Copy this folder into `workspace/skills/bottom-feeder`
2. Customize `config/topics.md` for your team (or let context-driven selection figure it out)
3. Run a low-burn test: one topic, Brave-only, output to `knowledge/topics/`
4. Review the output. Calibrate.
5. Scale up.

**For team deployments:** Start with context-driven selection. Mine your Asana/Linear/Jira for real topics. Generate 3-5 department playbooks. Then synthesize into action plans. This produces higher value than 30 generic research files.

---

## 💸 Balance behavior

- **Routine mode**: 1 topic, default sources, concise. Sips tokens.
- **Burn mode**: all sources, deeper synthesis, strategic outputs. Feasts on tokens.
- **Phased burn**: context → topics → playbooks → synthesis. Recommended for first deployment.
- **Reserve guardrail**: `min_reserve_usd` (or legacy `min_reserve_diem`)
- **Multi-profile**: track rotation across team seats/API keys

---

## 🧪 Reference modules

### Topic Selection
| Module | Purpose |
|--------|---------|
| `context-driven.md` | Mine workspace (PM tools, conversations, team profiles) for highest-value topics |
| `department-playbooks.md` | Generate per-team operational guides |
| `hardcoded-list.md` | Manually curated seed topics |
| `conversation-mining.md` | Extract topics from chat history |
| `knowledge-gaps.md` | Find what's referenced but not covered |
| `knowledge-refresh.md` | Update stale existing files |
| `trending.md` | Current news and trends |

### Output
| Module | Purpose |
|--------|---------|
| `knowledge-writer.md` | Standard knowledge file format |
| `run-progress.md` | Audit trail per run |
| `strategic-synthesis.md` | Connect topics into action plans |
| `burn-continuity.md` | Maintain long sessions (crons, checkpoints, parallelism) |
| `lobsearch-index.md` | Index for search |

---

## 🔧 Customization

### Topic seeds (`config/topics.md`)
Replace defaults with what matters to your team. Organize by priority tiers. But consider: context-driven selection often produces better topics than manual curation.

### Sources
Default: Brave + local knowledge. Optional: Perplexity, Twitter, CoinGecko/CMC, browser. For department playbooks: also pull from project management tools.

### Phased burn
Adjust time allocation per phase:
- Context gathering: 10-15% (don't skip this)
- Topic burn: 55-65% (the bulk)
- Department playbooks: 15-20% (highest value per file)
- Strategic synthesis: 10-15% (connects everything)

---

## 🦞 Lessons from Production

*From a 12-hour burn that produced 43 knowledge files:*

- **Context gathering was the real MVP.** 2 hours of mapping Asana data, team profiles, and conversations made every topic actionable instead of generic.
- **Department playbooks had the highest value per file.** Each one names a specific person and their actual tasks — not theoretical.
- **Quality degraded after topic 20.** Implement quality checkpoints and consider fresh sessions for extended burns.
- **Cron safety nets saved continuity.** Set them up before starting a long burn, not after you need them.
- **Strategic synthesis should come last.** Individual topics are ingredients; synthesis is the meal.
- **20 deeply excellent files > 40 thin ones.** Prioritize depth when choosing between more topics and better topics.

---

**Ran rah. Click clack.** 🦞
