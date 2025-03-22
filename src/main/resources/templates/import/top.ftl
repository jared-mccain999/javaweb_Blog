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
    <script src="/js/common.js"></script>
    <title>Ryan 后台管理系统</title>
</head>
<body>
<div class="container-fluid">
    <nav class="navbar navbar-inverse navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#mainNavbar">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="/admin/index">
                    <i class="icon icon-home"></i> 首页
                </a>
            </div>

            <div class="collapse navbar-collapse" id="mainNavbar">
                <ul class="nav navbar-nav">
                    <li class="{% if request.path == '/admin/users' %}active{% endif %}">
                        <a href="/admin/users"><i class="icon icon-user"></i> 用户管理</a>
                    </li>
                    <li class="{% if request.path == '/admin/blogs' %}active{% endif %}">
                        <a href="/admin/blogs"><i class="icon icon-file-text"></i> 文章管理</a>
                    </li>
                    <li class="{% if request.path == '/admin/areas' %}active{% endif %}">
                        <a href="/admin/areas"><i class="icon icon-map-marker"></i> 区域管理</a>
                    </li>
                    <li class="{% if request.path == '/admin/announcements' %}active{% endif %}">
                        <a href="/admin/announcements"><i class="icon icon-bullhorn"></i> 公告管理</a>
                    </li>
                </ul>

                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="icon icon-user"></i> 管理员 <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu" role="menu">
                            <li><a href="#"><i class="icon icon-cog"></i> 个人设置</a></li>
                            <li class="divider"></li>
                            <li><a href="/admin/logout"><i class="icon icon-power-off"></i> 退出登录</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 主内容区 -->
    <div class="container" style="margin-top: 70px;">
        <!-- 动态内容加载区 -->
        <div id="content-container"></div>
    </div>
</div>

<script>
    // 全局token管理
    let authToken = localStorage.getItem('token');

    // 初始化AJAX全局设置
    $.ajaxSetup({
        headers: {
            'Authorization': 'Bearer ' + authToken
        },
        contentType: 'application/json',
        error: function(xhr) {
            if(xhr.status === 401) {
                new $.zui.Messager('登录已过期，请重新登录', {
                    type: 'danger',
                    placement: 'center',
                    time: 3000,
                    callback: () => window.location.href = '/login'
                }).show();
            }
        }
    });
</script>