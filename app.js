/**
 * 网站复刻助手 - 主应用逻辑
 */

// DOM 元素
const dropZone = document.getElementById('drop-zone');
const fileInput = document.getElementById('file-input');
const urlForm = document.getElementById('url-form');
const websiteUrl = document.getElementById('website-url');
const loading = document.getElementById('loading');
const resultSection = document.getElementById('result');
const previewFrame = document.getElementById('preview-frame');

// Tab 切换
document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        const tabName = btn.dataset.tab;
        
        // 更新按钮状态
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        // 切换内容
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
        document.getElementById(`${tabName}-tab`).classList.add('active');
    });
});

// 拖拽上传功能
dropZone.addEventListener('dragover', (e) => {
    e.preventDefault();
    dropZone.classList.add('drag-over');
});

dropZone.addEventListener('dragleave', () => {
    dropZone.classList.remove('drag-over');
});

dropZone.addEventListener('drop', (e) => {
    e.preventDefault();
    dropZone.classList.remove('drag-over');
    
    const files = e.dataTransfer.files;
    if (files.length > 0) {
        handleFileUpload(files[0]);
    }
});

// 点击上传
dropZone.addEventListener('click', () => {
    fileInput.click();
});

fileInput.addEventListener('change', (e) => {
    if (e.target.files.length > 0) {
        handleFileUpload(e.target.files[0]);
    }
});

// URL 表单提交
urlForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const url = websiteUrl.value.trim();
    if (!url) return;

    await processWebsite(url);
});

// 处理文件上传
async function handleFileUpload(file) {
    // 验证文件类型
    if (!file.type.match('image.*')) {
        alert('请上传图片文件 (JPG, PNG, GIF)');
        return;
    }

    // 检查文件大小（最大 10MB）
    if (file.size > 10 * 1024 * 1024) {
        alert('图片大小不能超过 10MB');
        return;
    }

    showLoading();
    
    try {
        // 读取文件为 Data URL
        const reader = new FileReader();
        
        reader.onload = async (e) => {
            const imageData = e.target.result;
            
            // TODO: 这里应该调用 AI API 分析截图
            // 暂时使用模拟数据演示功能
            
            await simulateAnalysis(imageData);
        };
        
        reader.readAsDataURL(file);
    } catch (error) {
        console.error('文件读取错误:', error);
        hideLoading();
        alert('上传失败，请重试');
    }
}

// 模拟 AI 分析过程（实际项目中替换为真实 API 调用）
async function simulateAnalysis(imageData) {
    // 等待 2 秒模拟处理时间
    await new Promise(resolve => setTimeout(resolve, 2000));
    
    // 生成一个示例网站作为预览
    const sampleHTML = generateSampleWebsite();
    
    // 显示结果
    displayResult(sampleHTML);
}

// 处理 URL 输入（实际项目中需要后端支持）
async function processWebsite(url) {
    showLoading();
    
    try {
        // TODO: 调用后端 API 抓取并分析网站
        // 这里使用模拟数据
        
        await new Promise(resolve => setTimeout(resolve, 2000));
        
        const sampleHTML = generateSampleWebsite();
        displayResult(sampleHTML);
        
    } catch (error) {
        console.error('处理失败:', error);
        hideLoading();
        alert('无法处理该 URL，请重试或尝试截图上传');
    }
}

// 生成示例网站 HTML（演示用）
function generateSampleWebsite() {
    return `
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>示例复刻页面</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }
        h1 {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        .button {
            display: inline-block;
            padding: 15px 40px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 30px;
            margin-top: 30px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎨 欢迎来到我的网站</h1>
        <p>这是一个由 AI 自动生成的示例页面，展示了网站复刻助手的功能。</p>
        <a href="#" class="button">了解更多</a>
    </div>
</body>
</html>
    `;
}

// 显示结果
function displayResult(htmlContent) {
    hideLoading();
    
    // 将 HTML 嵌入 iframe
    previewFrame.srcdoc = htmlContent;
    
    // 显示结果区域
    resultSection.classList.remove('hidden');
    
    // 滚动到结果区域
    resultSection.scrollIntoView({ behavior: 'smooth' });
}

// 下载代码
function downloadCode() {
    const htmlContent = previewFrame.srcdoc;
    if (!htmlContent) return;
    
    const blob = new Blob([htmlContent], { type: 'text/html' });
    const url = URL.createObjectURL(blob);
    
    const a = document.createElement('a');
    a.href = url;
    a.download = '复刻页面.html';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

// 在线编辑（预留功能）
function editCode() {
    alert('在线编辑功能即将上线！');
}

// UI 辅助函数
function showLoading() {
    loading.classList.remove('hidden');
    resultSection.classList.add('hidden');
}

function hideLoading() {
    loading.classList.add('hidden');
}

// 初始化
document.addEventListener('DOMContentLoaded', () => {
    console.log('网站复刻助手已启动 🚀');
});
