# AI Dev Skill - 使用指南 🚀

## 🎯 什么是 AI Dev？

**AI Code Development Workflow** - 一个全自动的 AI 开发助手，将以下流程变成一次对话：

```
用户提需求 → AI 写代码 → 自动测试 → Commit/Push → 创建 PR
```

---

## ✅ 快速开始

### **1. 查看示例（推荐先体验）**

```bash
/home/huiquanyun/.openclaw/workspace/skills/ai-dev/scripts/demo-ai-dev.sh
```

这个脚本会演示完整的 AI Dev 流程。

### **2. 实际使用**

当 ACP runtime 配置好后，使用方式：

```bash
# 基本用法
/ai-dev /path/to/project --task "你的需求"

# 带测试命令
/ai-dev . --task "添加用户登录功能" --test "npm test"

# 指定审查人（需要 gh CLI）
/ai-dev . --task "优化性能" --reviewer "@copilot,@team-lead"
```

---

## 📋 完整示例

### **场景：为 Openclaw-AI-Code 添加新功能**

#### **Step 1: 提需求**
```bash
cd /home/huiquanyun/桌面/Openclaw-AI-Code

/ai-dev . --task "添加一个天气查询工具类，支持城市名称"
```

#### **Step 2: AI 自动执行**
AI Agent 会：
1. ✅ 分析项目结构
2. ✅ 创建 `utils/weather.js`
3. ✅ 实现天气查询逻辑
4. ✅ 运行测试（如果有）
5. ✅ Commit + Push to feature branch

#### **Step 3: 查看结果**
```bash
# AI 会返回报告：
✅ Completed!
- Files modified: 3 (weather.js, test/weather.test.js, index.js)
- Tests passed: 12/12
- Branch created: feature/ai-dev-20260326113000
- PR #42 ready for review
```

#### **Step 4: Review & Merge**
访问 GitHub PR，review 后 merge！

---

## 🔧 配置说明

### **必需配置：**

1. **Claude Code Agent** (或 Codex)
   - 需要在 OpenClaw 中配置 agent
   - 当前 demo 使用本地脚本模拟

2. **GitHub Token**
   - 已配置在 `~/.bashrc`
   - 用于自动 push 和创建 PR

3. **Git Config** (已配置)
   ```bash
   git config user.email "hq-yun@users.noreply.github.com"
   git config user.name "hq-yun"
   ```

### **可选配置：**

1. **GitHub CLI** (`gh`)
   - 用于自动创建 PR
   - 安装：`brew install gh` (macOS) 或从 GitHub 下载

2. **项目级配置** (`.ai-dev/config.json`)
   ```json
   {
     "default_test_command": "npm test",
     "auto_merge": true,
     "reviewers": ["@copilot"]
   }
   ```

---

## 🧪 测试与验证

### **1. Demo 模式**（无需配置）
```bash
/home/huiquanyun/.openclaw/workspace/skills/ai-dev/scripts/demo-ai-dev.sh
```

输出示例：
```
🎯 Task: Add a new function 'add(a, b)' that returns the sum of two numbers
✅ AI Agent completed changes!
🧪 Running test...
add(2, 3) = 5
✅ Test passed!
```

### **2. 实际项目测试**

```bash
cd /home/huiquanyun/.openclaw/workspace/skills/ai-dev/examples/test-project

# 手动模拟 AI 执行（演示用）
node -e "console.log('Testing...')"
git add . && git commit -m "Test commit"
git push origin main
```

---

## 📊 工作流程详解

### **完整流程图：**

```
用户输入需求
    ↓
[AI Dev Script]
    ↓
Spawn AI Agent (Claude Code)
    ↓
Agent analyzes codebase
    ↓
Implement changes
    ↓
Run tests (npm test / pytest)
    ↓
{Tests Pass?} ──No──→ Auto-fix attempt (x3)
    │                   ↓
   Yes                {Fixes?}
    │                   ├──No──→ Report failure
    ↓                  ↓
Commit changes       Yes
    ↓
Push to feature branch
    ↓
Create PR via gh CLI
    ↓
Request reviewers
    ↓
✅ Done!
```

---

## ⚠️ 注意事项

### **✅ 推荐用法：**
- ✅ 单个明确的任务描述
- ✅ 提供测试命令（如果有）
- ✅ Feature branch 工作流
- ✅ PR review 机制

### **❌ 避免：**
- ❌ 过于宽泛的需求 ("优化整个系统")
- ❌ 多任务混合 ("做 A 和 B 和 C")
- ❌ 生产环境直接修改
- ❌ 删除重要文件/分支

---

## 🎯 下一步计划

### **Phase 1: MVP (Ready Now)** ✅
- [x] Basic workflow script
- [x] Demo mode working
- [ ] ACP runtime integration
- [ ] Real agent spawning

### **Phase 2: Enhancement** 🔧
- [ ] Auto PR review comments
- [ ] Better error recovery
- [ ] Test coverage reporting
- [ ] Code quality checks

### **Phase 3: Advanced** 🚀
- [ ] Multi-task batching
- [ ] Learning from past PRs
- [ ] Integration with issue trackers
- [ ] Auto-merge on CI pass

---

## 💡 使用技巧

### **1. 任务描述要具体**
```bash
# ✅ Good - 具体明确
/ai-dev . --task "Add email validation regex to user model"

# ❌ Bad - 太宽泛
/ai-dev . --task "Fix user stuff"
```

### **2. 提供测试命令**
```bash
/ai-dev . --task "Refactor API handlers" --test "npm run test:api"
```

### **3. 分步迭代（推荐）**
```bash
# Round 1: Basic implementation
/ai-dev . --task "Create login endpoint"

# Review, then refine
/ai-dev . --task "Add error handling and JWT tokens"

# Final polish
/ai-dev . --task "Write unit tests for auth module"
```

---

## 📚 相关文档

- [SKILL.md](./skills/ai-dev/SKILL.md) - Skill definition
- [README.md](./skills/ai-dev/README.md) - Full documentation  
- [QUICKSTART.md](./skills/ai-dev/QUICKSTART.md) - Quick start guide
- [AI_DEV_SUMMARY.md](./AI_DEV_SUMMARY.md) - Complete summary

---

## 🎉 开始使用！

现在 AI Dev Skill 已经 ready for use！

**最简单的开始方式：**
```bash
/home/huiquanyun/.openclaw/workspace/skills/ai-dev/scripts/demo-ai-dev.sh
```

**真实项目使用（待 ACP runtime 配置后）：**
```bash
/ai-dev /path/to/project --task "你的需求"
```

享受全自动开发的乐趣！🚀
