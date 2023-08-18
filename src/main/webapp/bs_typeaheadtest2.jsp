<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>演示自动补全插件</title>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script type="text/javascript">
        $(function () {
           $("#customerName").typeahead({
               source:function (query,process) {
                   $.ajax({
                       url:'workbench/tran/queryAllCustomerName.do',
                       data:{
                           "customerName":query
                       },
                       dataType:'json',
                       type:'get',
                       success:function (data) {
                           process(data);
                       }
                   });
               }
           });
        });
    </script>
</head>
<body>
<br>
<input type="text" id="customerName">

</body>
</html>
