<#include "../common/header.ftl">
<body>
<#include "../common/navbar.ftl"/>
<#include "../common/chatbot.ftl"/>
<div class="container-fluid" id="container-main">
<#include "../common/sidenavbar.ftl"/>
<main role="main" class="main">
    <form autocomplete="on">
        <div class="form-group">
            <label for="inputEmail4">Unit ID:</label>
            <input type="text" class="form-control" id="rightID" placeholder="Unit ID">
        </div>


        <div class="form-group">
            <label for="comment">Roles:</label>
            <select class="form-control" id="rightRoles">
                <option>READ</option>
                <option>WRITE</option>
                <option>ALL</option>
            </select>
        </div>

        <button type="button" id="rightCreate" class="btn btn-primary"><i class="fa fa-plus" aria-hidden="true"></i>Create</button>
    </form>
</main>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.js"></script>
<script src="/static/js/app.js"></script>
<script>
    $(document).ready(function(){
        $("#rightCreate").on("click",function(){
            var rightID = $("#rightID").val();
            var rightRoles = $("#rightRoles").val();

            $.ajax({
                type: 'POST',
                url: '/right/create',
                data: {unit_id:rightID,role:rightRoles},
                contentType:'application/x-www-form-urlencoded',
                success: function(data) {
                    alert('success')
                },
            });
        })
    });
</script>
</body>
</html>
