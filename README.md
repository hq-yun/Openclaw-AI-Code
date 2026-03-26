# 🎨 网站复刻助手 - Website Cloner AI

让网站建设变得简单高效，每个人都能拥有自己的理想网站。

![Website Cloner](./screenshot.png)

## ✨ 功能特性

### 🚀 核心功能

- **截图上传**：拖拽或上传图片文件（JPG、PNG、GIF），AI 自动分析页面结构
- **URL 输入**：直接输入目标网站地址，一键生成相似页面
- **智能复刻**：基于 AI 算法，精准还原设计风格和布局
- **响应式设计**：自动生成适配手机、平板和桌面的完美页面

### 💡 特色亮点

| 特性 | 描述 |
|------|------|
| ⚡ **极速生成** | AI 智能分析，秒级生成高质量代码 |
| 📱 **响应式支持** | 完美适配各种设备屏幕尺寸 |
| 💻 **干净代码** | 语义化 HTML + 现代化 CSS，易于维护 |
| 🎨 **可视化编辑** | 实时预览，所见即所得的在线编辑器 |

## 📋 项目结构

```
Openclaw-AI-Code/
├── index.html          # 主页面文件
├── README.md           # 项目文档（中文）
├── css/
│   └── style.css       # 样式文件
├── js/
│   └── app.js          # 应用逻辑
├── deploy.sh           # 部署脚本
└── .gitignore          # Git 忽略配置
```

## 🎯 使用指南

### 方式一：截图上传

1. 打开目标网站，截取想要的页面
2. 拖拽图片到上传区域，或点击选择文件
3. AI 自动分析并生成代码
4. 预览、编辑或下载生成的页面

**支持格式**: JPG, PNG, GIF  
**文件大小**: ≤ 10MB

### 方式二：URL 输入

1. 复制目标网站的完整 URL
2. 粘贴到输入框中
3. 点击"开始复刻"按钮
4. 等待 AI 分析完成

## 🛠️ 技术栈

- **前端**: HTML5, CSS3 (现代渐变和动画), Vanilla JavaScript (ES6+)
- **UI 设计**: 玻璃态效果，响应式布局，暗色主题
- **工具**: Font Awesome 图标库
- **部署**: GitHub Pages（免费托管）

## 🚀 本地运行

### 方法一：直接打开

最简单的方式，无需任何配置：

```bash
# 在项目目录中双击 index.html
```

或使用本地服务器：

```bash
# Python
python3 -m http.server 8000

# Node.js (需安装 http-server)
npx http-server -p 8000
```

然后访问 `http://localhost:8000`

### 方法二：使用 VS Code

1. 使用 [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) 扩展
2. 右键点击 `index.html` → "Open with Live Server"

## 📦 部署到 GitHub Pages

### 自动部署（推荐）

```bash
chmod +x deploy.sh
./deploy.sh
```

脚本会自动：
1. 创建优化后的分发目录
2. 初始化 git 仓库
3. 提交并推送到 `gh-pages` 分支
4. 更新 GitHub Pages

### 手动部署

```bash
# 1. 复制文件到 gh-pages 分支
git checkout -b gh-pages
git add .
git commit -m "Deploy website cloner"
git push origin gh-pages

# 2. 在 GitHub 仓库设置中启用 Pages
# Settings → Pages → Source: gh-pages branch
```

### 部署后访问

网站将在以下地址上线：
```
https://<你的用户名>.github.io/Openclaw-AI-Code/
```

## 🎨 自定义开发

### 修改主题颜色

编辑 `css/style.css` 中的 CSS 变量：

```css
:root {
    --primary-color: #6366f1;      /* 主色调 */
    --secondary-color: #8b5cf6;    /* 辅助色 */
    --accent-color: #ec4899;       /* 强调色 */
    --dark-bg: #0f172a;            /* 背景色 */
}
```

### 添加新功能

项目采用模块化设计，易于扩展：

1. **前端逻辑**: `js/app.js` - 处理文件上传、AI 分析等
2. **UI 组件**: `index.html` - 页面结构
3. **样式系统**: `css/style.css` - 统一的设计风格

### AI 集成（未来计划）

当前版本为前端演示，后续将集成真实 AI API：

- 🤖 **图像识别**: 使用计算机视觉分析截图
- 🎯 **代码生成**: GPT/Claude 等模型生成 HTML/CSS
- 🔧 **智能优化**: 自动改进生成的代码质量

## 🌟 示例场景

### 1. 电商落地页复刻

快速创建高转化率的电商页面，复制竞争对手的优秀设计。

### 2. 企业官网搭建

专业形象展示，提升品牌信任度和在线影响力。

### 3. 个人作品集

设计师、开发者展示才华，吸引雇主和客户的关注。

### 4. 活动宣传页

快速制作活动介绍、报名页面，助力营销推广。

## 📱 响应式设计

网站完全适配各种设备：

- **桌面端**: 1200px 最大宽度，多列布局
- **平板**: 768px - 1024px，自适应调整
- **手机端**: < 768px，单列流式布局

## 🔧 开发指南

### 项目结构说明

```
css/
└── style.css          # 全局样式和组件

js/
└── app.js             # 应用逻辑（文件上传、AI 分析模拟）

index.html             # 主页面，包含所有 UI 组件
deploy.sh              # GitHub Pages 部署脚本
```

### 代码规范

- **HTML**: 语义化标签，符合 WCAG 2.1 无障碍标准
- **CSS**: BEM 命名约定，使用 CSS 变量
- **JavaScript**: ES6+ 语法，模块化设计，JSDoc 注释

### 浏览器支持

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## 📄 许可证

本项目为开源项目，仅供学习和演示用途。

## 💬 反馈与建议

如有问题或建议，欢迎通过以下方式联系：

- **GitHub Issues**: 提交 bug 报告和功能请求
- **Email**: support@example.com

---

**🎉 立即开始使用，打造你的理想网站！**

*最后更新：2026-03-26*  
*维护者：OpenClaw AI Assistant*
