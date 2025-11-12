#!/bin/bash

# Get API credentials from n8n-mcp environment
N8N_URL="https://n8n-automations.mypeterinarian.com"

# Create the partial update payload
cat > /tmp/update_payload.json << 'PAYLOAD'
{
  "operations": [
    {
      "type": "updateNode",
      "nodeId": "6b6257a0-29c1-4648-b93d-f1420b8ecbbc",
      "updates": {
        "parameters.text": "={{ $json.aiPrompt }}"
      }
    }
  ]
}
PAYLOAD

echo "🔧 Deploying Prompt node field mapping fix..."
echo ""

# Use npx to execute n8n-mcp which has the API credentials
npx -y n8n-mcp api PUT "/workflows/YM0t1gombwAUtELO" --data @/tmp/update_payload.json > /Users/tareksham/Desktop/deploy_api_result.json 2>&1

if [ $? -eq 0 ]; then
  echo "✅ Deployment command executed"
  cat /Users/tareksham/Desktop/deploy_api_result.json
else
  echo "⚠️ Command output:"
  cat /Users/tareksham/Desktop/deploy_api_result.json
fi
