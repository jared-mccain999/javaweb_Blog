<#include "../import/top.ftl">

<div class="container">
    <div class="panel panel-default">
        <!-- 面板头部 -->
        <div class="panel-heading">
            <div class="row">
                <div class="col-md-6">
                    <h4 class="panel-title"><i class="icon icon-file-text"></i> 博客管理</h4>
                </div>
                <div class="col-md-6 text-right">
                    <span class="text-muted">共 ${pageInfo.total} 篇博客</span>
                </div>
            </div>
        </div>

        <!-- 搜索栏 -->
        <div class="panel-body">
            <form class="form-inline" action="/admin/blogs" method="get">
                <div class="input-group">
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
            </form>
        </div>

        <!-- 数据表格 -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead>
                <tr>
                    <th width="5%">
                        <a href="?sort=id&keyword=${pageInfo.keyword!}">
                            ID ${((pageInfo.sort!"id") == "id")?then('▼','')}
                        </a>
                    </th>
                    <th width="20%">标题</th>
                    <th width="10%">封面</th>
                    <th width="8%">区域</th>
                    <th width="10%">状态</th>
                    <th width="12%">作者</th>
                    <th width="8%">
                        <a href="?sort=likes_count&keyword=${pageInfo.keyword!}">
                            点赞 ${((pageInfo.sort!"id") == "likes_count")?then('▼','')}
                        </a>
                    </th>
                    <th width="8%">
                        <a href="?sort=favorites_count&keyword=${pageInfo.keyword!}">
                            收藏 ${((pageInfo.sort!"id") == 'favorites_count')?then('▼','')}
                        </a>
                    </th>
                    <th width="8%">
                        <a href="?sort=views_count&keyword=${pageInfo.keyword!}">
                            浏览 ${((pageInfo.sort!"id") == 'views_count')?then('▼','')}
                        </a>
                    </th>
                    <th width="12%">创建时间</th>
                    <th width="12%">操作</th>
                </tr>
                </thead>
                <tbody>
                <#list pageInfo.list as blog>
                    <tr>
                        <td>${blog.id}</td>
                        <td>${blog.title}</td>
                        <td>
                            <img src="${blog.image!}"
                                 class="img-thumbnail"
                                 style="width:60px;height:40px">
                        </td>
                        <td>${blog.area!'-'}</td>
                        <td>
                            <span class="label ${(blog.status == 'PENDING')?then('label-warning',
                            (blog.status == 'APPROVED')?then('label-success',
                            'label-default'))}">
                                ${blog.status}
                            </span>
                        </td>
                        <td>${blog.author}</td>
                        <td>${blog.likesCount}</td>
                        <td>${blog.favoritesCount}</td>
                        <td>${blog.viewsCount}</td>
                        <td>${blog.createdTime?string("yyyy-MM-dd HH:mm:ss")}</td>
                        <td>
                            <div class="btn-group">
                                <a href="/blog/${blog.id}"
                                   class="btn btn-xs btn-info"
                                   target="_blank"
                                   title="查看详情">
                                    <i class="icon icon-eye-open"></i>
                                </a>
                                <button class="btn btn-xs btn-warning edit-btn"
                                        data-toggle="modal"
                                        data-target="#editModal"
                                        data-blogid="${blog.id}"
                                        data-title="${blog.title}"
                                        data-content="${blog.content}"
                                        data-image="${blog.image!}"
                                        data-area="${blog.area}"
                                        data-status="${blog.status}"
                                        data-tags="${blog.tags!}">
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
            <form action="/admin/blog/update" method="post">
                <div class="modal-body">
                    <input type="hidden" name="id" id="editBlogId">

                    <div class="form-group">
                        <label>标题</label>
                        <input type="text" class="form-control"
                               name="title" id="editTitle" required>
                    </div>

                    <div class="form-group">
                        <label>内容</label>
                        <textarea class="form-control"
                                  name="content" id="editContent"
                                  rows="5" required></textarea>
                    </div>

                    <div class="form-group">
                        <label>封面图URL</label>
                        <input type="text" class="form-control"
                               name="image" id="editImage">
                    </div>

                    <div class="form-group">
                        <label>区域</label>
                        <select class="form-control" name="areaId" id="editArea">
                            <!-- 需要从后端获取区域列表动态生成 -->
                            <option value="1">北京</option>
                            <option value="2">上海</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>状态</label>
                        <select class="form-control" name="status" id="editStatus">
                            <option value="PENDING">待审核</option>
                            <option value="APPROVED">已发布</option>
                            <option value="REJECTED">已拒绝</option>
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

            modal.find('#editBlogId').val(button.data('blogid'));
            modal.find('#editTitle').val(button.data('title'));
            modal.find('#editContent').val(button.data('content'));
            modal.find('#editImage').val(button.data('image'));
            modal.find('#editArea').val(button.data('area'));
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

<#include "../import/bottom.ftl">