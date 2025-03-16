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
<#--                    <a href="/admin/user/edit/${user.id}" class="btn btn-xs btn-info">查看</a>-->
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

<div class="container">
    <div class="panel panel-default">
        <!-- 面板头部 -->
        <div class="panel-heading">
            <div class="row">
                <div class="col-md-6">
                    <h4 class="panel-title"><i class="icon icon-users"></i> 用户管理</h4>
                </div>
                <div class="col-md-6 text-right">
                    <span class="text-muted">共 ${pageInfo.total} 位用户</span>
                </div>
            </div>
        </div>

        <!-- 搜索栏 -->
        <div class="panel-body">
            <form class="form-inline" action="/admin/users" method="get">
                <div class="input-group">
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
        </div>

        <!-- 数据表格 -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead>
                <tr>
                    <th width="8%">
                        <a href="?sort=id&keyword=${pageInfo.keyword!}">
                            ID ${((pageInfo.sort!"id") == "id")?then('▼','')}
                        </a>
                    </th>
                    <th width="15%">用户名</th>
                    <th width="10%">头像</th>
                    <th width="20%">邮箱</th>
                    <th width="10%">
                        <a href="?sort=blog_count&keyword=${pageInfo.keyword!}">
                            作品 ${((pageInfo.sort!"id") == "blog_count")?then('▼','')}
                        </a>
                    </th>
                    <th width="10%">
                        <a href="?sort=collection_count&keyword=${pageInfo.keyword!}">
                            收藏 ${((pageInfo.sort!"id") == 'collection_count')?then('▼','')}
                        </a>
                    </th>
                    <th width="10%">角色</th>
                    <th width="17%">操作</th>
                </tr>
                </thead>
                <tbody>
                <#list pageInfo.list as user>
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.username}</td>
                        <td>
                            <img src="${user.image!}"
                                 class="img-thumbnail"
                                 style="width:40px;height:40px">
                        </td>
                        <td>${user.email}</td>
                        <td>
                            <a href="/admin/blogs?userId=${user.id}"
                               class="btn btn-xs btn-link">
                                ${user.blogCount}
                            </a>
                        </td>
                        <td>${user.collectionCount}</td>
                        <td>
                            <span class="label ${(user.role == 'admin')?then('label-danger','label-success')}">
                                ${user.role}
                            </span>
                        </td>
                        <td>
                            <div class="btn-group">
                                <a href="/admin/blogs?userId=${user.id}"
                                   class="btn btn-xs btn-info"
                                   title="查看文章">
                                    <i class="icon icon-eye-open"></i>
                                </a>
                                <button class="btn btn-xs btn-warning edit-btn"
                                        data-toggle="modal"
                                        data-target="#editModal"
                                        data-userid="${user.id}"
                                        data-username="${user.username}"
                                        data-email="${user.email}"
                                        data-role="${user.role}">
                                    <i class="icon icon-edit"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                </#list>
                </tbody>
            </table>
        </div>

        <!-- 分页 -->
        <div class="panel-footer">
            <div class="row">
                <div class="col-md-4">
                    <p class="text-muted small" style="margin:7px 0">
                        每页 ${pageInfo.pageSize} 条，共 ${pageInfo.total} 条
                    </p>
                </div>
                <div class="col-md-8">
                    <nav class="pull-right">
                        <ul class="pagination pagination-sm" style="margin:0">
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
</div>

<!-- 编辑用户模态框 -->
<div class="modal fade" id="editModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title"><i class="icon icon-edit"></i> 修改用户信息</h4>
            </div>
            <form action="/admin/user/update" method="post">
                <div class="modal-body">
                    <input type="hidden" name="id" id="editUserId">
                    <div class="form-group">
                        <label>用户名</label>
                        <input type="text" class="form-control"
                               name="username" id="editUsername" required>
                    </div>
                    <div class="form-group">
                        <label>电子邮箱</label>
                        <input type="email" class="form-control"
                               name="email" id="editEmail" required>
                    </div>
                    <div class="form-group">
                        <label>用户角色</label>
                        <select class="form-control" name="role" id="editRole">
                            <option value="user">普通用户</option>
                            <option value="admin">管理员</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">保存修改</button>
                </div>
            </form>
        </div>
    </div>
</div>

<#include "../import/bottom.ftl">

<script>
    // 模态框数据绑定
    $(function(){
        $('#editModal').on('show.bs.modal', function(event) {
            const button = $(event.relatedTarget);
            const modal = $(this);

            modal.find('#editUserId').val(button.data('userid'));
            modal.find('#editUsername').val(button.data('username'));
            modal.find('#editEmail').val(button.data('email'));
            modal.find('#editRole').val(button.data('role'));
        });
    });
</script>