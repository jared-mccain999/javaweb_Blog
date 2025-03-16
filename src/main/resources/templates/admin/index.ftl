<#include "../import/top.ftl">

<div class="row">
    <!-- 欢迎面板 -->
    <div class="col-md-12">
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title">
                    <i class="icon icon-heart"></i>
                    <#if user??>
                        欢迎回来，${user.username}！
                    <#else>
                        欢迎登录管理系统
                    </#if>
                </h3>
            </div>
            <div class="panel-body">
                <p class="text-muted">今天是 ${.now?string('yyyy年MM月dd日')}，祝您工作愉快！</p>
            </div>
        </div>
    </div>

    <!-- 数据统计卡片 -->
    <div class="col-md-3">
        <div class="panel panel-success">
            <div class="panel-body text-center">
                <i class="icon icon-user icon-3x"></i>
                <h3>用户总数</h3>
                <p class="text-primary" style="font-size: 28px; margin: 10px 0;">${userCount!0}</p>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="panel panel-info">
            <div class="panel-body text-center">
                <i class="icon icon-file-text icon-3x"></i>
                <h3>文章总数</h3>
                <p class="text-info" style="font-size: 28px; margin: 10px 0;">${blogCount!0}</p>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="panel panel-warning">
            <div class="panel-body text-center">
                <i class="icon icon-tags icon-3x"></i>
                <h3>标签总数</h3>
                <p class="text-warning" style="font-size: 28px; margin: 10px 0;">${tagCount!0}</p>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="panel panel-danger">
            <div class="panel-body text-center">
                <i class="icon icon-map-marker icon-3x"></i>
                <h3>区域总数</h3>
                <p class="text-danger" style="font-size: 28px; margin: 10px 0;">${areaCount!0}</p>
            </div>
        </div>
    </div>

    <!-- 系统信息面板 -->
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">
                    <i class="icon icon-desktop"></i>
                    系统信息
                </h3>
            </div>
            <div class="panel-body">
                <ul class="list-group">
                    <li class="list-group-item">
                        <span class="badge">${osName!'N/A'}</span>
                        <i class="icon icon-windows"></i> 操作系统
                    </li>
                    <li class="list-group-item">
                        <span class="badge">${hostAddress!'N/A'}</span>
                        <i class="icon icon-server"></i> 主机地址
                    </li>
                    <li class="list-group-item">
                        <span class="badge">${.now?string('yyyy-MM-dd HH:mm')}</span>
                        <i class="icon icon-time"></i> 服务器时间
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

<#include "../import/bottom.ftl">
