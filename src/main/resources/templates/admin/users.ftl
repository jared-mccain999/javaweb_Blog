<#--<#include "../import/top.ftl">-->

<#--<div class="container">-->
<#--    <!-- 搜索和排序表单 &ndash;&gt;-->
<#--    <form class="form-inline" action="/admin/users" method="post">-->
<#--        <div class="form-group">-->
<#--            <input type="text" class="form-control" name="keyword"-->
<#--                   placeholder="搜索用户名或邮箱" value="${pageInfo.keyword!}">-->
<#--        </div>-->
<#--        <input type="hidden" name="page" value="1">-->
<#--        <button type="submit" class="btn btn-primary">-->
<#--            <i class="icon icon-search"></i> 搜索-->
<#--        </button>-->
<#--    </form>-->

<#--    <!-- 用户表格 &ndash;&gt;-->
<#--    <table class="table table-hover table-bordered" style="margin-top: 20px;">-->
<#--        <thead>-->
<#--        <tr>-->
<#--            <th>-->
<#--                <a href="?sort=id&keyword=${pageInfo.keyword!}">-->
<#--                    ID ${((pageInfo.sort!"id") == "id")?then("▼", "")}-->
<#--                </a>-->
<#--            </th>-->
<#--            <th>用户名</th>-->
<#--            <th>头像</th>-->
<#--            <th>邮箱</th>-->
<#--            <th>-->
<#--                <a href="?sort=blog_count&keyword=${pageInfo.keyword!}">-->
<#--                    作品数 ${((pageInfo.sort!"id") == "blog_count")?then("▼", "")}-->
<#--                </a>-->
<#--            </th>-->
<#--            <th>-->
<#--                <a href="?sort=collection_count&keyword=${pageInfo.keyword!}">-->
<#--                    收藏数 ${((pageInfo.sort!"id") == 'collection_count')?then('▼','')}-->
<#--                </a>-->
<#--            </th>-->
<#--            <th>角色</th>-->
<#--&lt;#&ndash;            <th>注册时间</th>&ndash;&gt;-->
<#--            <th>操作</th>-->
<#--        </tr>-->
<#--        </thead>-->
<#--        <tbody>-->
<#--        <#list pageInfo.list as user>-->
<#--            <tr>-->
<#--                <td>${user.id}</td>-->
<#--                <td>${user.username}</td>-->
<#--                <td><img src="${user.image!}" style="height: 30px;"></td>-->
<#--                <td>${user.email}</td>-->
<#--                <td>${user.blogCount}</td>-->
<#--                <td>${user.collectionCount}</td>-->
<#--                <td>${user.role}</td>-->
<#--&lt;#&ndash;                <td>${user.createdTime!}</td>&ndash;&gt;-->
<#--&lt;#&ndash;                <td>${user.createdTime?string('yyyy-MM-dd HH:mm:ss')}</td>&ndash;&gt;-->
<#--                <td>-->
<#--                    <a href="/admin/user/edit.ftl/${user.id}" class="btn btn-xs btn-info">查看</a>-->
<#--                </td>-->
<#--            </tr>-->
<#--        </#list>-->
<#--        </tbody>-->
<#--    </table>-->

<#--    <!-- 分页导航 &ndash;&gt;-->
<#--    <nav class="text-center">-->
<#--        <ul class="pagination">-->
<#--            <#if pageInfo.page gt 1>-->
<#--                <li>-->
<#--                    <a href="?page=${pageInfo.page-1}&pageSize=${pageInfo.pageSize}&sort=${pageInfo.sort!}&keyword=${pageInfo.keyword!}">-->
<#--                        &laquo;-->
<#--                    </a>-->
<#--                </li>-->
<#--            </#if>-->

<#--            <#list 1..pageInfo.pages as p>-->
<#--                <li class="${(p == pageInfo.page)?then('active','')}">-->
<#--                    <a href="?page=${p}&pageSize=${pageInfo.pageSize}&sort=${pageInfo.sort!}&keyword=${pageInfo.keyword!}">-->
<#--                        ${p}-->
<#--                    </a>-->
<#--                </li>-->
<#--            </#list>-->

