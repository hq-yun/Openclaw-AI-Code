# Tetris 自动化命令速查表

## 基本用法

```bash
/tetris-automation "[修改描述]"
```

## 常用场景示例

### 🐛 Bug 修复

```bash
/tetris-automation "fix: correct ghost piece rendering artifacts"
/tetris-automation "fix: resolve line clear animation stuttering"
/tetris-automation "fix: prevent piece rotation near walls causing glitches"
```

### ✨ 新功能添加

```bash
/tetris-automation "feat: add sound effects for all game actions"
/tetris-automation "feat: implement hard drop with visual trail effect"
/tetris-automation "feat: add next 3 pieces preview instead of just 1"
```

### 🎨 UI/UX改进

```bash
/tetris-automation "style: improve button hover and click animations"
/tetris-automation "refactor: reorganize CSS for better maintainability"
/tetris-automation "style: add loading animation when game initializes"
```

### ⚡ 性能优化

```bash
/tetris-automation "perf: optimize canvas rendering loop for smoother gameplay"
/tetris-automation "perf: reduce memory usage in line clearing algorithm"
/tetris-automation "perf: implement object pooling for game pieces"
```

### 📝 文档更新

```bash
/tetris-automation "docs: update README with new features and controls"
/tetris-automation "docs: add contribution guidelines for contributors"
```

### 🔧 代码重构

```bash
/tetris-automation "refactor: extract game logic into separate module"
/tetris-automation "refactor: improve code comments and JSDoc coverage"
```

## 完整工作流示例

### 场景：修复幽灵块重影问题

**1. 调用自动化技能**:
```bash
/tetris-automation "fix: correct ghost piece rendering artifacts in game.js"
```

**2. 自动执行流程**:
- ✅ Claude Code agent 读取并分析代码
- ✅ 定位幽灵块绘制逻辑问题
- ✅ 实施修复（ctx.save/restore + alpha reset）
- ✅ 验证修改正确性
- ✅ Git commit: "fix: correct ghost piece rendering artifacts"
- ✅ Push to GitHub
- ✅ Deploy to GitHub Pages

**3. 访问验证**:
```
https://hq-yun.github.io/Openclaw-AI-Code/
```

## 注意事项

### ⚠️ 重要提醒

1. **必须使用 Claude Code**: 
   - 所有代码修改都必须通过 Claude Code agent
   - 不能手动编辑项目文件后直接提交
   
2. **完整流程不可跳过**:
   - 每个步骤都有其必要性
   - 跳过可能导致部署失败或代码不一致

3. **中文文档要求**:
   - README.md 必须是中文
   - 其他技术文档可以是英文

4. **修改描述要清晰**:
   - 使用约定式提交格式：`类型：描述`
   - 示例：`fix: correct ghost piece rendering artifacts`

### ✅ 最佳实践

1. **小步快跑**: 
   - 每次只做少量修改
   - 便于追踪和回滚

2. **测试先行**:
   - Claude Code 完成后，先在本地打开浏览器测试
   - 确认功能正常后再部署

3. **记录变更**:
   - 在 README.md 的"已知问题修复"部分记录重大修改
   - 保持更新日志清晰

4. **及时沟通**:
   - 如遇问题立即报告
   - 不要强行推进有问题的流程

## 故障排除

### 如果自动化失败

**1. 检查 Git 状态**:
```bash
cd /home/huiquanyun/桌面/Openclaw-AI-Code
git status
```

**2. 解决冲突**:
```bash
git pull --rebase origin main
# 解决冲突后
git add .
git rebase --continue
```

**3. 重新运行自动化**:
```bash
/tetris-automation "[同样的修改描述]"
```

### 如果 Claude Code 没有完成

**1. 检查子代理状态**:
```bash
subagents action=list
```

**2. 手动干预**:
```bash
# 杀死卡住的 agent
subagents action=kill target=claude-code

# 重新调用自动化
/tetris-automation "[修改描述]"
```

## 快速参考

| 命令 | 说明 |
|------|------|
| `/tetris-automation "fix: ..." ` | 修复 Bug |
| `/tetris-automation "feat: ..." ` | 添加新功能 |
| `/tetris-automation "perf: ..." ` | 性能优化 |
| `/tetris-automation "style: ..." ` | UI/UX改进 |
| `/tetris-automation "docs: ..." ` | 文档更新 |

## Live URL

**当前版本访问地址**:
```
https://hq-yun.github.io/Openclaw-AI-Code/
```

每次自动化流程完成后，这个链接会自动部署最新的修改。

---

**提示**: 将常用命令添加到个人笔记中，方便快速调用！
