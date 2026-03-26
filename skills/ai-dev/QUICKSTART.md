# AI Dev - 快速开始指南 🚀

## 1️⃣ 安装配置

### **Step 1: 确保 Claude Code Agent 可用**

```bash
openclaw agents list
```

确认有 `claude-code` 或 `codex` agent。

### **Step 2: 配置 GitHub CLI (可选)**

```bash
gh auth login
```

这样 PR 创建会更流畅。

## 2️⃣ 使用示例

### **场景 A: 为现有项目添加功能**

```bash
# 在仓库目录执行
cd /home/huiquanyun/桌面/Openclaw-AI-Code

# 添加新功能
/ai-dev . --task "添加一个计算器工具类"
```

### **场景 B: 修复 Bug**

```bash
/ai-dev . --task "修复登录页面的响应式布局问题" --test "npm test"
```

### **场景 C: 代码重构**

```bash
/ai-dev . --task "将 utils.js 中的函数迁移到独立的模块"
```

## 3️⃣ 工作流程

当你执行 `/ai-dev` 后：

1. **AI Agent 启动** - Claude Code 被 spawn 为子会话
2. **代码分析** - AI 分析项目结构和需求
3. **实现功能** - 修改/创建文件
4. **运行测试** - 自动执行 `npm test` / `pytest` 等
5. **修复问题** - 如果测试失败，AI 尝试自动修复
6. **报告结果** - 返回修改摘要和下一步建议

## 4️⃣ 常见场景

### ✅ **推荐用法：**
- 单个明确的任务描述
- 提供测试命令（如果有）
- 在 feature branch 上工作

### ⚠️ **避免：**
- 过于宽泛的需求 ("优化整个系统")
- 多任务混合 ("做 A 和 B 和 C")
- 生产环境直接修改

## 5️⃣ 调试技巧

如果 AI 执行失败：

1. **查看详细日志** - 在 spawned session 中查看输出
2. **简化任务** - 将大任务拆分为小步骤
3. **提供上下文** - 指定关键文件路径
4. **手动干预** - 必要时手动修复后继续

## 6️⃣ 示例对话

```
User: /ai-dev . --task "添加用户邮箱验证功能"

[AI Agent executes...]
- Analyzes user model structure
- Creates email verification service
- Adds validation middleware
- Writes unit tests
- Commits changes

AI Report:
✅ Completed! Files modified: 5
Tests: 12/12 passed
Ready to review PR #42
```

## 🎯 下一步

开始测试你的第一个 AI Dev 任务：

```bash
cd /home/huiquanyun/.openclaw/workspace/skills/ai-dev/examples/test-project
/ai-dev . --task "添加一个 greet 函数的测试用例"
```

享受自动化的力量！🚀
