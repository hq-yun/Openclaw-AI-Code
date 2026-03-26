# AI Code Development Workflow - 完整方案 🚀

## 🎯 核心目标

**将"需求 → 代码 → 测试 → PR"变成一次对话流程**

```
用户：添加用户登录功能
AI:   [自动完成所有步骤，返回 PR 链接]
```

---

## ✅ 已创建组件

### **1. Skill 结构**
```
skills/ai-dev/
├── SKILL.md              # Skill 定义文档
├── README.md             # 完整技术文档
├── QUICKSTART.md         # 快速上手指南
├── config.example.json   # 配置示例
├── scripts/
│   ├── ai-dev.sh         # Main workflow script
│   ├── run-ai-code.sh    # Claude Code executor
│   ├── ai-dev-cli.sh     # CLI interface
│   └── test-ai-dev.sh    # Integration test
└── examples/
    └── test-project/     # 测试项目示例
```

### **2. 核心功能**

| Component | Status | Description |
|-----------|--------|-------------|
| `/ai-dev` command | ✅ Ready | Main entry point |
| Claude Code Agent Integration | ✅ Ready | via `sessions_spawn` |
| Auto Testing | ✅ Ready | Supports npm/pytest/etc |
| Git Operations | ✅ Ready | Commit + Push automation |
| PR Creation | ⚠️ Optional | Requires `gh` CLI config |

---

## 🚀 使用方法

### **基本用法：**
```bash
/ai-dev [project_path] --task "你的需求" [--test "测试命令"]
```

### **示例：**
```bash
# 为 Openclaw-AI-Code 项目添加功能
/ai-dev /home/huiquanyun/桌面/Openclaw-AI-Code \
  --task "添加用户设置页面" \
  --test "npm test"

# 修复 bug
/ai-dev . --task "修复登录页面的响应式布局问题"
```

---

## 🔄 完整工作流程

```mermaid
graph LR
    A[用户提需求] --> B[/ai-dev command]
    B --> C[Spawn Claude Code Agent]
    C --> D{Analyze Codebase}
    D --> E[Implement Changes]
    E --> F{Run Tests?}
    F -->|Yes| G[npm test / pytest]
    F -->|No| H[Skip Testing]
    G --> I{Tests Pass?}
    I -->|Fail| J[Auto-Fix Attempt x3]
    J --> G
    I -->|Pass| K[Commit + Push]
    H --> K
    K --> L[Create PR via gh CLI]
    L --> M[Request Reviewers]
    M --> N[Done!]
```

---

## 🛠️ 技术实现细节

### **1. Agent Spawning**
```python
# Use OpenClaw sessions_spawn with runtime="acp"
openclaw sessions spawn \
  --runtime acp \
  --agent-id claude-code \
  --task "Complete this task: ..." \
  --cwd /path/to/project \
  --mode run
```

### **2. Git Automation**
- Auto-create feature branch: `feature/ai-dev-[timestamp]`
- Smart commit messages: `AI Dev: [short description]`
- Force push protection enabled

### **3. Testing Strategy**
- Detect test command from package.json / pytest.ini
- Retry failed tests up to 3 times
- Auto-fix common issues (missing deps, syntax errors)

### **4. PR Creation**
```bash
gh pr create \
  --title "AI Dev: [task description]" \
  --body "Automated PR from OpenClaw AI Dev" \
  --base main \
  --reviewer @copilot
```

---

## 📊 配置选项

### **项目级配置** (`.ai-dev/config.json`)
```json
{
  "default_test_command": "npm test",
  "auto_merge": true,
  "reviewers": ["@copilot"],
  "labels": ["ai-generated", "automated"],
  "max_retries": 3,
  "timeout_seconds": 300
}
```

### **环境变量**
```bash
export AI_DEV_AGENT="claude-code"      # or "codex"
export AI_DEV_TIMEOUT=300              # seconds per task
export AI_DEV_MAX_RETRIES=3            # test retry count
```

---

## ⚠️ 安全限制

### **✅ 自动执行（无需确认）：**
- Code modifications and refactoring
- Running test suites
- Commit + Push to feature branch
- Create Pull Request

### **❌ 需要人工确认：**
- Delete branches or files
- Merge to main/master
- Deploy to production
- Execute commands outside workspace

---

## 🧪 测试与验证

### **1. 快速测试**
```bash
cd /home/huiquanyun/.openclaw/workspace/skills/ai-dev
./scripts/test-ai-dev.sh
```

### **2. 手动测试**
```bash
cd examples/test-project
/ai-dev . --task "Add a new function 'add(a, b)'"
```

---

## 🎯 下一步优化

### **Phase 1: MVP (已完成)** ✅
- [x] Basic workflow script
- [x] Claude Code integration
- [x] Auto testing support
- [x] Git automation

### **Phase 2: Enhanced** 🔧
- [ ] PR auto-review comments
- [ ] Better error recovery
- [ ] Multi-task batching
- [ ] Test coverage reporting

### **Phase 3: Advanced** 🚀
- [ ] Auto-merge on CI pass
- [ ] Code quality checks (ESLint, Prettier)
- [ ] Integration with issue trackers
- [ ] Learning from past PRs

---

## 💡 使用技巧

### **1. 任务描述要具体**
```bash
# ✅ Good
/ai-dev . --task "Add email validation regex to user model"

# ❌ Bad  
/ai-dev . --task "Fix user stuff"
```

### **2. 提供测试命令**
```bash
/ai-dev . --task "Refactor API handlers" --test "npm run test:api"
```

### **3. 分步迭代**
```bash
# Round 1: Basic implementation
/ai-dev . --task "Create login endpoint"

# Review, then refine
/ai-dev . --task "Add error handling and JWT tokens"
```

---

## 📚 相关资源

- [SKILL.md](./skills/ai-dev/SKILL.md) - Skill definition
- [README.md](./skills/ai-dev/README.md) - Full documentation
- [QUICKSTART.md](./skills/ai-dev/QUICKSTART.md) - Quick start guide
- [GitHub CLI Docs](https://cli.github.com/)

---

## 🎉 总结

**AI Dev Skill 已 ready for use!**

核心优势：
1. ✅ **全自动** - 从需求到 PR，零手动操作
2. ✅ **可测试** - 自动运行并修复测试失败
3. ✅ **安全** - Feature branch + PR review 机制
4. ✅ **灵活** - 支持多种项目类型和测试框架

**开始你的第一个 AI Dev 任务吧！** 🚀

```bash
/ai-dev /path/to/project --task "你的需求"
```
