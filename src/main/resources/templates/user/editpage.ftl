<#include "../import/top_user.ftl">
<script src="https://cdn.jsdelivr.net/gh/xwlrbh/HandyEditor@1.9.0/HandyEditor.min.js"></script>

<style>
    /* 保持原有样式不变，新增tag相关样式 */
    .tag-input-container {
        border: 1px solid #ddd;
        padding: 5px;
        border-radius: 4px;
        display: flex;
        flex-wrap: wrap;
        gap: 5px;
    }

    .tag-item {
        background: #e0e0e0;
        padding: 2px 8px;
        border-radius: 12px;
        display: flex;
        align-items: center;
    }

    .tag-item button {
        margin-left: 5px;
        background: none;
        border: none;
        cursor: pointer;
        color: #666;
    }

    #tagInput {
        border: none;
        outline: none;
        padding: 5px;
        flex-grow: 1;
        min-width: 120px;
    }

    .error {
        color: #ff4444;
        font-size: 0.8em;
        margin-top: 5px;
    }
</style>
</head>
<body>
<div class="container">
    <form id="postForm">
        <!-- 标题和领域保持不变 -->
        <div class="form-group">
            <label for="title">标题：</label>
            <input type="text" id="title" required>
        </div>

        <div class="form-group">
            <label for="category">领域：</label>
            <select id="category" required>
                <!-- 实际应从后端获取 -->
                <option value="">请选择领域</option>

            </select>
        </div>

        <!-- 修改后的标签输入区域 -->
        <div class="form-group">
            <label>标签（最多3个）：</label>
            <div class="tag-input-container">
                <div id="tagsContainer"></div>
                <input type="text"
                       id="tagInput"
                       placeholder="输入后按空格或逗号分隔"
                       maxlength="10">
            </div>
            <div class="error" id="tagError"></div>
        </div>

        <!-- 编辑器容器 -->
        <div class="form-group">
            <label>内容：</label>
            <textarea id="editor"></textarea>
        </div>

        <button type="submit" class="submit-btn">发布文章</button>
    </form>
</div>

<script>
    // 初始化HandyEditor（带完整配置）
    var he = HE.getEditor('editor', {
        width: '100%',
        height: '500px',
        autoHeight: false,
        autoFloat: true,
        topOffset: 30,
        uploadPhoto: true,
        uploadPhotoHandler: '/api/upload',  // 根据实际接口修改
        uploadPhotoSize: 2048,  // 2MB
        uploadPhotoType: 'gif,png,jpg,jpeg,webp',
        uploadPhotoSizeError: '图片大小不能超过2MB',
        uploadPhotoTypeError: '仅支持图片格式：gif,png,jpg,jpeg,webp',
        uploadParam: {
            token: 'example-token'  // 根据实际情况传递参数
        },
        lang: 'zh-jian',
        skin: 'HandyEditor',
        item: [
            'bold', 'italic', 'underline', 'strike', '|',
            'fontSize', 'fontName', '|',
            'color', 'backColor', '|',
            'left', 'center', 'right', 'full', '|',
            'link', 'unlink', 'image', '|',
            'undo', 'redo', '|',
            'html', 'about'
        ]
    });

    // 标签管理逻辑
    const tags = [];
    const maxTags = 3;

    document.getElementById('tagInput').addEventListener('input', function (e) {
        const input = e.target;
        const value = input.value.trim();

        // 检测分隔符（空格或逗号）
        if (/,| /.test(value)) {
            const tag = value.replace(/,| /g, '');
            if (tag.length > 0) {
                addTag(tag);
                input.value = '';
            }
        }
    });

    function addTag(tag) {
        const errorEl = document.getElementById('tagError');

        // 验证标签
        if (tags.length >= maxTags) {
            errorEl.textContent = `最多只能添加3个标签`;
            return;
        }
        if (tag.length > 10) {
            errorEl.textContent = '标签长度不能超过10个字符';
            return;
        }
        if (tags.includes(tag)) {
            errorEl.textContent = '该标签已存在';
            return;
        }

        // 添加标签
        tags.push(tag);
        errorEl.textContent = '';
        renderTags();
    }

    function renderTags() {
        const container = document.getElementById('tagsContainer');
        container.innerHTML = tags.map(tag => `
                <div class="tag-item">
                    ${tag}
                    <button type="button" onclick="removeTag('${tag}')">&times;</button>
                </div>
            `).join('');
    }

    window.removeTag = function (tag) {
        const index = tags.indexOf(tag);
        if (index > -1) {
            tags.splice(index, 1);
            renderTags();
        }
    }

    // 表单提交
    document.getElementById('postForm').addEventListener('submit', function (e) {
        e.preventDefault();

        // 收集数据
        const postData = {
            title: document.getElementById('title').value,
            category: document.getElementById('category').value,
            tags: tags,
            content: he.getHtml()
        };

        // 验证数据
        if (!postData.title) return alert('请输入标题');
        if (!postData.category) return alert('请选择领域');
        if (tags.length === 0) return alert('请添加至少一个标签');
        if (!postData.content) return alert('请输入文章内容');

        // 这里添加实际提交逻辑
        console.log('提交数据：', postData);
        alert('提交成功（模拟）');
    });
</script>

<#include "../import/bottom.ftl">