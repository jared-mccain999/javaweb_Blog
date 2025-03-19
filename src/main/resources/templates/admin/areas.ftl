<#include "../import/top.ftl">

<div class="container">
    <!-- 数据表格 -->
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

<#-- 新建按钮 -->
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

<script>
    // 新增客户端验证
    function validateForm() {
        const input = document.getElementById('areaName');
        const areas = [
            <#list areasList as area>
            "${area.name?js_string}"<#sep>,
            </#list>
        ];

        if(areas.includes(input.value.trim())) {
            alert('该区域名称已存在，请使用其他名称！');
            input.focus();
            return false;
        }
        return true;
    }

    // 服务端错误提示
    <#if error??>
    alert('操作失败：${error}');
    </#if>
</script>

<!-- 编辑区域模态框（ -->
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
    // 修改点3：定义 openEditModal 函数
    function openEditModal(areaId, areaName) {
        // 填充数据到表单
        document.getElementById('editAreaId').value = areaId;
        document.getElementById('editAreaName').value = areaName;
        // 手动显示模态框
        $('#editModal').modal('show');
    }

    // 删除操作（保持原逻辑）
    $(function () {
        $('.delete-btn').click(function () {
            const areaId = $(this).data('areaid');
            if (confirm('确定要删除这个区域吗？')) {
                window.location.href = '/admin/areas/delete?id=' + areaId;
            }
        });
    });

    // 原有新建验证逻辑（保持不变）
    function validateForm() {
        const input = document.getElementById('areaName');
        const areas = [
            <#list areasList as area>
            "${area.name?js_string}"<#sep>,
            </#list>
        ];
        if(areas.includes(input.value.trim())) {
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
    /* 原有样式保持不变 */
    .float-action-btn {
        position: fixed;
        right: 30px;
        bottom: 30px;
        z-index: 1000;
        box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16);
        transition: all 0.3s;
    }
    .float-action-btn:hover {
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.24);
        transform: translateY(-2px);
    }
</style>

<#include "../import/bottom.ftl">