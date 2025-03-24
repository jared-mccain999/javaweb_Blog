<#include "../import/top_user.ftl">


<div class="container" style="margin-top: 80px;">
    <!-- 博客列表 -->
    <div class="row">
        <#if pageInfo.list?? && (pageInfo.list?size > 0)>
            <#list pageInfo.list as blog>
                <div class="col-md-4">
                    <div class="article-card">
                        <div class="card">
                            <!-- 封面图 -->
                            <div class="article-cover"
                                 style="background-image: url(${blog.image!'/img/default-cover.jpg'});">
                                <div class="cover-mask"></div>
                            </div>
                            <div class="card-body">
                                <!-- 标题 -->
                                <h4 class="card-title">
                                    <a href="/blog/${blog.id}">${blog.title}</a>
                                </h4>

                                <!-- 作者和区域 -->
                                <div class="text-muted small">
                                    <i class="icon icon-user"></i> ${blog.author!''}
                                    <span class="pull-right">
                                        <i class="icon icon-map-marker"></i> ${blog.area!''}
                                    </span>
                                </div>

                                <!-- 摘要 -->
                                <p class="card-text" style="margin-top: 10px;">
                                    <#if blog.content?length gt 60>
                                    ${blog.content?substring(0, 60)}...
                                    <#else>
                                        ${blog.content}
                                    </#if>...
                                </p>

                                <!-- 标签 -->
                                <div class="tag-list">
                                    <#if blog.tags??>
                                        <#list blog.tags as tag>
                                            <span class="label label-primary">${tag}</span>
                                        </#list>
                                    </#if>
                                </div>

                                <!-- 统计数据 -->
                                <div class="stats text-muted small" style="margin-top: 10px;">
                                    <span class="mr-3">
                                        <i class="icon icon-eye-open"></i> ${blog.viewsCount}
                                    </span>
                                    <span class="mr-3">
                                        <i class="icon icon-thumbs-up"></i> ${blog.likesCount}
                                    </span>
                                    <span>
                                        <i class="icon icon-star"></i> ${blog.favoritesCount}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </#list>
        <#else>
            <div class="col-md-12">
                <div class="alert alert-info">暂时没有找到相关博客</div>
            </div>
        </#if>
    </div>

    <!-- 分页 -->
    <div class="text-center">
        <ul class="pager" data-ride="pager" data-page="${pageInfo.page}"
            data-rec-total="${pageInfo.total}"
            data-rec-per-page="${pageInfo.pageSize}"
            data-link-creator="/user/index?page={page}">
        </ul>
    </div>
</div>


<#include "../import/bottom.ftl">



