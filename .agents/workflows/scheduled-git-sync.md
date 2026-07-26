---
description: Periodically pull and push code changes to GitHub
---

---
description: Periodically pull and push code changes to GitHub.
schedule: "0 2,22 * * *" # Runs every hour (standard Cron syntax)
---

# Scheduled Git Sync Workflow

Run the `github-sync` skill to bring the workspace up to date with `origin` and push any pending local commits.

1. Trigger skill: `github-sync`
2. Log sync results to stdout.