<#--            <#if pageInfo.page lt pageInfo.pages>-->
<#--                <li>-->
<#--                    <a href="?page=${pageInfo.page+1}&pageSize=${pageInfo.pageSize}&sort=${pageInfo.sort!}&keyword=${pageInfo.keyword!}">-->
<#--                        &raquo;-->
<#--                    </a>-->
<#--                </li>-->
<#--            </#if>-->
<#--        </ul>-->
<#--    </nav>-->
<#--</div>-->

<#--<#include "../import/bottom.ftl">-->

<#include "../import/top.ftl">

<!-- 主要内容容器 -->
<div class="main-container" style="margin-top: 70px; padding: 20px 0;">
    <div class="container">
        <!-- 面包屑导航 -->
        <ol class="breadcrumb">
            <li><i class="icon icon-users"></i> 位置：</li>
            <li><a href="/admin/index">后台首页</a></li>
            <li class="active">用户管理</li>
        </ol>

        <!-- 数据表格区域 -->
        <div class="panel panel-default">
            <div class="panel-heading">
                <i class="icon icon-list"></i> 用户列表
                <div class="panel-actions">
                    <span class="badge">总数：${pageInfo.total}</span>
                </div>
            </div>

            <div class="panel-body">
                <!-- 搜索栏 -->
                <form class="form-inline" action="/admin/users" method="get">
                    <div class="input-group" style="margin-bottom: 15px;">
                        <input type="text" class="form-control"
                               name="keyword" placeholder="用户名/邮箱"
                               value="${pageInfo.keyword!}">
                        <span class="input-group-btn">
                            <button class="btn btn-default" type="submit">
                                <i class="icon icon-search"></i> 搜索
                            </button>
                        </span>
                    </div>
                    <input type="hidden" name="page" value="1">
                </form>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead>
                            <tr>
                                <th width="8%"><a href="?sort=id&keyword=${pageInfo.keyword!}">ID ${((pageInfo.sort!"id") == "id")?then('▼','')}</a></th>
                                <th width="15%">用户名</th>
                                <th width="10%">头像</th>
                                <th width="20%">邮箱</th>
                                <th width="10%"><a href="?sort=blog_count&keyword=${pageInfo.keyword!}">作品 ${((pageInfo.sort!"id") == "blog_count")?then('▼','')}</a></th>
                                <th width="10%"><a href="?sort=collection_count&keyword=${pageInfo.keyword!}">收藏 ${((pageInfo.sort!"id") == 'collection_count')?then('▼','')}</a></th>
                                <th width="10%">角色</th>
                                <th width="10%">状态</th>
                                <th width="17%">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#list pageInfo.list as user>
                                <tr>
                                    <td>${user.id}</td>
                                    <td>${user.username}</td>
                                    <td><img src="${user.image!}" class="img-thumbnail" style="width:40px;height:40px"></td>
                                    <td>${user.email}</td>
                                    <td><a href="/admin/blogs?userId=${user.id}" class="btn btn-xs btn-link">${user.blogCount}</a></td>
                                    <td>${user.collectionCount}</td>
                                    <td><span class="label ${(user.role != 'user')?then('label-danger','label-success')}">${user.role}</span></td>
                                    <td><span class="label ${(user.status == 0)?then('label-danger','label-success')}">${(user.status == 1)?then('正常' , '冻结')}</span></td>
                                    <td>
                                        <div class="btn-group">
                                            <a href="/admin/blogs?userId=${user.id}" class="btn btn-xs btn-info" title="查看文章">
                                                <i class="icon icon-eye-open"></i>
                                            </a>
                                            <button class="btn btn-xs btn-warning edit-btn"
                                                    onclick="userUpdate(
                                                        '${user.id}',
                                                        '${user.username}',
                                                        '${user.role}',
                                                        '${user.status}',
                                                        '${user.areaId}'
                                                    )"
                                                    title="编辑">
                                                <i class="icon icon-edit"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </#list>
                        </tbody>
                    </table>
                </div>

                <!-- 统计信息 -->
                <div class="text-muted" style="margin-top: 15px">
                    共显示 ${pageInfo.list?size} 位用户（总 ${pageInfo.total} 位）
                </div>

                <!-- 分页 -->
                <nav class="pull-right">
                    <ul class="pagination pagination-sm">
                        <#if pageInfo.page gt 1>
                            <li>
                                <a href="?page=${pageInfo.page-1}&pageSize=${pageInfo.pageSize}&sort=${pageInfo.sort!}&keyword=${pageInfo.keyword!}">
                                    <i class="icon icon-chevron-left"></i>
                                </a>
                            </li>
                        </#if>

                        <#list 1..pageInfo.pages as p>
                            <li class="${(p == pageInfo.page)?then('active','')}">
                                <a href="?page=${p}&pageSize=${pageInfo.pageSize}&sort=${pageInfo.sort!}&keyword=${pageInfo.keyword!}">
                                    ${p}
                                </a>
                            </li>
                        </#list>

                        <#if pageInfo.page lt pageInfo.pages>
                            <li>
                                <a href="?page=${pageInfo.page+1}&pageSize=${pageInfo.pageSize}&sort=${pageInfo.sort!}&keyword=${pageInfo.keyword!}">
                                    <i class="icon icon-chevron-right"></i>
                                </a>
                            </li>
                        </#if>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>

