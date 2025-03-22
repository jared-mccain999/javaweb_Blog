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
            box-shadow: 0 4px 20px rgba(0, 0, 0, .1);
            animation: fadeIn 0.6s;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .password-wrapper {
            position: relative;
        }

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
    // 页面加载时检查Token
    // $(document).ready(function() {
    //     const token = localStorage.getItem('token');
    //     if (token) {
    //         window.location.href = '/admin/index';
    //     }
    // });

    // 增强表单验证函数
    function validateForm() {
        let isValid = true;
        const username = $('#username').val().trim();
        const password = $('#password').val().trim();

        // 清除旧错误状态
        $('.form-control').removeClass('is-invalid');
        $('.invalid-feedback').hide();

        if (!username) {
            $('#username').addClass('is-invalid');
            $('#username-error').text('用户名不能为空').show();
            isValid = false;
        }

        if (!password) {
            $('#password').addClass('is-invalid');
            $('#password-error').text('密码不能为空').show();
            isValid = false;
        } else if (password.length < 4 || password.length > 40) {
            $('#password').addClass('is-invalid');
            $('#password-error').text('密码长度需在4-40位之间').show();
            isValid = false;
        }

        return isValid;
    }

    // 表单提交处理
    $('#loginForm').submit(function (e) {
        e.preventDefault();
        const $btn = $(this).find('button[type="submit"]');
        $btn.prop('disabled', true).html('<i class="icon icon-spin icon-spinner"></i> 登录中...');

        if (!validateForm()) {
            $btn.prop('disabled', false).html('登 录');
            return;
        }

        const formData = {
            username: $('#username').val().trim(),
            password: $('#password').val().trim()
        };

        $.ajax({
            url: '/admin/login/post',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function (response) {
                console.log('Full Response:', response); // 查看完整响应结构
                console.log('Token:', response.data.token); // 确认token存在
                localStorage.setItem('token', response.data.token);
                if (response.code === 200) {
                    // 保存Token到localStorage
                    localStorage.setItem('token', response.data.token);

                    // 设置全局AJAX头
                    $.ajaxSetup({
                        headers: {
                            'Authorization': 'Bearer ' + response.data.token
                        }
                    });

                    window.location.href = '/admin/index';
                } else {
                    handleError(response);
                }
            },
            error: function(xhr) {
                handleNetworkError(xhr);
            },
            complete: function() {
                $btn.prop('disabled', false).html('登 录');
            }
        });
    });

    // 错误处理函数
    function handleError(response) {
        let errorMsg = response.msg || '登录失败';
        const fields = {
            400: { field: 'username', msg: '请求参数错误' },
            401: { field: 'password', msg: '密码错误' },
            404: { field: 'username', msg: '用户不存在' }
        };

        if (fields[response.code]) {
            const { field, msg } = fields[response.code];
            $('#' + field).addClass('is-invalid');
            $('#' + field + '-error').text(msg).show();
            errorMsg = msg;
        }

        showMessage(errorMsg, 'danger');
    }

    // 网络错误处理
    function handleNetworkError(xhr) {
        const errorMsg = xhr.status === 0
            ? '无法连接服务器，请检查网络'
            : (xhr.status >= 500 ? '服务器内部错误' : '未知网络错误');
        showMessage(errorMsg, 'danger');
    }

    // 显示消息
    function showMessage(msg, type) {
        new $.zui.Messager(msg, {
            type: type,
            placement: 'top',
            time: 3000
        }).show();
    }

    // 密码可见切换
    function togglePassword() {
        const $password = $('#password');
        const $toggle = $('.password-toggle i');
        const isPassword = $password.attr('type') === 'password';

        $password.attr('type', isPassword ? 'text' : 'password');
        $toggle.toggleClass('icon-eye-open icon-eye-close');
    }

    // 全局处理401未授权
    $(document).ajaxComplete(function(event, xhr) {
        if (xhr.status === 401) {
            localStorage.removeItem('token');
            window.location.href = '/admin/login';
        }
    });
</script>
</body>
</html>