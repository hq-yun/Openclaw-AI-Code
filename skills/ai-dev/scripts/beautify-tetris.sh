#!/bin/bash
# Beautify Tetris UI using REAL Claude Code Agent

PROJECT_PATH="/home/huiquanyun/桌面/Openclaw-AI-Code"

echo "🎨 Starting AI-powered Tetris UI beautification..."
echo ""

cd "$PROJECT_PATH"

# Create a detailed task for Claude Code
TASK='美化和增强俄罗斯方块游戏的 UI，使其更加现代化和吸引人。具体要求：

1. **整体视觉升级**：
   - 使用更现代的渐变色彩方案（霓虹色、赛博朋克风格）
   - 添加玻璃态效果（glassmorphism）到统计面板和控制区域
   - 优化阴影和圆角设计，增加层次感

2. **游戏画布增强**：
   - 改进方块的视觉表现，添加发光效果和轻微的光泽感
   - 每个方块使用独特的霓虹配色方案
   - 背景添加微妙的网格线动画

3. **UI 组件美化**：
   - 统计面板（分数、等级、行数）使用半透明玻璃态设计
   - 按钮添加平滑的悬停动画和颜色过渡效果
   - 控制说明区域使用图标 + 文字的组合，更直观
   - 下一个方块预览区增加边框发光效果

4. **交互增强**：
   - 消行时添加全屏闪光效果（CSS animation）
   - 游戏结束时的庆祝动画（弹跳、缩放效果）
   - 暂停/开始按钮使用不同的视觉状态

5. **色彩方案**：
   - 主色调：霓虹紫 (#bf00ff)、电光蓝 (#00ffff)、激光红 (#ff0055)
   - 背景：深色渐变 + 动态网格线
   - 方块颜色：每种方块使用独特的发光配色

请修改 index.html 和 css/style.css 文件，保持代码结构清晰并添加详细注释。'

echo "🤖 Sending task to Claude Code..."
echo ""

# Execute via OpenClaw agent with Claude Code
openclaw agent \
  --agent claude-code \
  --message "$TASK" \
  --timeout 300 \
  --thinking medium \
  --json

echo ""
echo "✅ Task submitted to Claude Code!"
echo ""
echo "📊 Next steps:"
echo "1. Check the modified files in $PROJECT_PATH"
echo "2. Open index.html in browser to see the beautified UI"
echo "3. Commit and push changes if satisfied"
