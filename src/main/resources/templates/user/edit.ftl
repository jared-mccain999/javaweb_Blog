<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>博客编辑</title>
  <script src="https://cdn.jsdelivr.net/gh/xwlrbh/HandyEditor@1.9.0/HandyEditor.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
  <style>
    .disabled {
      opacity: 0.6;
      pointer-events: none;
    }
  </style>
</head>
<body>

<h2>编辑博客</h2>

<label>标题：</label>
<input type="text" id="title" placeholder="请输入博客标题">

<br><br>
<label>区域：</label>
<select id="areaSelect">
  <#list areas as area>
    <option value="${area.id}">${area.name}</option>
  </#list>
</select>

<br><br>

<label>标签：</label>
<div id="tagsContainer">
  <#list tags as tag>
    <input type="checkbox" value="${tag.id}" id="tag-${tag.id}">
    <label for="tag-${tag.id}">${tag.tagName}</label>
  </#list>
</div>

<br><br>

<label>封面图片：</label>
<input type="file" id="imageUpload">
<img id="preview" src="" alt="封面预览" style="max-width: 200px; display: none;">

<br><br>

<label>内容：</label>
<textarea id="editor" name="editor" rows="5" style="display: none;"></textarea>

<br>
<button id="submitBtn" onclick="submitBlog()">提交博客</button>

<script>
  // 初始化富文本编辑器
  var he = HE.getEditor('editor', {
    width: '100%',
    height: '300px',
    autoHeight: true,
    autoFloat: true,
    uploadPhoto: true,
    uploadPhotoHandler: '/uploadImage',
    uploadPhotoType: 'gif,png,jpg,jpeg',
    uploadPhotoSize: 5000
  });

  // 监听图片上传
  document.getElementById('imageUpload').addEventListener('change', async function () {
    const file = this.files[0];
    if (!file) return;

    const formData = new FormData();
    formData.append("file", file);

    try {
      const res = await axios.post('/user/uploadImage', formData, { headers: { 'Content-Type': 'multipart/form-data' } });
      document.getElementById('preview').src = res.data;
      document.getElementById('preview').style.display = 'block';
    } catch (error) {
      alert('图片上传失败，请重试！');
      console.error('图片上传错误：', error);
    }
  });

  // 提交博客
  async function submitBlog() {
    const submitBtn = document.getElementById('submitBtn');
    // 禁用按钮，防止重复提交
    submitBtn.disabled = true;
    submitBtn.textContent = '发布中...';

    const title = document.getElementById('title').value.trim();
    const content = he.getHtml();
    const areaId = document.getElementById('areaSelect').value;
    const image = document.getElementById('preview').src;
    const selectedTags = Array.from(document.querySelectorAll('#tagsContainer input:checked'))
            .map(input => parseInt(input.value));

    if (!title || !content) {
      alert("标题和内容不能为空");
      // 恢复按钮状态
      submitBtn.disabled = false;
      submitBtn.textContent = '提交博客';
      return;
    }

    try {
      const res = await axios.post('/user/blog', {
        title,
        content,
        image,
        areaId,
        tagIds: selectedTags
      }, { withCredentials: true });

      if (res.data.code === 200) {
        alert("博客发布成功！");
        window.location.href = "/user/index";  // 跳转到用户首页或博客列表页面
      } else {
        alert("发布失败: " + res.data.message);
        // 发布失败时恢复按钮状态
        submitBtn.disabled = false;
        submitBtn.textContent = '提交博客';
      }
    } catch (error) {
      console.error("发布失败", error);
      alert("发布过程中出现错误，请稍后重试！");
      // 出现异常时恢复按钮状态
      submitBtn.disabled = false;
      submitBtn.textContent = '提交博客';
    }
  }
</script>

</body>
</html>

