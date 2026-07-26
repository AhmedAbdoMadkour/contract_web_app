---
name: github-sync
description: Safely syncs local workspace with GitHub by fetching, pulling latest changes, and pushing pending commits.
---

# GitHub Sync Skill

Use this skill to keep the local Git repository in sync with the remote GitHub branch.

## Sync Instructions

1. **Check Status**: Run `git status -s` to inspect dirty files and active branch.
2. **Fetch Remote**: Run `git fetch origin`.
3. **Pull Remote Changes**:
   - Run `git pull --rebase origin main` (or the currently checked out branch).
   - If merge/rebase conflicts occur:
     - DO NOT force push.
     - Log conflicts clearly and notify the user if manual intervention is required.
4. **Stage & Commit local untracked changes** (if auto-commit is enabled):
   - Stage modified tracked files: `git add -u`
   - Commit with message: `git commit -m "auto-sync: update local changes"`
5. **Push Changes**:
   - Run `git push origin <current-branch>`.

## Safety Rules
- Never use `--force` or `--hard` reset commands.
- If remote and local have divergent untracked changes that conflict, stash or halt and request user confirmation.