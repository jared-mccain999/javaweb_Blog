<#include "../import/top.ftl">

<!-- 主要内容容器 -->
<div class="main-container" style="margin-top: 70px; padding: 20px 0;">
    <div class="container">
        <!-- 面包屑导航 -->
        <ol class="breadcrumb">
            <li><i class="icon icon-bullhorn"></i> 位置：</li>
            <li><a href="/admin/index">后台首页</a></li>
            <li class="active">公告管理</li>
        </ol>

        <!-- 数据表格区域 -->
        <div class="panel panel-default">
            <div class="panel-heading">
                <i class="icon icon-list"></i> 公告列表
                <div class="panel-actions">
                    <span class="badge">总数：${pageInfo.total}</span>
                </div>
            </div>

            <div class="panel-body">
                <!-- 搜索栏 -->
                <form class="form-inline" action="/admin/announcements" method="get">
                    <div class="input-group" style="margin-bottom: 15px;">
                        <input type="text" class="form-control"
                               name="keyword" placeholder="输入公告标题/内容"
                               value="${pageInfo.keyword!}">
                        <span class="input-group-btn">
                            <button class="btn btn-default" type="submit">
                                <i class="icon icon-search"></i> 搜索
                            </button>
                        </span>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead>
                            <tr>
                                <th width="10%">ID</th>
                                <th width="20%">标题</th>
                                <th width="30%">内容摘要</th>
                                <th width="15%">发布日期</th>
                                <th width="15%">结束日期</th>
                                <th width="10%">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#list pageInfo.list as announcement>
                                <tr>
                                    <td>${announcement.id}</td>
                                    <td>${announcement.title}</td>
                                    <td>
                                        <#if announcement.content??>
                                            ${announcement.content?substring(0, [20, announcement.content?length]?min)}
                                            <#if (announcement.content?length > 20)>...</#if>
                                        <#else>
                                            （无内容）
                                        </#if>
                                    </td>
                                    <td>${(announcement.publishTime?string('yyyy-MM-dd HH:mm:ss'))!}</td>
                                    <td>${(announcement.cancelTime?string('yyyy-MM-dd HH:mm:ss'))!}</td>
                                    <td>
                                        <div class="btn-group">
                                            <button class="btn btn-xs btn-warning edit-btn"
                                                    onclick="openEditModal(
                                                        '${announcement.id}',
                                                        '${announcement.title?js_string}',
                                                        '${announcement.content?js_string}'
                                                    )"
                                                    title="编辑">
                                                <i class="icon icon-edit"></i>
                                            </button>
                                            <button class="btn btn-xs btn-danger delete-btn"
                                                    data-id="${announcement.id}"
                                                    title="删除">
                                                <i class="icon icon-trash"></i>
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
                    共显示 ${pageInfo.list?size} 条公告（总 ${pageInfo.total} 条）
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 新建按钮 -->
<button class="btn btn-success btn-lg float-action-btn"
        data-toggle="modal"
        data-target="#createModal"
        title="新建公告">
    <i class="icon icon-plus"></i>
</button>

<!-- 新建公告模态框 -->
<div class="modal fade" id="createModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="/admin/announcements/create" method="post" onsubmit="return validateCreateForm()">
                <div class="modal-body">
                    <div class="form-group">
                        <label>公告标题</label>
                        <input type="text" class="form-control"
                               name="title" id="createTitle" required
                               placeholder="请输入公告标题（2-50个字符）">
                    </div>
                    <div class="form-group">
                        <label>公告内容</label>
                        <textarea class="form-control" rows="5"
                                  name="content" id="createContent" required
                                  placeholder="请输入公告内容（至少10个字符）"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">创建</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 编辑公告模态框 -->
<div class="modal fade" id="editModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title"><i class="icon icon-edit"></i> 编辑公告</h4>
            </div>
            <form action="/admin/announcements/update" method="post">
                <div class="modal-body">
                    <input type="hidden" name="id" id="editId">
                    <div class="form-group">
                        <label>公告标题</label>
                        <input type="text" class="form-control"
                               name="title" id="editTitle" required>
                    </div>
                    <div class="form-group">
                        <label>公告内容</label>
                        <textarea class="form-control" rows="5"
                                  name="content" id="editContent" required></textarea>
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

<script>
    // 打开编辑模态框
    function openEditModal(id, title, content) {
        document.getElementById('editId').value = id;
        document.getElementById('editTitle').value = title;
        document.getElementById('editContent').value = content;
        $('#editModal').modal('show');
    }

    // 删除操作
    $(function () {
        $('.delete-btn').click(function () {
            const id = $(this).data('id');
            if (confirm('确定要删除这条公告吗？删除后不可恢复！')) {
                window.location.href = '/admin/announcements/delete?id=' + id;
            }
        });
    });

    // 新建表单验证
    function validateCreateForm() {
        const titleInput = document.getElementById('createTitle');
        const contentInput = document.getElementById('createContent');

        if (titleInput.value.trim().length < 2) {
            alert('标题至少需要2个字符！');
            titleInput.focus();
            return false;
        }

        if (titleInput.value.trim().length > 50) {
            alert('标题不能超过50个字符！');
            titleInput.focus();
            return false;
        }

        if (contentInput.value.trim().length < 10) {
            alert('内容至少需要10个字符！');
            contentInput.focus();
            return false;
        }

        return true;
    }

    <#if error??>
    alert('操作失败：${error}');
    </#if>
</script>

<style>
    /* 主要内容容器 */
    .main-container {
        min-height: calc(100vh - 120px);
        background: #f5f5f5;
    }

    /* 面板样式 */
    .panel {
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        border-radius: 3px;
    }

    .panel-heading {
        background: linear-gradient(to bottom, #f8f9fa, #e9ecef);
        border-bottom: 1px solid #dee2e6;
        padding: 12px 15px;
    }

    /* 表格样式 */
    .table {
        margin-bottom: 0;
        background: white;
    }

    .table > thead > tr > th {
        background: #f8f9fa;
        border-bottom: 2px solid #dee2e6;
    }

    /* 操作按钮 */
    .btn-group {
        display: flex;
        gap: 5px;
    }

    /* 浮动按钮 */
    .float-action-btn {
        position: fixed;
        right: 40px;
        bottom: 40px;
        z-index: 1001;
        box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16);
        transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
    }

    .float-action-btn:hover {
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.24);
        transform: translateY(-2px);
    }

    textarea {
        resize: vertical;
        min-height: 120px;
    }
</style>

<#include "../import/bottom.ftl">