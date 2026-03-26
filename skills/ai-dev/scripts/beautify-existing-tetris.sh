#!/bin/bash
# Beautify EXISTING Tetris UI using REAL Claude Code Agent

echo "🎨 Starting AI-powered Tetris UI beautification..."
echo ""
echo "Project: /home/huiquanyun/桌面/Openclaw-AI-Code"
echo ""

cd /home/huiquanyun/桌面/Openclaw-AI-Code

# Create a detailed task for Claude Code focusing on the EXISTING files
TASK='You are enhancing an existing Tetris game. The project is at: /home/huiquanyun/桌面/Openclaw-AI-Code

Please beautify the UI of this Russian Tetris game with modern visual effects. Focus on modifying these files:
- index.html (current structure)
- css/style.css (existing styles)

Enhancement requirements:

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

Please read the existing files first, then modify them with detailed comments explaining each enhancement. Keep the game functionality intact while improving the visual design.'

echo "🤖 Sending task to REAL Claude Code Agent..."
echo ""

# Execute via OpenClaw agent with Claude Code
openclaw agent \
  --agent claude-code \
  --message "$TASK" \
  --timeout 300 \
  --thinking medium \
  --json 2>&1 | tee /tmp/tetris-beautify-result.json

echo ""
echo "✅ Task submitted to Claude Code!"
echo ""
echo "📊 Next steps:"
echo "1. Check the modified files in /home/huiquanyun/桌面/Openclaw-AI-Code"
echo "2. Open index.html in browser to see the beautified UI"
echo "3. Commit and push changes if satisfied"
