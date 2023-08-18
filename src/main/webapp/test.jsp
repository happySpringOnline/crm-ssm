<%--
  Created by IntelliJ IDEA.
  User: hp
  Date: 2023/8/2
  Time: 20:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>

    <script type="text/javascript" >
        window.onload = function (){
            var str = "beijing";
            str1 = str.substring(0,str.length-1);
            //alert(str1)
            alert(document.getElementById("text").text());
        }


    </script>
</head>
<body>
test page

<textarea id="text">快乐！！</textarea>
</body>
</html>
