# context-driven

Select topics by mining the workspace's existing context — not just generic seed lists.

## Why This Matters

Generic topic seeds produce encyclopedia entries. Context-driven selection produces decision support documents that reference real people, real projects, and real deadlines.

## Sources to Mine (in priority order)

1. **Project management data** — Asana, Linear, Jira, GitHub Issues
   - Pull active tasks, blocked items, upcoming milestones
   - Each initiative or epic is a potential topic
   - Blocked items are especially valuable — research WHY something is blocked

2. **Team conversations** — Slack, Discord, Telegram history
   - What questions keep coming up?
   - What decisions are pending?
   - What knowledge gaps are people expressing?

3. **Existing knowledge files** — `knowledge/`, `memory/`
   - What topics have stale dates (>30 days old)?
   - What topics are referenced but don't have a file yet?
   - What cross-references are broken?

4. **Company docs** — Google Docs, Notion, Confluence
   - Strategy documents that need research backing
   - Meeting notes with unresolved action items
   - Roadmap items that need competitive research

5. **User/team profiles** — `memory/contacts/`, USER.md
   - What is each team member working on?
   - Where are they overloaded?
   - What knowledge would help them most?

## How to Use

Before selecting from the hardcoded seed list, spend 15-30 minutes pulling context from the sources above. Map each context signal to a potential topic. Then score by:

**Topic Score = Urgency × Impact × Knowledge Gap**

- **Urgency:** Is there a deadline? Is something blocked? (High = this week, Medium = this month, Low = this quarter)
- **Impact:** How many people/decisions does this inform? (High = whole team, Medium = one department, Low = one person)
- **Knowledge Gap:** How much do we NOT know about this? (High = no existing coverage, Medium = stale coverage, Low = recent coverage exists)

Topics scoring High on all three dimensions go first.

## Example

Context signal: "Sam Holmes flagged urgency on v4.49.0 deliverables"
→ Topic: "v4.49.0 Release Scope Recommendation"
→ Score: Urgency=High (this week), Impact=High (whole team), Gap=High (no analysis exists)
→ Result: This topic gets written before generic "Bitcoin L2 ecosystem" research.

## Anti-Pattern

Don't just mine context and produce a list. **Map each topic back to a specific person who will use it.** If you can't name the person, the topic probably isn't worth writing.
