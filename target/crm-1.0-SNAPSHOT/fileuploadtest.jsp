<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
  <base href="<%=basePath%>">
  <title>演示文件上传</title>
</head>
<body>
<%--
    文件上传的表单三个条件：
    1.表单组件标签只能用：<input type="file">
    2.请求方式只能用：post
    3.表单的编码格式(enctype属性)只能用：multipart/form-data
      默认是urlencoded,这种编码格式浏览器每次向后台提交数据，都会首先把所有的参数转换成字符串，
      然后对这些数据统一进行urlencoded编码；
      文件上传的表单编码格式只能用multipart/form-data
--%>
<form action="workbench/activity/fileUpload.do" method="post" enctype="multipart/form-data">
  <input type="text" name="userName"><br>
  <input type="file" name="myFile"><br><br>
  <input type="submit" value="提交">
</form>

</body>
</html>
