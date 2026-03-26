# SKILL.md - AI Code Development Workflow

**全自动 AI 开发工作流：需求 → 代码 → 测试 → PR**

## 🎯 核心功能

### **一键式 AI 开发流程：**
```bash
/ai-dev [项目路径] --task "你的需求描述"
```

**自动完成：**
1. ✅ Fork/克隆仓库
2. ✅ 创建特性分支
3. ✅ Claude Code 执行代码修改
4. ✅ 运行测试并修复
5. ✅ Commit + Push
6. ✅ 创建 Pull Request
7. ✅ 请求审查（可选）

---

## 📋 使用示例

### **基础用法：**
```bash
/ai-dev /path/to/repo --task "添加用户登录功能"
```

### **指定测试命令：**
```bash
/ai-dev /path/to/repo --task "修复 bug #123" --test "npm test"
```

### **创建 PR 并请求审查：**
```bash
/ai-dev /path/to/repo --task "优化性能" --reviewer "@copilot,@team-lead"
```

---

## 🔧 内部流程

### **1. Fork & Clone**
- 自动 fork 目标仓库（如果需要）
- 克隆到工作区
- 创建特性分支：`feature/ai-dev-[timestamp]`

### **2. Code Execution**
- 调用 Claude Code agent (`sessions_spawn`)
- 传递需求描述作为任务
- 监控执行进度

### **3. Testing & Fixing**
- 自动检测测试命令（package.json, pytest, etc.）
- 运行测试套件
- 失败时自动修复常见错误
- 重试机制（最多 3 次）

### **4. Commit & Push**
```bash
git add .
git commit -m "AI Dev: [任务描述]"
git push origin feature/ai-dev-[timestamp]
```

### **5. Create PR**
```bash
gh pr create \
  --title "AI Dev: [任务描述]" \
  --body "自动创建的 PR：[需求描述]\n\n测试状态：✅ 通过" \
  --base main \
  --reviewer @copilot
```

### **6. Auto-Merge (可选)**
- 所有测试通过后自动请求合并
- 可配置自动合并策略

---

## 🛠️ 配置文件

在仓库根目录创建 `.ai-dev/config.json`：

```json
{
  "default_test_command": "npm test",
  "auto_merge": true,
  "reviewers": ["@copilot"],
  "labels": ["ai-generated", "automated"]
}
```

---

## ⚠️ 安全限制

**自动执行（无需确认）：**
- ✅ 代码修改
- ✅ 运行测试
- ✅ Commit + Push
- ✅ 创建 PR

**需要人工确认的操作：**
- ❌ 删除分支/文件
- ❌ 合并到主分支
- ❌ 部署生产环境
- ❌ 执行任意 shell 命令（超出工作区）

---

## 📊 状态追踪

每次执行生成报告：

```markdown
# AI Dev Report

**任务**: [需求描述]
**时间**: 2026-03-26 11:30 GMT+8
**分支**: feature/ai-dev-20260326113000

## ✅ Completed
- Fork & Clone: ✓
- Code Changes: ✓
- Tests Passed: ✓ (45/45)
- PR Created: #123

## 🔗 Links
- Branch: https://github.com/.../tree/feature/ai-dev-...
- PR: https://github.com/.../pull/123
```

---

## 🚀 高级用法

### **多轮对话迭代：**
```bash
# 第一轮：基础实现
/ai-dev /repo --task "添加用户登录"

# 第二轮：优化代码
/ai-dev /repo --task "重构登录逻辑，增加错误处理"

# 第三轮：完善测试
/ai-dev /repo --task "补充单元测试覆盖率到 90%"
```

### **批量任务：**
```bash
/ai-dev /repo --tasks "bug1, bug2, feature1"
```

---

## 🎯 目标愿景

**让开发像聊天一样简单：**
- 你说需求，AI 实现
- 你 review PR，AI 修复
- 你批准合并，自动完成

**零 git 命令，零手动操作！**
