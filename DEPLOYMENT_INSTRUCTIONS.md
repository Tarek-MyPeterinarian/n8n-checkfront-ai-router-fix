# Prompt Node Field Mapping Fix - Deployment Instructions

## Problem Identified
The Prompt node is reading from the wrong field:
- **Current**: Prompt node reads from `{{ $json.serviceName }}`
- **Expected**: Prompt node should read from `{{ $json.aiPrompt }}`
- **Root Cause**: The Build AI Prompt node outputs field name `aiPrompt`, not `serviceName`

## Fixed Workflow File
**Location**: `/Users/tareksham/Desktop/workflow_prompt_field_fixed.json`

The fix has been applied to this file - the Prompt node (ID: `6b6257a0-29c1-4648-b93d-f1420b8ecbbc`) now has:
```javascript
"text": "={{ $json.aiPrompt }}"
```

## Deployment Options

### Option 1: Manual Deployment via n8n UI (Recommended)
1. Open n8n: https://n8n-automations.mypeterinarian.com
2. Go to workflow: 🤖 Checkfront AI Booking Router (ID: YM0t1gombwAUtELO)
3. Find the **Prompt** node (after "Build AI Prompt" node)
4. Edit the Prompt node
5. Change the text field from `{{ $json.serviceName }}` to `{{ $json.aiPrompt }}`
6. Save the workflow

### Option 2: Deploy via API (Requires API Key)
Run this command in your terminal (replace YOUR_API_KEY with your actual n8n API key):

```bash
curl -X PUT "https://n8n-automations.mypeterinarian.com/api/v1/workflows/YM0t1gombwAUtELO" \
  -H "X-N8N-API-KEY: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d @/Users/tareksham/Desktop/workflow_prompt_field_fixed.json
```

### Option 3: Partial Update via API (Smallest Change)
This only updates the specific field without uploading the entire workflow:

```bash
curl -X PUT "https://n8n-automations.mypeterinathan.com/api/v1/workflows/YM0t1gombwAUtELO" \
  -H "X-N8N-API-KEY: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "nodes": [
      {
        "id": "6b6257a0-29c1-4648-b93d-f1420b8ecbbc",
        "parameters": {
          "text": "={{ $json.aiPrompt }}"
        }
      }
    ]
  }'
```

## Verification Steps
After deployment:
1. Check the Prompt node in the n8n UI
2. Verify the text field shows: `={{ $json.aiPrompt }}`
3. Test with a sample webhook payload

## Additional Fix Needed
After deploying this fix, there's a secondary issue to address:
- The **Build AI Prompt** node needs an expression format fix
- Add `=` prefix to the prompt value for proper expression evaluation
- This can be applied using the `n8n_autofix_workflow` tool with `applyFixes: true`

## Next Steps
1. ✅ Deploy this Prompt node field mapping fix
2. ⏳ Apply autofix for Build AI Prompt expression format
3. ⏳ Test with sample booking data
4. ⏳ Fix webhook URL in Checkfront (remove '-test' from URL)
5. ⏳ Monitor first real booking

## Technical Details
- **Workflow ID**: YM0t1gombwAUtELO
- **Workflow Name**: 🤖 Checkfront AI Booking Router
- **Node ID**: 6b6257a0-29c1-4648-b93d-f1420b8ecbbc
- **Node Name**: Prompt
- **Node Type**: @n8n/n8n-nodes-langchain.chainLlm
- **Parameter**: parameters.text
- **Old Value**: Contains `{{ $json.serviceName }}`
- **New Value**: `={{ $json.aiPrompt }}`

## Why This Fix Is Needed
The Build AI Prompt node (Set node, ID: 677a1d9c-08d4-4c8d-8d58-9a4d778e2bfa) creates output with this field:
```javascript
{
  "aiPrompt": "You are an EXPERT at analyzing concatenated service SKU strings..."
}
```

But the Prompt node was trying to read from:
```javascript
{{ $json.serviceName }}  // ❌ This field doesn't exist
```

This caused the "No prompt specified" error, which then cascaded into "Could not find AI response in expected fields" because the AI never received a prompt to process.
