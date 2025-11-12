#!/bin/bash

# Deploy Prompt node field mapping fix
# Changes Prompt node text field from {{ $json.serviceName }} to {{ $json.aiPrompt }}

echo "🔧 Deploying Prompt node field mapping fix..."
echo ""

# Upload the fixed workflow
curl -X PUT "https://n8n-automations.mypeterinarian.com/api/v1/workflows/YM0t1gombwAUtELO" \
  -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
  -H "Content-Type: application/json" \
  -d @/Users/tareksham/Desktop/workflow_prompt_field_fixed.json \
  -o /Users/tareksham/Desktop/deploy_result.json

# Check result
if [ -f /Users/tareksham/Desktop/deploy_result.json ]; then
  VERSION=$(cat /Users/tareksham/Desktop/deploy_result.json | jq -r '.versionId // "unknown"')
  NAME=$(cat /Users/tareksham/Desktop/deploy_result.json | jq -r '.name // "unknown"')

  if [ "$VERSION" != "unknown" ] && [ "$VERSION" != "null" ]; then
    echo "✅ Successfully deployed!"
    echo "   Workflow: $NAME"
    echo "   Version: $VERSION"
    echo ""
    echo "📝 Changes applied:"
    echo "   - Prompt node now reads from: {{ \$json.aiPrompt }}"
    echo "   - Previous: {{ \$json.serviceName }}"
    echo ""
    echo "🧪 Ready for testing!"
  else
    echo "❌ Deployment failed"
    cat /Users/tareksham/Desktop/deploy_result.json | jq '.'
  fi
else
  echo "❌ No result file created"
fi
