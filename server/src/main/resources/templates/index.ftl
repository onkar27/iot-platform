<#include "./common/header.ftl">
<body>
<#include "./common/navbar.ftl"/>
<#include "./common/chatbot.ftl"/>
<div class="container-fluid" id="container-main">
<#if user??>
    <#include "./common/sidenavbar.ftl"/>
</#if>
    <main role="main" class="main col-sm-9 ml-sm-auto col-md-10 pt-3 pb-5">
    <#if user??>
        <div class="row">
            <#if !units?has_content>
                <div class="alert alert-info">
                    You do not have any Units assigned. Please talk to your administrator.
                </div>
            </#if>
            <#list units as unit>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">${unit.unitName}</div>
                        <div class="card-body">
                            <img height=150 src="<#if (unit.photo)??>${unit.photo}<#else>http://via.placeholder.com/300</#if>" class="float-left p-1">
                            <#if (unit.description)??><p>${unit.description}</p></#if>
                            <div class="clear"></div>
                        </div>
                        <div class="card-footer">
                            <a class="btn btn-primary btn-sm" href="/units/get/${unit.id}"><i class="fa fa-cog"></i>MANAGE</a>
                        </div>
                    </div>
                </div>
            </#list>
        </div>
    <#else>

    </#if>
    </main>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.js"></script>
<script src="/static/js/app.js"></script>
</body>
</html>
