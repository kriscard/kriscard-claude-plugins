Record a video of browser interactions on $ARGUMENTS using agent-browser CLI:

## Workflow

1. Navigate to page and start recording:
   ```bash
   agent-browser open "$ARGUMENTS" && agent-browser wait --load networkidle
   agent-browser record start recording.webm
   ```

2. Tell the user: "Recording started. Describe the interactions you want me to perform on the page, and I'll execute them. Say 'stop recording' when done."

3. Perform the user's requested interactions using agent-browser commands:
   - `agent-browser click <selector>` — click elements
   - `agent-browser fill <selector> <text>` — fill form fields
   - `agent-browser scroll down 500` — scroll the page
   - `agent-browser hover <selector>` — hover elements
   - `agent-browser press Enter` — press keys
   - `agent-browser wait 1000` — pause between actions

4. When user says to stop, end the recording:
   ```bash
   agent-browser record stop
   ```

## Output

**Recording Complete:**
- Video saved to: recording.webm
- Page URL: $ARGUMENTS
- Actions performed: [list of interactions]

If user did not provide a URL, prompt them with: "Please provide a URL to record. Usage: /browser:record <url>"
