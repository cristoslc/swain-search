# Discover Mode

Help the user find existing troves relevant to their topic.

1. Scan `docs/troves/*/manifest.yaml` for all troves
2. Match against the user's query by:
   - **Tag match** — trove tags contain query keywords
   - **Title match** — trove ID slug contains query keywords
3. For each match, show: trove ID, tags, source count, last refreshed date, referenced-by list
4. If no matches, suggest creating a new trove