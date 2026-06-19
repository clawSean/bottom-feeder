# context-driven

Primary topic selection method. Mine the workspace's existing context — not generic seed lists.

## Why

Generic seeds produce encyclopedias. Context-driven selection produces decision support documents tied to real people, real projects, and real deadlines.

## Sources to Mine (priority order)

1. **Project management** — Asana, Linear, Jira, GitHub Issues
   - Active tasks, blocked items, upcoming milestones
   - Each initiative or epic is a potential topic
   - Blocked items are high-value — research WHY something is blocked

2. **Team conversations** — Slack, Discord, Telegram, daily logs
   - Repeated themes, explicit asks, unresolved questions
   - Score boost when mention count >= 2 or time-sensitive
   - Mine `memory/daily/YYYY-MM-DD.md` (today + yesterday)

3. **Existing knowledge** — `knowledge/`, `memory/`
   - Topics with stale dates (>14 days old in rapid-change domains)
   - Topics referenced but without a file yet
   - Broken cross-references

4. **Company docs** — Google Docs, Notion, Confluence
   - Strategy documents needing research backing
   - Meeting notes with unresolved action items
   - Roadmap items needing competitive research

5. **User/team profiles** — `memory/contacts/`, USER.md
   - What is each team member working on?
   - Where are they overloaded? What knowledge helps them most?

## Scoring

**Topic Score = Urgency × Impact × Knowledge Gap**

- **Urgency:** deadline or blocker? (High = this week, Medium = this month, Low = this quarter)
- **Impact:** how many people/decisions informed? (High = whole team, Medium = one dept, Low = one person)
- **Knowledge Gap:** how much do we NOT know? (High = no coverage, Medium = stale, Low = recent + strong)

High on all three → goes first.

## Staleness Check

Before finalizing any candidate:
- Search `knowledge/` by keyword/slug
- No file or only shallow notes → high-value gap, prioritize
- File exists but >14 days old in rapid-change domain → refresh candidate
- Coverage strong and fresh → skip, pick next

## Trending Signals

Light trend scan to propose additional candidates:
- Web headlines via any search tool
- Recent community chatter in relevant channels
- Prefer topics intersecting configured interests
- Avoid pure hype — cap to 1 trending pick per run

## Tip

Prefer topics you can map to a specific person or team who will use the output. General-interest topics that serve the whole org are still valid — don't discard them just because there's no single owner.
