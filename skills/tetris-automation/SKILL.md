# Tetris Automation Skill

自动化俄罗斯方块游戏的开发、测试和部署流程。

## 用途

当需要对 Tetris 游戏进行修改时，使用此 skill 确保每次修改都经过完整的开发和部署流程：

1. **代码修改** - 由 Claude Code 完成所有代码工作
2. **本地测试** - 验证功能正常
3. **Git 提交** - 规范化的 commit message
4. **推送到 GitHub** - 同步到远程仓库
5. **GitHub Pages 部署** - 发布到线上

## 使用方法

### 基本用法

```bash
# 在 Tetris 项目目录中运行
/tetris-automation [修改描述]
```

### 示例

```bash
# 修复幽灵块重影问题
/tetris-automation "fix: correct ghost piece rendering artifacts"

# 添加新特性
/tetris-automation "feat: add sound effects for line clear"

# 优化性能
/tetris-automation "perf: optimize canvas rendering loop"
```

## 自动化流程详解

### 1. Claude Code 代码修改

**重要**: 所有代码相关工作必须由 Claude Code agent 完成，确保：
- 代码质量符合规范
- 遵循现有架构
- 添加必要的注释
- 考虑边界情况

调用方式（自动执行）：
```bash
sessions_spawn \
  --task "[具体修改任务]" \
  --runtime acp \
  --agentId claude-code \
  --cwd /home/huiquanyun/桌面/Openclaw-AI-Code \
  --mode session \
  --thread false
```

### 2. 本地验证

在 Claude Code 完成后，自动执行：
- 检查文件完整性
- 验证 HTML/CSS/JS语法
- 确保没有引入新错误

### 3. Git 提交规范

使用约定式提交（Conventional Commits）：
- `feat:` 新功能
- `fix:` Bug 修复
- `docs:` 文档更新
- `style:` 代码格式
- `refactor:` 重构
- `perf:` 性能优化
- `test:` 测试相关
- `chore:` 构建/工具

### 4. 推送到 GitHub

```bash
git add .
git commit -m "[类型]: [描述]"
git push origin main
```

### 5. GitHub Pages 部署

```bash
./deploy.sh
cd dist
git remote add origin https://github.com/hq-yun/Openclaw-AI-Code.git
git push origin gh-pages --force
```

## 项目结构

```
/home/huiquanyun/桌面/Openclaw-AI-Code/
├── index.html          # 主页面
├── README.md           # 中文文档
├── css/
│   └── style.css       # 样式文件
├── js/
│   ├── game.js         # 游戏核心逻辑
│   └── pieces.js       # 方块定义和旋转
├── deploy.sh           # 部署脚本
└── .git/               # Git 仓库
```

## 注意事项

1. **必须使用 Claude Code**: 所有代码修改都必须通过 Claude Code agent，不能手动编辑
2. **完整流程**: 每次修改都要走完整个自动化流程，不能跳过任何步骤
3. **中文文档**: README.md 必须是中文书写
4. **测试先行**: 在提交前确保本地功能正常
5. **回滚能力**: 保留清晰的 commit history，便于回滚

## 常见问题

### Q: Claude Code 修改后需要测试吗？
A: 是的，automated flow 会自动检查文件完整性，但建议手动打开浏览器验证功能。

### Q: 部署失败怎么办？
A: 检查：
- Git 连接是否正常
- GitHub Pages 是否启用
- dist 目录是否正确生成

### Q: 可以跳过某些步骤吗？
A: 不建议。完整流程确保代码质量和版本一致性。紧急情况下可手动执行部分步骤，但需记录原因。

## 示例工作流

```bash
# 1. 发现问题：幽灵块重影
# 2. 调用 skill
/tetris-automation "fix: correct ghost piece rendering artifacts in game.js"

# 3. 等待 Claude Code 完成修改

# 4. 自动执行完整流程：
   - ✅ 代码修改（Claude Code）
   - ✅ Git 提交
   - ✅ 推送到 GitHub
   - ✅ GitHub Pages 部署

# 5. 访问验证：https://hq-yun.github.io/Openclaw-AI-Code/
```
