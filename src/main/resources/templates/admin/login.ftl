<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" href="/img/favicon.ico">
    <link rel="stylesheet" href="//cdn.bootcdn.net/ajax/libs/zui/1.10.0/css/zui.min.css">
    <script src="//cdn.bootcdn.net/ajax/libs/zui/1.10.0/lib/jquery/jquery.js"></script>
    <script src="//cdn.bootcdn.net/ajax/libs/zui/1.10.0/js/zui.min.js"></script>
    <title>Ryan 后台管理系统 - 登录</title>
    <style>
        .login-container {
            max-width: 560px;
            margin: 100px auto;
            padding: 40px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,.1);
            animation: fadeIn 0.6s;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .password-wrapper { position: relative; }
        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            background: none;
            border: none;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="login-container">
        <div class="login-header text-center">
            <h2><i class="icon icon-lock"></i> 后台管理系统</h2>
            <p class="text-muted">请使用管理员账号登录</p>
        </div>
        <form id="loginForm">
            <div class="form-group">
                <label>用户名</label>
                <input type="text"
                       class="form-control"
                       id="username"
                       name="username"
                       placeholder="请输入用户名"
                       required>
            </div>
            <div class="form-group">
                <label>密码</label>
                <div class="password-wrapper">
                    <input type="password"
                           class="form-control"
                           id="password"
                           name="password"
                           placeholder="请输入密码"
                           required
                           minlength="4"
                           maxlength="40">
                    <button type="button"
                            class="password-toggle"
                            onclick="togglePassword()">
                        <i class="icon icon-eye-close"></i>
                    </button>
                </div>
            </div>
            <#if xhr>
                <script>
                    console.log("当前是AJAX请求");
                </script>
            </#if>
            <div class="form-group">
                <button type="submit" class="btn btn-primary btn-block">登 录</button>
            </div>
        </form>
    </div>
</div>

<script>
    // 表单提交处理
    $('#loginForm').submit(function(e) {
        e.preventDefault();
        const formData = {
            username: $('#username').val(),
            password: $('#password').val()
        };

        $.ajax({
            url: '/admin/login/post',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function(response) {
                if (response.code === 200) {
                    window.location.href = '/admin/index'; // 登录成功后跳转
                } else {
                    showMessage(response.msg || '登录失败', 'danger');
                }
            },
            error: function(xhr) {
                const msg = xhr.responseJSON?.msg || '服务器错误';
                showMessage(msg, 'danger');
            }
        });
    });


    function showMessage(msg, type) {
        new $.zui.Messager(msg, {
            type: type,
            placement: 'top'
        }).show();
    }
</script>
</body>
</html>