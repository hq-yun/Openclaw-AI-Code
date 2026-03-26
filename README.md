# OpenClaw AI Code Workspace

This repository contains the OpenClaw AI workspace with automatic GitHub sync.

## Features

- ✅ **Automatic Sync**: GitHub Actions automatically pushes changes every 4 hours
- 🔄 **Cron Triggers**: Daily reminders at 09:00 and 15:00
- 🔒 **Secure**: Uses GitHub Secrets for authentication

## Structure

```
/workspace/
├── .github/workflows/auto-sync.yml  # Auto-push workflow
├── skills/                           # Custom skills
├── memory/                           # Daily memory logs
└── [your projects...]
```

## How It Works

1. Make changes in your workspace
2. GitHub Actions checks for changes every 4 hours (or on manual trigger)
3. If changes detected → auto-commit and push to main branch
4. No manual git commands needed!

---

*Last synced: 2026-03-26 11:09 GMT+8*
