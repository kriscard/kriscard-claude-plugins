Capture full-page screenshot of $ARGUMENTS using agent-browser CLI:

## Workflow

1. Navigate to page and wait for load:
   ```bash
   agent-browser open "$ARGUMENTS" && agent-browser wait --load networkidle
   ```

2. Capture full-page screenshot:
   ```bash
   agent-browser screenshot --full screenshot.png
   ```

   For an AI-friendly annotated screenshot (numbered element labels):
   ```bash
   agent-browser screenshot --full --annotate screenshot-annotated.png
   ```

## Output

Report to user:
- Screenshot saved to: [file location]
- Page URL: $ARGUMENTS
- If annotated, include the element legend

If user did not provide a URL, prompt them with: "Please provide a URL to screenshot. Usage: /browser:screenshot <url>"
