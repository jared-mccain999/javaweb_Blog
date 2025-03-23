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
    <title>用户登录 - 我的应用</title>
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
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
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
    <div class="login-container">
        <div class="login-header text-center">
            <h2><i class="icon icon-user"></i> 用户登录</h2>
            <p class="text-muted">欢迎回来，请登录您的账号</p>
        </div>
        <form id="userLoginForm">
            <div class="form-group">
                <label>用户名/邮箱</label>
                <input type="text"
                       class="form-control"
                       id="loginName"
                       name="loginName"
                       placeholder="请输入用户名或邮箱"
                       required>
                <div class="invalid-feedback" id="loginName-error" style="display: none;"></div>
            </div>
            <div class="form-group">
                <label>密码</label>
                <div class="password-wrapper">
                    <input type="password"
                           class="form-control"
                           id="userPassword"
                           name="password"
                           placeholder="请输入密码"
                           required
                           minlength="6"
                           maxlength="40">
                    <button type="button"
                            class="password-toggle"
                            onclick="toggleUserPassword()">
                        <i class="icon icon-eye-close"></i>
                    </button>
                </div>
                <div class="invalid-feedback" id="password-error" style="display: none;"></div>
            </div>
            <div class="form-group">
                <button type="submit" class="btn btn-primary btn-block">立即登录</button>
            </div>
            <div class="extra-links">
                <a href="/user/register" class="text-muted">立即注册</a> ·
                <a href="/forgot-password" class="text-muted">忘记密码？</a>
            </div>
        </form>
    </div>
</div>
<script>
    // 表单验证增强
    function validateUserForm() {
        let isValid = true;
        const loginName = $('#loginName').val().trim();
        const password = $('#userPassword').val().trim();

        $('.form-control').removeClass('is-invalid');
        $('.invalid-feedback').hide();

        if (!loginName) {
            $('#loginName').addClass('is-invalid');
            $('#loginName-error').text('登录名不能为空').show();
            isValid = false;
        }

        if (!password) {
            $('#userPassword').addClass('is-invalid');
            $('#password-error').text('密码不能为空').show();
            isValid = false;
        } else if (password.length < 6) {
            $('#userPassword').addClass('is-invalid');
            $('#password-error').text('密码至少需要6位').show();
            isValid = false;
        }

        return isValid;
    }

    // 表单提交处理
    $('#userLoginForm').submit(function(e) {
        e.preventDefault();
        const $btn = $(this).find('button[type="submit"]');
        $btn.prop('disabled', true).html('<i class="icon icon-spin icon-spinner"></i> 登录中...');

        if (!validateUserForm()) {
            $btn.prop('disabled', false).html('立即登录');
            return;
        }

        $.ajax({
            url: '/user/login/post',
            type: 'POST',
            data: $(this).serialize(),
            success: function(response) {
                if (response.code === 200) {
                    localStorage.setItem('userToken', response.data.token);
                    window.location.href = '/user/dashboard';
                } else {
                    handleUserError(response);
                }
            },
            error: function(xhr) {
                handleNetworkError(xhr);
            },
            complete: function() {
                $btn.prop('disabled', false).html('立即登录');
            }
        });
    });

    // 错误处理
    function handleUserError(response) {
        const errorMap = {
            400: { field: 'loginName', msg: '无效的登录凭证' },
            401: { field: 'userPassword', msg: '密码错误' },
            404: { field: 'loginName', msg: '用户不存在' }
        };

        if (errorMap[response.code]) {
            const { field, msg } = errorMap[response.code];
            $('#' + field).addClass('is-invalid');
            $('#' + field + '-error').text(msg).show();
        }
        showMessage(response.msg || '登录失败', 'danger');
    }

    // 通用网络错误处理
    function handleNetworkError(xhr) {
        const errorMsg = xhr.status === 0
            ? '网络连接异常，请检查网络'
            : `服务器错误`;
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

    // 密码可见切换
    function toggleUserPassword() {
        const $password = $('#userPassword');
        const $toggle = $('.password-toggle i');
        $password.attr('type',
            $password.attr('type') === 'password' ? 'text' : 'password'
        );
        $toggle.toggleClass('icon-eye-open icon-eye-close');
    }
</script>
</body>
</html>