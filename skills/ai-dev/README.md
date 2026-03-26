# AI Code Development Workflow 🚀

**全自动 AI 开发工作流 - 从需求到 PR 的完整自动化**

## 🎯 核心功能

将以下流程变成一次对话：

```
用户提需求 → Claude Code 执行代码 → 自动测试 → Commit/Push → 创建 PR
```

## 📋 快速开始

### **1. 基本用法**

```bash
/ai-dev /path/to/project --task "添加用户登录功能"
```

### **2. 带测试命令**

```bash
/ai-dev /repo/path --task "修复 bug #123" --test "npm test"
```

### **3. 指定审查人**

```bash
/ai-dev /repo/path --task "优化性能" --reviewer "@copilot,@team-lead"
```

## 🏗️ 架构设计

### **组件说明：**

| Component | Purpose | Location |
|-----------|---------|----------|
| `SKILL.md` | Skill 定义文档 | `/skills/ai-dev/SKILL.md` |
| `ai-dev.sh` | Main workflow script | `/scripts/ai-dev.sh` |
| `run-ai-code.sh` | Claude Code executor | `/scripts/run-ai-code.sh` |
| `ai-dev-cli.sh` | CLI interface | `/scripts/ai-dev-cli.sh` |

### **执行流程：**

```mermaid
graph TD
    A[用户提需求] --> B[/ai-dev command]
    B --> C[Spawn Claude Code Agent]
    C --> D{Execute Task}
    D --> E[Code Changes]
    E --> F{Run Tests?}
    F -->|Yes| G[npm test / pytest]
    F -->|No| H[Skip Testing]
    G --> I{Tests Pass?}
    I -->|Fail| J[Auto-Fix Attempt]
    J --> G
    I -->|Pass| K[Commit & Push]
    H --> K
    K --> L[Create PR]
    L --> M[Request Reviewers]
    M --> N[Done!]
```

## 🔧 配置选项

### **项目级配置** (`.ai-dev/config.json`)

```json
{
  "default_test_command": "npm test",
  "auto_merge": true,
  "reviewers": ["@copilot"],
  "labels": ["ai-generated", "automated"]
}
```

### **环境变量**

```bash
export AI_DEV_AGENT="claude-code"  # or "codex"
export AI_DEV_TIMEOUT=300           # seconds per task
export AI_DEV_MAX_RETRIES=3         # test retry count
```

## 🧪 测试工作流

### **示例：在测试项目上运行**

```bash
cd /home/huiquanyun/.openclaw/workspace/skills/ai-dev/examples/test-project

# Add a new feature
/ai-dev . --task "添加乘法功能 multiply(a, b)"

# Expected behavior:
# 1. Claude Code modifies index.js
# 2. Runs npm test
# 3. Creates commit and branch
# 4. Opens PR for review
```

## 📊 状态追踪

每次执行生成报告：

```markdown
# AI Dev Report

**Task**: Add user login feature
**Time**: 2026-03-26 11:30 GMT+8
**Branch**: feature/ai-dev-20260326113000

## ✅ Completed
- Fork & Clone: ✓
- Code Changes: ✓ (5 files modified)
- Tests Passed: ✓ (45/45 tests)
- PR Created: #123

## 🔗 Links
- Branch: https://github.com/.../tree/feature/ai-dev-...
- PR: https://github.com/.../pull/123
```

## ⚠️ 安全限制

### **自动执行（无需确认）：**
- ✅ 代码修改和重构
- ✅ 运行测试套件
- ✅ Commit + Push to feature branch
- ✅ Create Pull Request

### **需要人工确认：**
- ❌ Delete branches or files
- ❌ Merge to main/master
- ❌ Deploy to production
- ❌ Execute commands outside workspace

## 🚀 高级用法

### **多轮对话迭代**

```bash
# Round 1: Basic implementation
/ai-dev /repo --task "Implement user authentication"

# Review PR, then refine
/ai-dev /repo --task "Add error handling and validation"

# Final polish
/ai-dev /repo --task "Write unit tests for auth module"
```

### **批量任务处理**

Create a task list file:

```yaml
tasks:
  - id: bug-123
    description: Fix login timeout issue
    priority: high
    
  - id: feature-456
    description: Add password reset
    priority: medium
```

Then process sequentially.

## 🎯 目标愿景

**让开发像聊天一样简单：**

```
User: "我需要添加用户注册功能"
AI:   [自动完成代码 + 测试 + PR]
User: "[Review PR, approve merge]"
AI:   [Auto-merge to main]
```

**零 git 命令，零手动操作！** 🎉

## 📚 相关文档

- [SKILL.md](./SKILL.md) - Skill definition
- [GitHub CLI Docs](https://cli.github.com/)
- [Claude Code Agent](https://github.com/ClaudeCode)
