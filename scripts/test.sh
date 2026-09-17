#!/usr/bin/env bash
set -euo pipefail

# Baseline tests for the bottom-feeder skill.
# Run from the skill root: bash scripts/test.sh

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SKILL_DIR"

pass=0
fail=0

ok()   { pass=$((pass+1)); echo "  PASS: $1"; }
fail() { fail=$((fail+1)); echo "  FAIL: $1"; }

echo "=== bottom-feeder baseline tests ==="

# --- 1. SKILL.md structure ---
echo
echo "-- SKILL.md frontmatter --"

if head -1 SKILL.md | grep -q '^---$'; then
  ok "SKILL.md starts with frontmatter delimiter"
else
  fail "SKILL.md missing opening ---"
fi

if grep -q '^name: bottom-feeder' SKILL.md; then
  ok "frontmatter name field present"
else
  fail "frontmatter name field missing or wrong"
fi

if grep -q '^description:' SKILL.md; then
  ok "frontmatter description field present"
else
  fail "frontmatter description field missing"
fi

# --- 2. Referenced files exist ---
echo
echo "-- Referenced files --"

referenced_files=(
  config/defaults.yaml
  config/topics.md
  config/run-policy.md.example
  config/signals.yaml.example
  references/research-sources.md
  references/execution/checkpoint-monitoring.md
  references/execution/execution-modes.md
  references/execution/lessons-learned.md
  references/execution/provider-fallback.md
  references/execution/recovery-patterns.md
  references/topic-selection/context-driven.md
  references/topic-selection/department-playbooks.md
  references/topic-selection/external-signals.md
  references/topic-selection/hardcoded-list.md
  references/quality-gate/completion-checklist.md
  references/supervision/tree-search.md
  references/supervision/quality-score.md
  references/output/burn-continuity.md
  references/output/knowledge-writer.md
  references/output/run-progress.md
  references/output/lobsearch-index.md
  references/output/strategic-synthesis.md
)

for f in "${referenced_files[@]}"; do
  if [[ -f "$f" ]]; then
    ok "exists: $f"
  else
    fail "missing: $f"
  fi
done

# --- 3. defaults.yaml parses ---
echo
echo "-- Config parsing --"

if ruby -e "require 'yaml'; YAML.safe_load(File.read('config/defaults.yaml'), [], [], true)" 2>/dev/null; then
  ok "defaults.yaml parses as valid YAML"
else
  fail "defaults.yaml is not valid YAML"
fi

# Check key fields
if ruby -e "
require 'yaml'
d = YAML.safe_load(File.read('config/defaults.yaml'), [], [], true)
raise unless d.key?('default_topics')
raise unless %w[routine burn].include?(d['mode'])
raise unless d['default_sources'].is_a?(Array)
raise unless %w[single batched supervised].include?(d['execution_mode'])
raise unless d.fetch('batch_size', 0).to_i >= 1
raise unless %w[linear tree_search].include?(d['supervisor_mode'])
raise unless d.fetch('max_candidate_branches', 0).to_i >= 1
raise unless d.fetch('max_branch_retries', -1).to_i >= 0
" 2>/dev/null; then
  ok "defaults.yaml has required keys (default_topics, mode, default_sources, execution, supervisor controls)"
else
  fail "defaults.yaml missing required keys"
fi

# --- 4. estimate-cost.sh smoke test ---
echo
echo "-- estimate-cost.sh --"

routine_cost="$(bash scripts/estimate-cost.sh routine 2 2>&1)" || true
if echo "$routine_cost" | grep -qE '^[0-9]+\.[0-9]+$'; then
  ok "routine mode returns numeric cost ($routine_cost)"
else
  fail "routine mode output unexpected: $routine_cost"
fi

burn_cost="$(bash scripts/estimate-cost.sh burn 4 2>&1)" || true
if echo "$burn_cost" | grep -qE '^[0-9]+\.[0-9]+$'; then
  ok "burn mode returns numeric cost ($burn_cost)"
else
  fail "burn mode output unexpected: $burn_cost"
fi

bogus_cost="$(bash scripts/estimate-cost.sh bogus 1 2>&1)" || true
if echo "$bogus_cost" | grep -qE '^[0-9]+\.[0-9]+$'; then
  ok "unknown mode falls back to numeric routine estimate ($bogus_cost)"
else
  fail "bogus mode output unexpected: $bogus_cost"
fi

# --- 5. check-balance.sh smoke test ---
echo
echo "-- check-balance.sh --"

bal="$(echo '{"remaining": 5.5}' | bash scripts/check-balance.sh 2>&1)" || true
if [[ "$bal" == "5.5000" ]]; then
  ok "parses {remaining} field correctly ($bal)"
else
  fail "remaining field parse unexpected: $bal"
fi

bal2="$(echo '{"balance": 12.345}' | bash scripts/check-balance.sh 2>&1)" || true
if [[ "$bal2" == "12.3450" ]]; then
  ok "parses {balance} field correctly ($bal2)"
else
  fail "balance field parse unexpected: $bal2"
fi

bal3="$(echo '{"venice":{"data":{"diem": 3.0}}}' | bash scripts/check-balance.sh 2>&1)" || true
if [[ "$bal3" == "3.0000" ]]; then
  ok "parses venice.data.diem field correctly ($bal3)"
else
  fail "venice.data.diem field parse unexpected: $bal3"
fi

# Preamble tolerance
bal4="$(echo 'some log line
{"credits": 7}' | bash scripts/check-balance.sh 2>&1)" || true
if [[ "$bal4" == "7.0000" ]]; then
  ok "tolerates preamble text before JSON ($bal4)"
else
  fail "preamble tolerance unexpected: $bal4"
fi

# --- 6. Scripts are executable or at least runnable via bash ---
echo
echo "-- Script executability --"
for s in scripts/*.sh; do
  if head -1 "$s" | grep -q '#!/usr/bin/env bash'; then
    ok "shebang present: $s"
  else
    fail "missing shebang: $s"
  fi
done

# --- Summary ---
echo
echo "=== Results: $pass passed, $fail failed ==="
[[ "$fail" -eq 0 ]] && exit 0 || exit 1