<!-- 编辑用户模态框 -->
<div class="modal fade" id="userUpdateModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title"><i class="icon icon-edit"></i> 修改用户信息</h4>
            </div>
            <form action="/admin/users/update" method="post">
                <div class="modal-body">
                    <input type="hidden" name="currentPage" id="currentPage">
                    <input type="hidden" name="currentSort" id="currentSort">
                    <input type="hidden" name="currentKeyword" id="currentKeyword">
                    <input type="hidden" name="id" id="id">
                    <div class="form-group">
                        <label>用户名</label>
                        <input type="text" class="form-control" disabled="disabled"
                               name="username" id="username">
                    </div>
                    <div class="form-group">
                        <label>用户密码</label>
                        <input type="password" class="form-control"
                               name="password" id="password">
                    </div>
                    <div class="form-group">
                        <label>用户角色</label>
                        <select class="form-control" name="role" id="role">
                            <option value="user">普通用户</option>
                            <option value="area_admin">区域管理员</option>
                            <option value="sys_admin">系统管理员</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>管理领域</label>
                        <input type="text" class="form-control"
                               name="area" id="area" >
                    </div>
                    <div class="form-group">
                        <label for="example">用户状态</label>
                        <label>
                            <input type="radio" name = "status" value="1" checked="checked">正常
                        </label>
                        <label>
                            <input type="radio" name = "status" value="0" >冻结
                        </label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary" onclick="userUpdateAction()">保存修改</button>
                </div>
            </form>
        </div>
    </div>
</div>


<script>
    function userUpdateAction() {

        let id = $('#id').val();
        let username = $('#username').val();
        let password = $('#password').val();
        let role = $('#role').val();
        let areaId = $('#area').val();
        let status = $('input[name="status"]:checked').val();
        // 错误操作显示
        if(!checkNotNull(id)){
            zuiMsg('程序错误，请刷新');
            return false;
        }
        if(!checkNotNull(username)){
            zuiMsg('用户名不能为空');
            return false;
        }
        $.post({
            id: id,
            username: username,
            password: password,
            role: role,
            areaId: areaId,
            status: status,
            success: function (data) {
                if(data.code == 200){
                    alert(data.message)
                    location.reload();
                    return;
                }else{
                    zuiMsg(data.message);
                }
            }
        });
    }

    function userUpdate(id, username, role, status, areaId) {

        const urlParams = new URLSearchParams(window.location.search);
        $('#currentPage').val(urlParams.get('page') || 1);
        $('#currentSort').val(urlParams.get('sort') || 'id');
        $('#currentKeyword').val(urlParams.get('keyword') || '');


        $('#userUpdateModal').modal('toggle','center')

        $('#id').val(id)
        $('#username').val(username)
        $('#role').val(role)
        $('#area').val(areaId)
        if(status == 1){
            $('input[name="status"]').eq(0).attr("checked",true);
        }else{
            $('input[name="status"]').eq(1).attr("checked",true);
        }

    }


</script>
<style>
    /* 保持与公告管理一致的样式 */
    .main-container {
        min-height: calc(100vh - 120px);
        background: #f5f5f5;
    }

    .panel {
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        border-radius: 3px;
    }

    .btn-group {
        display: flex;
        gap: 5px;
    }

    .table > thead > tr > th {
        background: #f8f9fa;
        border-bottom: 2px solid #dee2e6;
    }
</style>

<#include "../import/bottom.ftl">