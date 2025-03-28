<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" href="/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="//cdn.bootcdn.net/ajax/libs/zui/1.10.0/css/zui.min.css">
    <script src="//cdn.bootcdn.net/ajax/libs/zui/1.10.0/lib/jquery/jquery.js"></script>
    <script src="//cdn.bootcdn.net/ajax/libs/zui/1.10.0/js/zui.min.js"></script>
    <title>博客天地</title>
    <style>
        .article-card {
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .article-card:hover {
            transform: translateY(-5px);
        }
        .article-cover {
            height: 180px;
            background-size: cover;
            background-position: center;
        }
        .loading-btn .icon {
            margin-right: 5px;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <!-- 导航栏 -->
    <nav class="navbar navbar-inverse navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#mainNavbar">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="/user/index">
                    <i class="icon icon-home"></i> 博客天地
                </a>
            </div>

            <div class="collapse navbar-collapse" id="mainNavbar">
                <ul class="nav navbar-nav">
                    <li><a href="/user/hot"><i class="icon icon-fire"></i> 热门博客</a></li>
                    <li><a href="/user/area"><i class="icon icon-map-marker"></i> 区域博客</a></li>
                    <li><a href="/user/blog_edit"><i class="icon icon-edit"></i> 写博客</a></li>
                </ul>

                <!-- 右侧导航 -->
                <ul class="nav navbar-nav navbar-right" id="authNav">
                    <!-- 登录后显示 -->
                    <li class="dropdown hidden">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="icon icon-user"></i> <span id="username">用户</span> <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a href="/user/information"><i class="icon icon-vcard"></i> 个人中心</a></li>
                            <li><a href="#" data-toggle="modal" data-target="#changePasswordModal"><i class="icon icon-lock"></i> 修改密码</a></li>
                            <li class="divider"></li>
                            <li><a href="#" id="logout"><i class="icon icon-power-off"></i> 退出</a></li>
                        </ul>
                    </li>

                    <!-- 未登录显示 -->
                    <li class="visible"><a href="#" data-toggle="modal" data-target="#loginModal"><i class="icon icon-signin"></i> 登录</a></li>
                    <li class="visible"><a href="#" data-toggle="modal" data-target="#registerModal"><i class="icon icon-user-plus"></i> 注册</a></li>
                </ul>
            </div>
        </div>
    </nav>
</div>

<!-- 登录模态框 -->
<div class="modal fade" id="loginModal">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>×</span></button>
                <h4 class="modal-title"><i class="icon icon-signin"></i> 用户登录</h4>
            </div>
            <form id="loginForm">
                <div class="modal-body">
                    <div class="form-group">
                        <input type="text" class="form-control" placeholder="用户名" name="username" required>
                    </div>
                    <div class="form-group">
                        <input type="password" class="form-control" placeholder="密码" name="password" required>
                    </div>
                    <div class="alert alert-danger hide" id="loginError"></div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary btn-block loading-btn" id="loginBtn">
                        <span class="btn-text">登录</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 注册模态框 -->
<div class="modal fade" id="registerModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>×</span></button>
                <h4 class="modal-title"><i class="icon icon-user-plus"></i> 新用户注册</h4>
            </div>
            <form id="registerForm">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <input type="text" class="form-control" placeholder="用户名" name="username" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <input type="email" class="form-control" placeholder="邮箱" name="email" required>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <input type="password" class="form-control" placeholder="密码" name="password" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <input type="password" class="form-control" placeholder="确认密码" name="confirmPassword" required>
                            </div>
                        </div>
                    </div>
                    <div class="alert alert-danger hide" id="registerError"></div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success btn-block loading-btn" id="registerBtn">
                        <span class="btn-text">立即注册</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // 用户状态管理
    function updateAuthUI(isLogin) {
        // 确保DOM元素已经加载
        if ($('#authNav').length === 0) {
            setTimeout(() => updateAuthUI(isLogin), 100);
            return;
        }

        $('#authNav .dropdown').toggleClass('hidden', !isLogin);
        $('#authNav li.visible').toggleClass('hidden', isLogin);

        if (isLogin) {
            // 获取用户名
            $.get('/user/information').then(res => {
                $('#username').text(res.username || '用户');
            }).catch(() => {
                $('#username').text('用户');
            });
        }
    }

    // 初始化检查登录状态
    function checkAuthStatus() {
        $.ajax({
            url: '/user/checkToken',
            method: 'GET',
            success: function(response) {
                updateAuthUI(response.code === 200);
            },
            error: function() {
                updateAuthUI(false);
            }
        });
    }

    // 全局AJAX设置
    $.ajaxSetup({
        statusCode: {
            401: handleUnauthorized,
            403: handleUnauthorized
        }
    });

    // 登录表单处理
    $('#loginForm').submit(function(e) {
        e.preventDefault();
        const $form = $(this);
        const $btn = $('#loginBtn');
        const $btnText = $btn.find('.btn-text');

        $btn.prop('disabled', true);
        $btnText.html('<i class="icon icon-spinner icon-spin"></i> 登录中...');

        const formData = $form.serializeObject();

        $.post('/user/login', formData)
            .done(res => {
                if (res.code === 200) {
                    updateAuthUI(true);
                    $('#loginModal').modal('hide');
                    new $.zui.Messager('登录成功', {type: 'success'}).show();
                    $form[0].reset();
                    $('#loginError').addClass('hide');
                    setTimeout(() => location.reload(), 1000);
                } else {
                    showLoginError({responseJSON: res});
                }
            })
            .fail(showLoginError)
            .always(() => {
                $btn.prop('disabled', false);
                $btnText.text('登录');
            });
    });

    // 注册表单处理
    $('#registerForm').submit(function(e) {
        e.preventDefault();
        const $form = $(this);
        const $btn = $('#registerBtn');
        const $btnText = $btn.find('.btn-text');

        $btn.prop('disabled', true);
        $btnText.html('<i class="icon icon-spinner icon-spin"></i> 注册中...');

        const formData = $form.serializeObject();

        if(formData.password !== formData.confirmPassword) {
            showRegisterError('两次密码输入不一致');
            $btn.prop('disabled', false);
            $btnText.text('立即注册');
            return;
        }

        $.post('/user/register', formData)
            .done(res => {
                if (res.code === 200) {
                    new $.zui.Messager('注册成功，请登录', {type: 'success'}).show();
                    $('#registerModal').modal('hide');
                    $form[0].reset();
                    $('#registerError').addClass('hide');
                } else {
                    showRegisterError({responseJSON: res});
                }
            })
            .fail(showRegisterError)
            .always(() => {
                $btn.prop('disabled', false);
                $btnText.text('立即注册');
            });
    });

    // 退出登录
    $('#logout').click((e) => {
        e.preventDefault();
        $.post('/user/logout')
            .always(() => {
                updateAuthUI(false);
                new $.zui.Messager('已退出登录', {type: 'info'}).show();
                setTimeout(() => location.reload(), 500);
            });
    });

    // 未授权处理
    function handleUnauthorized() {
        updateAuthUI(false);
        new $.zui.Messager('会话已过期，请重新登录', {type: 'danger'}).show();
    }

    // 错误提示函数
    function showLoginError(xhr) {
        const error = xhr.responseJSON || {message: '登录失败'};
        $('#loginError').text(error.message || '登录失败').removeClass('hide');
    }

    function showRegisterError(xhr) {
        let msg = '注册失败';
        if (typeof xhr === 'string') {
            msg = xhr;
        } else if (xhr.responseJSON) {
            msg = xhr.responseJSON.message || msg;
        }
        $('#registerError').text(msg).removeClass('hide');
    }

    // 工具函数：表单转对象
    $.fn.serializeObject = function() {
        const arr = this.serializeArray();
        return arr.reduce((obj, item) => {
            obj[item.name] = item.value;
            return obj;
        }, {});
    };

    // 页面加载时检查登录状态
    $(document).ready(function() {
        checkAuthStatus();

        $(document).ajaxError(function(event, xhr) {
            if (xhr.status === 401 || xhr.status === 403) {
                handleUnauthorized();
            }
        });
    });

    // 添加页面显示时的状态检查
    $(window).on('pageshow', checkAuthStatus);
</script>
</body>
</html>