<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>演示bs_pagination插件的使用</title>
    <!--JQUERY-->
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <!--BOOTSTRAP框架-->
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css"/>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <!--PAGINATION plugin-->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
</head>
<body>
    <script type="text/javascript">
        $(function () {

            $("#demo").bs_pagination({
                currentPage:1,//当前页号，相当于pageNo

                rowsPerPage:20,//每页显示条数，相当于pageSize
                totalRows:1000,//总条数
                totalPages:50,//总页数，必填参数

                visiblePageLinks:10,//最多可以显示的卡片数

                showGoToPage:true, //是否显示“跳转到”部分，默认true---显示
                showRowsPerPage:true,//是否显示“每页显示条数”部分。默认true---显示
                showRowsInfo:true,//是否显示记录的信息，默认true---显示

                //切换页面时,该函数会返回切换页号之后的 pageNo和 pageSize
                onChangePage:function (event,pageObj) {
                    //js代码
                    alert(pageObj.currentPage);
                    alert(pageObj.rowsPerPage);
                }
            });
        });

    </script>

    <div id="demo"></div>

</body>
</html>
