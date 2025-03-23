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
                            <li><a href="/admin/login"><i class="icon icon-power-off"></i> 退出登录</a></li>
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
                    callback: () => window.location.href = '/login.ftl'
                }).show();
            }
        }
    });
</script>


<!-- 修改密码模态框 -->
<div class="modal fade" id="changePasswordModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span></button>
                <h4 class="modal-title"><i class="icon icon-lock"></i> 修改密码</h4>
            </div>
            <form id="passwordForm">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="oldPassword">原密码</label>
                        <input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
                    </div>
                    <div class="form-group">
                        <label for="newPassword">新密码</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" minlength="6" required>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">确认新密码</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    </div>
                    <div id="errorMsg" class="text-danger hide"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">提交修改</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    $(function() {
        // 绑定个人设置点击事件
        $('.dropdown-menu a[href="#"]').click(function(e) {
            e.preventDefault();
            $('#changePasswordModal').modal('show');
        });

        // 表单验证
        $('#passwordForm').submit(function(e) {
            e.preventDefault();

            const oldPwd = $('#oldPassword').val();
            const newPwd = $('#newPassword').val();
            const confirmPwd = $('#confirmPassword').val();
            const $errorMsg = $('#errorMsg');
            const $submitBtn = $(this).find('button[type="submit"]');

            // 清空错误提示
            $errorMsg.addClass('hide').text('');

            // 前端验证
            if (!oldPwd) {
                showError('请输入原密码');
                return;
            }
            if (newPwd.length < 6) {
                showError('新密码至少6位');
                return;
            }
            if (newPwd !== confirmPwd) {
                showError('两次输入的新密码不一致');
                return;
            }

            // 禁用按钮防止重复提交
            $submitBtn.prop('disabled', true).html('<i class="icon icon-spinner icon-spin"></i> 提交中...');

            // 发送请求
            $.ajax({
                url: '/api/admin/change-password',
                method: 'PUT',
                data: JSON.stringify({
                    oldPassword: oldPwd,
                    newPassword: newPwd
                }),
                success: function() {
                    new $.zui.Messager('密码修改成功，请重新登录', {
                        type: 'success',
                        placement: 'center',
                        time: 2000,
                        callback: () => {
                            $('#changePasswordModal').modal('hide');
                            // 清除token并跳转登录
                            localStorage.removeItem('token');
                            window.location.href = '/admin/login.ftl';
                        }
                    }).show();
                },
                error: function(xhr) {
                    const error = xhr.responseJSON || {};
                    showError(error.message || '密码修改失败，请检查原密码是否正确');
                },
                complete: function() {
                    $submitBtn.prop('disabled', false).text('提交修改');
                }
            });
        });

        // 显示错误信息
        function showError(msg) {
            $('#errorMsg').removeClass('hide').text(msg);
        }

        // 模态框关闭时重置表单
        $('#changePasswordModal').on('hidden.zui.modal', function() {
            $('#passwordForm')[0].reset();
            $('#errorMsg').addClass('hide').text('');
        });
    });
</script>