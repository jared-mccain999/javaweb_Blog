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
                <a class="navbar-brand" href="/">
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
                            <li><a href="/profile"><i class="icon icon-vcard"></i> 个人中心</a></li>
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
                    <button type="submit" class="btn btn-primary btn-block">登录</button>
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
                    <button type="submit" class="btn btn-success btn-block">立即注册</button>
                </div>
            </form>
        </div>
    </div>
</div>



<script>
    // 用户状态管理
    const authToken = localStorage.getItem('token');
    updateAuthUI(!!authToken);

    // 登录表单处理
    $('#loginForm').submit(function(e) {
        e.preventDefault();
        const formData = $(this).serializeObject();

        $.post('/user/login', formData)
            .done(res => {
                localStorage.setItem('token', res.token);
                updateAuthUI(true);
                $('#loginModal').modal('hide');
            })
            .fail(showLoginError);
    });

    // 注册表单处理
    $('#registerForm').submit(function(e) {
        e.preventDefault();
        const formData = $(this).serializeObject();

        if(formData.password !== formData.confirmPassword) {
            return showRegisterError('两次密码输入不一致');
        }

        $.post('/user/register', formData)
            .done(() => {
                new $.zui.Messager('注册成功，请登录', {type: 'success'}).show();
                $('#registerModal').modal('hide');
            })
            .fail(showRegisterError);
    });

    // 退出登录
    $('#logout').click(() => {
        localStorage.removeItem('token');
        updateAuthUI(false);
    });

    // 更新界面状态
    function updateAuthUI(isLogin) {
        $('#authNav .dropdown').toggleClass('hidden', !isLogin);
        $('#authNav li.visible').toggleClass('hidden', isLogin);
    }

    // 错误提示函数
    function showLoginError(xhr) {
        const error = xhr.responseJSON || {};
        $('#loginError').text(error.message || '登录失败').removeClass('hide');
    }

    function showRegisterError(xhr) {
        const msg = typeof xhr === 'string' ? xhr : (xhr.responseJSON?.message || '注册失败');
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
</script>
