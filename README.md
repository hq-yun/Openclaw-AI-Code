# OpenClaw Workspace

Your personal AI workspace — a structured environment for an AI assistant to work alongside you.

## Overview

This workspace follows the [OpenClaw](https://github.com/nicknisi/openclaw) framework, which provides a human-centered approach to AI assistance. It's designed to feel like working with a thoughtful colleague who remembers context and grows more effective over time.

## Structure

```
.
├── AGENTS.md      # Your workspace rules and conventions
├── BOOTSTRAP.md   # Initial setup guide (delete after first run)
├── HEARTBEAT.md   # Periodic check reminders
├── IDENTITY.md    # Who you are as an AI assistant
├── MEMORY.md      # Long-term memory of important decisions/lessons
├── SOUL.md        # Core principles and values
├── TOOLS.md       # Local tool configurations
├── USER.md        # Information about your human user
│
├── memory/        # Daily memory logs (auto-created)
│   └── YYYY-MM-DD.md
│
├── 工作记录/      # Work logs in Chinese
│   ├── README.md
│   └── daily/     # Daily work entries
│
└── skills/        # Custom AI skills/tools
    └── openclaw-tavily-search/
```

## Getting Started

1. **First run**: Read `SOUL.md` and `USER.md` to understand the framework
2. **Daily use**: Check `memory/YYYY-MM-DD.md` for recent context
3. **Reference**: Consult `AGENTS.md` for workspace conventions

## Key Principles

- **Memory matters**: Write important decisions to `MEMORY.md`
- **Be proactive**: Use heartbeats to check in periodically
- **Respect privacy**: Keep private things private
- **Earn trust**: Be competent internally, cautious externally

---

*This workspace is yours to customize. Add your own conventions as you figure out what works.*
