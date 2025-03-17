<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" href="img/favicon.ico" type="image/x-icon">
    <link rel="icon" href="img/favicon.ico" type="image/x-icon">
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
            <!-- 导航头部 -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse"
                        data-target="#mainNavbar">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="/admin/index">
                    <i class="icon icon-home"></i> 首页
                </a>
            </div>

            <!-- 导航内容 -->
            <div class="collapse navbar-collapse" id="mainNavbar">
                <!-- 左侧导航 -->
                <ul class="nav navbar-nav">
                    <li class="{% if request.path == '/admin/users' %}active{% endif %}">
                        <a href="/admin/users">
                            <i class="icon icon-user"></i> 用户管理
                        </a>
                    </li>
                    <li class="{% if request.path == '/admin/blogs' %}active{% endif %}">
                        <a href="/admin/blogs">
                            <i class="icon icon-file-text"></i> 文章管理
                        </a>
                    </li>
                    <li class="{% if request.path == '/admin/blogs' %}active{% endif %}">
                        <a href="/admin/areas">
                            <i class="icon icon-map-marker"></i> 区域管理
                        </a>
                    <li class="{% if request.path == '/admin/Announcement' %}active{% endif %}">
                    <li>
                        <a href="/admin/Announcement">
                            <i class="icon icon-bullhorn"></i> 公告管理
                        </a>
                    </li>
                </ul>

                <!-- 右侧导航 -->
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="icon icon-user"></i> 管理员
                            <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu" role="menu">
                            <li><a href="#"><i class="icon icon-cog"></i> 个人设置</a></li>
                            <li class="divider"></li>
                            <li><a href="/logout"><i class="icon icon-power-off"></i> 退出登录</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</div>