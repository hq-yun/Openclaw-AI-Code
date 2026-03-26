# 设置真实的 Claude Code Agent

## 🎯 目标
将 AI Dev 从 Demo 模式切换到真实 Claude Code 执行。

---

## 📋 当前状态

- ✅ Git Hooks: Active
- ✅ Auto-Test: Ready  
- ✅ Auto-PR: Ready
- ❌ **Claude Code Agent: Not configured** (Demo mode only)

---

## 🔧 配置步骤

### **Step 1: 检查 OpenClaw 版本和插件**

```bash
openclaw version
openclaw plugins list
```

需要确保有 ACP runtime plugin。

### **Step 2: 安装 ACP Runtime (如果未安装)**

```bash
# Try to install acpx plugin
openclaw plugins install acpx

# Or check available plugins
openclaw plugins search claude
```

### **Step 3: 配置允许的 Agents**

编辑 OpenClaw config，添加：

```yaml
acp:
  allowedAgents:
    - claude-code
    - codex
  defaultAgent: claude-code
```

### **Step 4: 验证 Agent 可用性**

```bash
openclaw agents list
# Should show: [claude-code, main]
```

### **Step 5: 测试 Claude Code 调用**

```bash
# Test with a simple task
openclaw sessions spawn \
  --runtime acp \
  --agent-id claude-code \
  --task "Print 'Hello from Claude'" \
  --mode run \
  --timeout-seconds 30
```

---

## 🔄 切换 AI Dev 到真实模式

### **修改 ai-dev.sh**

找到 Demo 部分：

```bash
# OLD (Demo mode):
cat > index.js <<'EOF'
function add(a, b) { return a + b; }
EOF
```

替换为真实调用：

```bash
# NEW (Real mode):
/home/huiquanyun/.openclaw/workspace/skills/ai-dev/scripts/run-claude-code.sh \
  "$PROJECT_PATH" \
  "$TASK" \
  "$TEST_CMD"
```

### **运行测试**

```bash
# Test with real Claude Code
cd /home/huiquanyun/.openclaw/workspace/skills/ai-dev/examples/test-project
/home/huiquanyun/.openclaw/workspace/skills/ai-dev/scripts/run-claude-code.sh \
  . \
  "Add a multiply function" \
  ""
```

---

## 🐛 常见问题

### **Q: `sessions_spawn` 返回 error: ACP runtime backend is not configured**

**A:** 需要安装 ACP plugin:
```bash
openclaw plugins install acpx
openclaw gateway restart
```

### **Q: Agent not found in agents_list**

**A:** Check config file and restart OpenClaw.

### **Q: Claude Code session hangs**

**A:** Increase timeout or check model availability.

---

## ✅ 验证清单

- [ ] ACP runtime installed
- [ ] `claude-code` agent listed in `agents list`
- [ ] Test task completes successfully
- [ ] AI Dev script calls real Claude Code (not demo)
- [ ] Files are actually modified by AI
- [ ] Tests run on AI-generated code

---

## 🚀 完成后的效果

```bash
/ai-dev . --task "Add user login"

# Real execution:
🤖 Starting REAL Claude Code Agent...
✅ Analyzing codebase (5 files, 200 lines)
✅ Implementing login feature
✅ Writing tests (12 tests created)
✅ Running tests: 12/12 passed
✅ Commit message: "feat(auth): add user login"
📝 Implementation report returned

# Then auto-test + auto-push runs...
```

---

## 📞 需要帮助？

如果配置遇到问题，可以：
1. Check OpenClaw logs: `openclaw gateway logs`
2. Review ACP plugin docs
3. Contact OpenClaw support
