JULES_API_KEY="${KQ_JULES_API_KEY}"
PROMPT_JSON='"test prompt"'
curl -s -X POST \
  -H "X-Goog-Api-Key: $JULES_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"prompt\": $PROMPT_JSON,
    \"sourceContext\": {
      \"source\": \"sources/github/Kopie-Quant-LLC/kq-website\",
      \"githubRepoContext\": {
        \"startingBranch\": \"main\"
      }
    },
    \"requirePlanApproval\": false,
    \"automationMode\": \"AUTO_CREATE_PR\",
    \"title\": \"Depsweep: Test\",
    \"labels\": [\"jules-helper\", \"slot:migration-scribe\", \"wave-3.5\", \"agent:kq-jules-depsweep\"]
  }" \
  "https://jules.googleapis.com/v1alpha/sessions"
