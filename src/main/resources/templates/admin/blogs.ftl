<#include "../import/top.ftl">

<!-- 主要内容容器 -->
<div class="main-container" style="margin-top: 70px; padding: 20px 0;">
    <div class="container">
        <!-- 面包屑导航 -->
        <ol class="breadcrumb">
            <li><i class="icon icon-file-text"></i> 位置：</li>
            <li><a href="/admin/index">后台首页</a></li>
            <li class="active">博客管理</li>
        </ol>

        <!-- 数据表格区域 -->
        <div class="panel panel-default">
            <div class="panel-heading">
                <i class="icon icon-list"></i> 博客列表
                <div class="panel-actions">
                    <span class="badge">总数：${pageInfo.total}</span>
                </div>
            </div>

            <div class="panel-body">
                <!-- 搜索栏 -->
                <form class="form-inline" action="/admin/blogs" method="get">
                    <div class="input-group" style="margin-bottom: 15px;">
                        <input type="text" class="form-control"
                               name="keyword" placeholder="标题/内容/作者/标签"
                               value="${pageInfo.keyword!}">
                        <span class="input-group-btn">
                            <button class="btn btn-default" type="submit">
                                <i class="icon icon-search"></i> 搜索
                            </button>
                        </span>
                    </div>
                    <input type="hidden" name="page" value="1">
                    <input type="hidden" name="sort" value="${pageInfo.sort!}">
                    <input type="hidden" name="pageSize" value="${pageInfo.pageSize!15}">
                </form>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead>
                        <tr>
                            <th width="5%"><a href="?sort=id&keyword=${pageInfo.keyword!}&pageSize=${pageInfo.pageSize!15}">ID ${((pageInfo.sort!"id") == "id")?then('▼','')}</a></th>
                            <th width="20%">标题</th>
                            <th width="10%">封面</th>
                            <th width="8%">区域</th>
                            <th width="10%">状态</th>
                            <th width="12%">作者</th>
                            <th width="8%"><a href="?sort=likes_count&keyword=${pageInfo.keyword!}&pageSize=${pageInfo.pageSize!15}">点赞 ${((pageInfo.sort!"id") == "likes_count")?then('▼','')}</a></th>
                            <th width="8%"><a href="?sort=favorites_count&keyword=${pageInfo.keyword!}&pageSize=${pageInfo.pageSize!15}">收藏 ${((pageInfo.sort!"id") == 'favorites_count')?then('▼','')}</a></th>
                            <th width="8%"><a href="?sort=views_count&keyword=${pageInfo.keyword!}&pageSize=${pageInfo.pageSize!15}">浏览 ${((pageInfo.sort!"id") == 'views_count')?then('▼','')}</a></th>
                            <th width="12%">创建时间</th>
                            <th width="12%">操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <#list pageInfo.list as blog>
                            <tr>
                                <td>${blog.id}</td>
                                <td>${blog.title}</td>
                                <td><img src="${blog.image!}" class="img-thumbnail" style="width:60px;height:40px"></td>
                                <td>${blog.area!'-'}</td>
                                <td>
                                    <span class="label ${(blog.status == 'pending')?then('label-warning',
                                    (blog.status == 'approved')?then('label-success',
                                    'label-default'))}">
                                        <#switch blog.status>
                                            <#case "pending">待审核<#break>
                                            <#case "approved">已发布<#break>
                                            <#case "rejected">已拒绝<#break>
                                        </#switch>
                                    </span>
                                </td>
                                <td>${blog.author}</td>
                                <td>${blog.likesCount}</td>
                                <td>${blog.favoritesCount}</td>
                                <td>${blog.viewsCount}</td>
                                <td>${blog.createdTime?string("yyyy-MM-dd HH:mm:ss")}</td>
                                <td>
                                    <div class="btn-group">
                                        <a href="/blog/${blog.id}" class="btn btn-xs btn-info" target="_blank" title="查看详情">
                                            <i class="icon icon-eye-open"></i>
                                        </a>
                                        <button class="btn btn-xs btn-warning edit-btn"
                                                data-toggle="modal"
                                                data-target="#editModal"
                                                data-blogid="${blog.id}"
                                                data-title="${blog.title}"
                                                data-content="${blog.content}"
                                                data-image="${blog.image!}"
                                                data-areaid="${blog.areaId!}"
                                                data-status="${blog.status}">
                                            <i class="icon icon-edit"></i>
                                        </button>
                                        <button class="btn btn-xs btn-danger delete-btn"
                                                data-blogid="${blog.id}"
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
                    共显示 ${pageInfo.list?size} 篇博客（总 ${pageInfo.total} 篇）
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

<!-- 编辑博客模态框 -->
<div class="modal fade" id="editModal">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title"><i class="icon icon-edit"></i> 编辑博客</h4>
            </div>
            <form action="/admin/blogs/update" method="post">
                <div class="modal-body">
                    <input type="hidden" name="id" id="editBlogId">
                    <div class="form-group">
                        <label>区域</label>
                        <select class="form-control" name="areaId" id="editArea">
                            <#list areas as area>
                                <option value="${area.id}">${area.name}</option>
                            </#list>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>状态</label>
                        <select class="form-control" name="status" id="editStatus">
                            <option value="pending">待审核</option>
                            <option value="approved">已发布</option>
                            <option value="rejected">已拒绝</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>标签（逗号分隔）</label>
                        <input type="text" class="form-control"
                               name="tags" id="editTags">
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
    // 模态框数据绑定
    $(function(){
        $('#editModal').on('show.bs.modal', function(event) {
            const button = $(event.relatedTarget);
            const modal = $(this);

            modal.find('#editBlogId').val(button.data('id'));
            modal.find('#editTitle').val(button.data('title'));
            modal.find('#editContent').val(button.data('content'));
            modal.find('#editImage').val(button.data('image'));
            modal.find('#editArea').val(button.data('areaid')); // 使用区域ID
            modal.find('#editStatus').val(button.data('status'));
            modal.find('#editTags').val(button.data('tags'));
        });

        // 删除操作
        $('.delete-btn').click(function() {
            const blogId = $(this).data('blogid');
            if(confirm('确定要删除这篇博客吗？')) {
                window.location.href = '/admin/blog/delete?id=' + blogId;
            }
        });
    });
</script>

<style>
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
    .pagination-sm {
        margin: 15px 0 0;
    }
    .label-warning { background-color: #f0ad4e; }
    .label-success { background-color: #5cb85c; }
    .label-default { background-color: #777; }
</style>

<#include "../import/bottom.ftl">