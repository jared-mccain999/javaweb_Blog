<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>编辑博客</title>
    <link href="https://unpkg.com/@wangeditor/editor@latest/dist/css/style.css" rel="stylesheet">
    <style>
        /* 样式部分保持不变 */
        #editor-wrapper { border: 1px solid #ccc; margin-bottom: 15px; }
        #toolbar-container { border-bottom: 1px solid #ccc; }
        #editor-container { min-height: 500px; }
        .form-container { max-width: 800px; margin: 20px auto; padding: 20px; }
        .form-group { margin-bottom: 15px; }
        .tag-container { display: flex; gap: 10px; flex-wrap: wrap; }
        .tag-item { padding: 5px 10px; background: #f0f0f0; border-radius: 15px; cursor: pointer; }
        .tag-item.selected { background: #007bff; color: white; }
        #imagePreview img { max-width: 200px; margin-top: 10px; }
    </style>
</head>
<body>
<div class="form-container">
    <form id="blogForm">
        <!-- 标题 -->
        <div class="form-group">
            <input type="text" id="title" placeholder="请输入标题" required>
        </div>

        <!-- 编辑器 -->
        <div class="form-group" id="editor-wrapper">
            <div id="toolbar-container"></div>
            <div id="editor-container"></div>
        </div>

        <!-- 图片上传 -->
        <div class="form-group">
            <input type="file" id="imageUpload" accept="image/*">
            <div id="imagePreview"></div>
        </div>

        <!-- 区域选择 -->
        <div class="form-group">
            <select id="areaSelect">
                <option value="">请选择区域</option>
                <option th:each="area : ${areas}"
                        th:value="${area.id}"
                        th:text="${area.name}"></option>
            </select>
        </div>

        <!-- 标签选择 -->
        <div class="form-group">
            <div class="tag-container" id="tagContainer">
                <div th:each="tag : ${tags}"
                     class="tag-item"
                     th:data-id="${tag.id}"
                     th:text="${tag.tagName}"></div>
            </div>
        </div>

        <button type="submit">发布博客</button>
    </form>
</div>

<script src="https://unpkg.com/@wangeditor/editor@latest/dist/index.js"></script>
<script>
    // 初始化编辑器配置
    const { createEditor, createToolbar } = window.wangEditor
    const editorConfig = {
        placeholder: '请输入内容...',
        onChange(editor) {
            console.log('内容变化：', editor.getHtml())
        },
        MENU_CONF: {
            uploadImage: {
                async customUpload(file, insertFn) {
                    const formData = new FormData()
                    formData.append('file', file)

                    try {
                        const response = await fetch('/user/uploadImage', {
                            method: 'POST',
                            body: formData
                        })

                        if (!response.ok) {
                            const errorText = await response.text()
                            throw new Error(errorText || '上传失败')
                        }

                        const imagePath = await response.text()
                        insertFn(imagePath, '', '')
                    } catch (error) {
                        throw new Error('图片上传失败: ' + error.message)
                    }
                },
                maxFileSize: 10 * 1024 * 1024,
                allowedFileTypes: ['image/*']
            }
        }
    }

    // 创建编辑器和工具栏
    const editor = createEditor({
        selector: '#editor-container',
        config: editorConfig,
        html: '<p><br></p>',
        mode: 'default'
    })
    createToolbar({
        editor,
        selector: '#toolbar-container',
        config: {},
        mode: 'default'
    })

    // 封面图片上传处理
    document.getElementById('imageUpload').addEventListener('change', async function(e) {
        const file = e.target.files[0]
        if (!file) return

        const formData = new FormData()
        formData.append('file', file)

        try {
            const response = await fetch('/user/uploadImage', {
                method: 'POST',
                body: formData
            })

            if (!response.ok) {
                const errorText = await response.text()
                throw new Error(errorText)
            }

            const imagePath = await response.text()
            document.getElementById('imagePreview').innerHTML = `
                <img src="${imagePath}">
            `
        } catch (error) {
            alert('封面图片上传失败: ' + error.message)
        }
    })

    // 标签选择逻辑
    document.querySelectorAll('.tag-item').forEach(item => {
        item.addEventListener('click', function() {
            const selected = document.querySelectorAll('.tag-item.selected')
            if (selected.length >= 3 && !this.classList.contains('selected')) return
            this.classList.toggle('selected')
        })
    })

    // 表单提交处理
    document.getElementById('blogForm').addEventListener('submit', async (e) => {
        e.preventDefault()
        const submitBtn = e.target.querySelector('button[type="submit"]')

        try {
            submitBtn.disabled = true
            submitBtn.textContent = '提交中...'

            // 数据校验
            const title = document.getElementById('title').value.trim()
            const areaId = parseInt(document.getElementById('areaSelect').value)
            const content = editor.getText().trim()
            const selectedTags = Array.from(document.querySelectorAll('.tag-item.selected'))

            if (!title) throw new Error('标题不能为空')
            if (content.length < 10) throw new Error('内容至少需要10个字符')
            if (!areaId) throw new Error('请选择所属区域')
            if (selectedTags.length === 0) throw new Error('请至少选择一个标签')
            if (selectedTags.length > 3) throw new Error('最多选择3个标签')

            // 构造请求数据
            const blogData = {
                title: title,
                content: editor.getHtml(),
                areaId: areaId,
                tagIds: selectedTags.map(tag => parseInt(tag.dataset.id))
            }

            // 提交数据
            const response = await fetch('/user/blog', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(blogData),
                credentials: 'include' // 携带cookie
            })

            if (!response.ok) {
                const errorText = await response.text()
                throw new Error(`请求失败: ${response.status} ${errorText}`)
            }

            const result = await response.json()
            if (result.code !== 200) throw new Error(result.message)

            alert('发布成功！')
            window.location.href = '/user/index'
        } catch (error) {
            console.error('提交失败:', error)
            alert(error.message)
        } finally {
            submitBtn.disabled = false
            submitBtn.textContent = '发布博客'
        }
    })
</script>
</body>
</html>