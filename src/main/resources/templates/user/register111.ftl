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
    <title>用户注册 - 我的应用</title>
    <style>
        .register-container {
            max-width: 560px;
            margin: 60px auto;
            padding: 40px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, .1);
            animation: fadeIn 0.6s;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .password-rules {
            font-size: 13px;
            color: #666;
            margin-top: 5px;
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

        .extra-links {
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="register-container">
        <div class="register-header text-center">
            <h2><i class="icon icon-user-plus"></i> 用户注册</h2>
            <p class="text-muted">创建您的专属账号</p>
        </div>
        <form id="registerForm">
            <div class="form-group">
                <label>用户名</label>
                <input type="text"
                       class="form-control"
                       id="username"
                       name="username"
                       placeholder="请输入用户名（4-16位字母数字）"
                       required
                       minlength="4"
                       maxlength="16"
                       pattern="[a-zA-Z0-9]+">
                <div class="invalid-feedback" id="username-error" style="display: none;"></div>
            </div>

            <div class="form-group">
                <label>电子邮箱</label>
                <input type="email"
                       class="form-control"
                       id="email"
                       name="email"
                       placeholder="请输入有效邮箱"
                       required>
                <div class="invalid-feedback" id="email-error" style="display: none;"></div>
            </div>

            <div class="form-group">
                <label>设置密码</label>
                <div class="password-wrapper">
                    <input type="password"
                           class="form-control"
                           id="password"
                           name="password"
                           placeholder="至少6位，包含字母和数字"
                           required
                           minlength="6"
                           pattern="^(?=.*[A-Za-z])(?=.*\d).+$">
                    <button type="button"
                            class="password-toggle"
                            onclick="togglePassword('password')">
                        <i class="icon icon-eye-close"></i>
                    </button>
                </div>
                <div class="password-rules">至少包含：6个字符，字母和数字组合</div>
                <div class="invalid-feedback" id="password-error" style="display: none;"></div>
            </div>

            <div class="form-group">
                <label>确认密码</label>
                <div class="password-wrapper">
                    <input type="password"
                           class="form-control"
                           id="confirmPassword"
                           placeholder="请再次输入密码"
                           required>
                    <button type="button"
                            class="password-toggle"
                            onclick="togglePassword('confirmPassword')">
                        <i class="icon icon-eye-close"></i>
                    </button>
                </div>
                <div class="invalid-feedback" id="confirmPassword-error" style="display: none;"></div>
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-primary btn-block">立即注册</button>
            </div>
            <div class="extra-links">
                已有账号？<a href="/login" class="text-primary">立即登录</a>
            </div>
        </form>
    </div>
</div>
<script>
    // 密码可见切换
    function togglePassword(fieldId) {
        const $field = $('#' + fieldId);
        const $toggle = $field.siblings('.password-toggle').find('i');
        $field.attr('type', $field.attr('type') === 'password' ? 'text' : 'password');
        $toggle.toggleClass('icon-eye-open icon-eye-close');
    }

    // 实时表单验证
    function validateForm() {
        let isValid = true;
        const username = $('#username').val().trim();
        const email = $('#email').val().trim();
        const password = $('#password').val();
        const confirmPassword = $('#confirmPassword').val();

        // 清除旧错误状态
        $('.form-control').removeClass('is-invalid');
        $('.invalid-feedback').hide();

        // 用户名验证
        if (!username) {
            showError('username', '用户名不能为空');
            isValid = false;
        } else if (!/^[a-zA-Z0-9]{4,16}$/.test(username)) {
            showError('username', '用户名需4-16位字母数字');
            isValid = false;
        }

        // 邮箱验证
        if (!email) {
            showError('email', '邮箱不能为空');
            isValid = false;
        } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            showError('email', '邮箱格式不正确');
            isValid = false;
        }

        // 密码验证
        if (!password) {
            showError('password', '密码不能为空');
            isValid = false;
        } else if (password.length < 6) {
            showError('password', '密码至少需要6位');
            isValid = false;
        } else if (!/(?=.*[a-zA-Z])(?=.*\d)/.test(password)) {
            showError('password', '需包含字母和数字');
            isValid = false;
        }

        // 确认密码验证
        if (password !== confirmPassword) {
            showError('confirmPassword', '两次输入的密码不一致');
            isValid = false;
        }

        return isValid;
    }

    function showError(fieldId, message) {
        $(`#${fieldId}`).addClass('is-invalid');
        $(`#${fieldId}-error`).text(message).show();
    }

    // 表单提交处理
    $('#registerForm').submit(function(e) {
        e.preventDefault();
        const $btn = $(this).find('button[type="submit"]');
        $btn.prop('disabled', true).html('<i class="icon icon-spin icon-spinner"></i> 注册中...');

        if (!validateForm()) {
            $btn.prop('disabled', false).html('立即注册');
            return;
        }

        const formData = {
            username: $('#username').val().trim(),
            email: $('#email').val().trim(),
            password: $('#password').val()
        };

        $.ajax({
            url: '/user/register/post',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function(response) {
                if (response.code === 200) {
                    showMessage('注册成功！正在跳转登录...', 'success');
                    setTimeout(() => {
                        window.location.href = '/login';
                    }, 1500);
                } else {
                    handleError(response);
                }
            },
            error: function(xhr) {
                handleNetworkError(xhr);
            },
            complete: function() {
                $btn.prop('disabled', false).html('立即注册');
            }
        });
    });

    // 错误处理
    function handleError(response) {
        const errorMap = {
            400: { field: 'email', msg: '邮箱格式不正确' },
            409: { field: 'email', msg: '该邮箱已被注册' },
            410: { field: 'username', msg: '用户名已存在' }
        };

        if (errorMap[response.code]) {
            const { field, msg } = errorMap[response.code];
            showError(field, msg);
        } else {
            showMessage(response.msg || '注册失败', 'danger');
        }
    }

    // 网络错误处理
    function handleNetworkError(xhr) {
        const errorMsg = xhr.status === 0
            ? '网络连接异常，请检查网络'
            : `服务器错误（${xhr.status}）`;
        showMessage(errorMsg, 'danger');
    }

    // 显示提示信息
    function showMessage(msg, type) {
        new $.zui.Messager(msg, {
            type: type,
            placement: 'top',
            time: 3000
        }).show();
    }
</script>
</body>
</html>