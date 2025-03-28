<#include "../import/top_user.ftl">

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户信息中心</title>
    <style>
        /* 解决导航栏重叠问题 */
        body {
            padding-top: 70px; /* 根据导航栏高度调整 */
        }

        /* 卡片样式 */
        .user-card {
            margin: 20px 0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .blog-card {
            margin: 20px 0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        /* 统计信息样式 */
        .stats span {
            margin-right: 15px;
            display: inline-block;
            min-width: 60px;
        }

        /* 标签样式 */
        .label-tag {
            margin-right: 5px;
            margin-bottom: 5px;
            display: inline-block;
        }

        /* 缩略图样式 */
        .thumbnail-img {
            max-width: 100%;
            height: auto;
            margin-top: 10px;
            border-radius: 4px;
        }

        /* 内容区域限制 */
        .content {
            margin: 15px 0;
            line-height: 1.6;
            color: #555;
        }

        /* 响应式调整 */
        @media (max-width: 768px) {
            body {
                padding-top: 60px;
            }
            .dl-horizontal dt {
                width: auto;
                text-align: left;
                margin-bottom: 5px;
            }
            .dl-horizontal dd {
                margin-left: 0;
                margin-bottom: 15px;
            }
        }
    </style>
</head>
<body class="container">
<!-- 主内容区域 -->
<div class="main-content">
    <#-- 用户信息卡片 -->
    <div class="card user-card">
        <div class="card-main">
            <div class="card-body">
                <h3 class="card-title"><i class="icon icon-user"></i> 用户信息</h3>
                <#if user??>
                    <div class="row">
                        <div class="col-md-6">
                            <dl class="dl-horizontal">
                                <dt>用户名：</dt>
                                <dd>${user.username!''}</dd>
                                <dt>电子邮箱：</dt>
                                <dd>${user.email!''}</dd>
                                <dt>注册地区：</dt>
                                <dd>${user.area!'未设置'}</dd>
                            </dl>
                        </div>
                        <div class="col-md-6">
                            <dl class="dl-horizontal">
                                <dt>用户角色：</dt>
                                <dd><span class="label label-primary">${user.role!''}</span></dd>
                                <dt>账户状态：</dt>
                                <dd>
                                    <#if (user.status)??>
                                        <#if user.status == 1>
                                            <span class="label label-success">已启用</span>
                                        <#else>
                                            <span class="label label-danger">已禁用</span>
                                        </#if>
                                    <#else>
                                        <span class="label label-default">状态未知</span>
                                    </#if>
                                </dd>
                            </dl>
                        </div>
                    </div>
                <#else>
                    <div class="alert alert-danger">
                        <i class="icon icon-remove-sign"></i> 用户信息加载失败
                    </div>
                </#if>
            </div>
        </div>
    </div>

    <#-- 博客列表 -->
    <h3 class="page-header"><i class="icon icon-file-text"></i> 我的博客</h3>

    <#if blogs??>
        <#if blogs?size gt 0>
            <#list blogs as blog>
                <div class="card blog-card">
                    <div class="card-main">
                        <div class="card-body">
                            <#if blog.createdTime??>
                                <div class="pull-right text-muted small">
                                    ${blog.createdTime?string('yyyy-MM-dd HH:mm')}
                                </div>
                            </#if>
                            <h4 class="card-title">${blog.title!''}</h4>

                            <div class="article-meta">
                                <span class="label label-primary">${blog.area!''}</span>
                                <#if (blog.status)??>
                                    <#if blog.status == 'PUBLISHED'>
                                        <span class="label label-success">已发布</span>
                                    <#else>
                                        <span class="label label-warning">草稿</span>
                                    </#if>
                                </#if>
                            </div>

                            <#if (blog.content)??>
                                <div class="content">
                                    <#if blog.content?length gt 60>
                                        ${blog.content?substring(0, 60)?html}...
                                    <#else>
                                        ${blog.content?html}
                                    </#if>
                                </div>
                            </#if>

                            <#if (blog.image)??>
                                <div class="thumbnail">
                                    <img src="${blog.image}" class="thumbnail-img">
                                </div>
                            </#if>

                            <#if (blog.tags)?? && blog.tags?size gt 0>
                                <div class="tags">
                                    <#list blog.tags as tag>
                                        <span class="label label-tag label-rounded">
                                                <i class="icon icon-tag"></i>
                                                ${tag!''}
                                            </span>
                                    </#list>
                                </div>
                            </#if>

                            <div class="stats text-muted">
                                <span><i class="icon icon-thumbs-up"></i> ${blog.likesCount!0}</span>
                                <span><i class="icon icon-star"></i> ${blog.favoritesCount!0}</span>
                                <span><i class="icon icon-eye-open"></i> ${blog.viewsCount!0}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </#list>
        <#else>
            <div class="alert alert-info">
                <i class="icon icon-info-sign"></i> 暂未发布任何博客
            </div>
        </#if>
    <#else>
        <div class="alert alert-warning">
            <i class="icon icon-warning-sign"></i> 博客信息加载失败
        </div>
    </#if>
</div>

<script src="https://cdn.jsdelivr.net/npm/zui@1.10.0/dist/js/zui.min.js"></script>
<script>
    $(document).ready(function() {
        // 确保页面加载后内容不会与导航栏重叠
        var navHeight = $('.navbar-fixed-top').outerHeight();
        $('body').css('padding-top', navHeight + 'px');

        // 响应式调整
        $(window).resize(function() {
            var newNavHeight = $('.navbar-fixed-top').outerHeight();
            $('body').css('padding-top', newNavHeight + 'px');
        });
    });
</script>
</body>
</html>