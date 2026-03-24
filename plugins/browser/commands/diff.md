Compare two web pages visually and structurally using agent-browser CLI.

Parse $ARGUMENTS to extract two URLs. If only one URL is provided, treat it as a before/after comparison of the same page.

## Two-URL Comparison

If two URLs are provided (e.g., `/browser:diff http://localhost:3000 http://localhost:3001`):

```bash
agent-browser diff url "$URL1" "$URL2"
```

## Single-URL Before/After Comparison

If one URL is provided, take a baseline snapshot, then prompt the user to make changes:

1. Take baseline:
   ```bash
   agent-browser open "$ARGUMENTS" && agent-browser wait --load networkidle
   agent-browser screenshot --full baseline.png
   agent-browser snapshot > baseline-snapshot.txt
   ```

2. Tell the user: "Baseline captured. Make your changes, then tell me when ready to compare."

3. After user confirms, take comparison:
   ```bash
   agent-browser reload && agent-browser wait --load networkidle
   agent-browser diff screenshot --baseline baseline.png
   agent-browser diff snapshot
   ```

## Output Format

**Page Comparison:**
- URL 1: [url1]
- URL 2: [url2] (or "same page, after changes")

**Visual Differences:**
- [List visual changes detected]
- Screenshot comparison saved to: [file location]

**Structural Differences:**
- [List DOM/accessibility tree changes]
- Elements added: [count]
- Elements removed: [count]
- Elements changed: [count]

**Analysis:**
- [Summary of meaningful differences]
- [Flag potential regressions]

If user did not provide URLs, prompt them with: "Please provide URLs to compare. Usage: /browser:diff <url1> <url2>"
