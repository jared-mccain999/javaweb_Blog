<#include "../import/top.ftl">

<!-- 主要内容容器 -->
<div class="main-container" style="margin-top: 70px; padding: 20px 0;">
    <div class="container">
        <!-- 面包屑导航 -->
        <ol class="breadcrumb">
            <li><i class="icon icon-map-marker"></i> 位置：</li>
            <li><a href="/admin/index">后台首页</a></li>
            <li class="active">区域管理</li>
        </ol>

        <!-- 数据表格区域 -->
        <div class="panel panel-default">
            <div class="panel-heading">
                <i class="icon icon-list"></i> 区域列表
                <div class="panel-actions">
                    <span class="badge">总数：${areasList?size}</span>
                </div>
            </div>

            <div class="panel-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead>
                        <tr>
                            <th width="10%">ID</th>
                            <th width="30%">区域名称</th>
                            <th width="30%">关联博客数量</th>
                            <th width="30%">操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <#list areasList as area>
                            <tr>
                                <td>${area.id}</td>
                                <td>${area.name}</td>
                                <td>${area.blogsCount}</td>
                                <td>
                                    <div class="btn-group">
                                        <a href="/admin/blogs?areaId=${area.id}"
                                           class="btn btn-xs btn-info"
                                           target="_blank"
                                           title="查看详情">
                                            <i class="icon icon-eye-open"></i>
                                        </a>
                                        <button class="btn btn-xs btn-warning edit-btn"
                                                onclick="openEditModal('${area.id}', '${area.name?js_string}')"
                                                title="编辑">
                                            <i class="icon icon-edit"></i>
                                        </button>
                                        <button class="btn btn-xs btn-danger delete-btn"
                                                data-areaid="${area.id}"
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
            </div>
        </div>
    </div>
</div>

<!-- 新建按钮 -->
<button class="btn btn-success btn-lg float-action-btn"
        data-toggle="modal"
        data-target="#createModal"
        title="新建区域">
    <i class="icon icon-plus"></i>
</button>

<!-- 新建区域模态框 -->
<div class="modal fade" id="createModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="/admin/areas/create" method="post" onsubmit="return validateForm()">
                <div class="modal-body">
                    <div class="form-group">
                        <label>区域名称</label>
                        <input type="text" class="form-control"
                               name="name" id="areaName" required
                               placeholder="请输入区域名称">
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

<!-- 编辑区域模态框 -->
<div class="modal fade" id="editModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title"><i class="icon icon-edit"></i> 编辑区域</h4>
            </div>
            <form action="/admin/areas/update" method="post">
                <div class="modal-body">
                    <input type="hidden" name="id" id="editAreaId">
                    <div class="form-group">
                        <label>区域名称</label>
                        <input type="text" class="form-control"
                               name="name" id="editAreaName"
                               required>
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
    function openEditModal(areaId, areaName) {
        document.getElementById('editAreaId').value = areaId;
        document.getElementById('editAreaName').value = areaName;
        $('#editModal').modal('show');
    }

    // 删除操作
    $(function () {
        $('.delete-btn').click(function () {
            const areaId = $(this).data('areaid');
            if (confirm('确定要删除这个区域吗？')) {
                window.location.href = '/admin/areas/delete?id=' + areaId;
            }
        });
    });

    // 新建验证
    function validateForm() {
        const input = document.getElementById('areaName');
        const areas = [
            <#list areasList as area>
            "${area.name?js_string}"<#sep>,
            </#list>
        ];
        if (areas.includes(input.value.trim())) {
            alert('该区域名称已存在，请使用其他名称！');
            input.focus();
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
</style>

<#include "../import/bottom.ftl">