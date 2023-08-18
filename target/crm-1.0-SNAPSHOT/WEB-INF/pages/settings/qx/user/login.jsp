<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link type="text/css" rel="stylesheet" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css"/>
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<script type="text/javascript">
		$(function () {
			//使login.jsp始终在顶层窗口中打开
			if(window.top!=window){
				window.top.location = window.location
			}

			//回车执行登录操作
			$(window).keydown(function (event) {
				if (event.keyCode==13){
					$("#loginBtn").click();
				}
			});

			//给"登录"按钮添加单击事件
			$("#loginBtn").click(function () {
				//收集参数
				var loginAct = $.trim($("#loginAct").val());
				var loginPwd = $.trim($("#loginPwd").val());
				//选择器.prop("属性名") 获取值是true或者false属性的值
				var isRemPwd = $("#isRemPwd").prop("checked");
				//验证参数是否合法
				if(loginAct == ""){
					$("#msg").html("用户名不能为空！")
					$("#loginAct").focus(function () {
						$("#msg").html("")
					})
					return;
				}
				if (loginPwd==""){
					$("#msg").html("密码不能为空！")
					$("#loginPwd").focus(function () {
						$("#msg").html("")
					})
					return;
				}

				//$("#loadingImage").modal("show");

				//发送ajax请求
				$.ajax({
					url:'settings/qx/user/login.do',
					data:{
						loginAct:loginAct,
						loginPwd:loginPwd,
						isRemPwd:isRemPwd
					},
					type:'post',
					dataType:'json',
					success:function (data) {
						//$("#loadingImage").modal("hide");
						if (data.code=="1"){
							//验证成功，跳转到workbench的页面
							window.location.href="workbench/toIndex.do";
						}else {
							$("#msg").html(data.message);
						}
					},
					beforeSend:function () {//当ajax向后台发送请求之前，会自动执行本函数；
											//该函数的返回值能够决定ajax是否真正向后台发送请求；
											//如果该函数返回true,则ajax会真正向后台发送请求；否则，如果该函数返回false，则ajax不会向后台发送请求
						$("#msg").text("正在努力验证...");
						return true;
					}
				});

			})
		})
	</script>
</head>
<body>
<div class="modal fade" id="loadingImage" role="dialog">
	<div class="modal-dialog" role="loading" style="width:30%;opacity: 0.8">
		<div class="modal-content">
			<img src="image/loading.gif" style="position: relative">
		</div>
	</div>
</div>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white;font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 20px;font-family: Consolas">&copy;2023&nbsp;HappyBalloon</span><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-balloon-heart" viewBox="0 0 16 16">
			<path fill-rule="evenodd" d="m8 2.42-.717-.737c-1.13-1.161-3.243-.777-4.01.72-.35.685-.451 1.707.236 3.062C4.16 6.753 5.52 8.32 8 10.042c2.479-1.723 3.839-3.29 4.491-4.577.687-1.355.587-2.377.236-3.061-.767-1.498-2.88-1.882-4.01-.721L8 2.42Zm-.49 8.5c-10.78-7.44-3-13.155.359-10.063.045.041.089.084.132.129.043-.045.087-.088.132-.129 3.36-3.092 11.137 2.624.357 10.063l.235.468a.25.25 0 1 1-.448.224l-.008-.017c.008.11.02.202.037.29.054.27.161.488.419 1.003.288.578.235 1.15.076 1.629-.157.469-.422.867-.588 1.115l-.004.007a.25.25 0 1 1-.416-.278c.168-.252.4-.6.533-1.003.133-.396.163-.824-.049-1.246l-.013-.028c-.24-.48-.38-.758-.448-1.102a3.177 3.177 0 0 1-.052-.45l-.04.08a.25.25 0 1 1-.447-.224l.235-.468ZM6.013 2.06c-.649-.18-1.483.083-1.85.798-.131.258-.245.689-.08 1.335.063.244.414.198.487-.043.21-.697.627-1.447 1.359-1.692.217-.073.304-.337.084-.398Z"/>
		</svg> </div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="loginAct" type="text" value="${cookie.loginAct.value}" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="loginPwd" type="password" value="${cookie.loginPwd.value}" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
								<input type="checkbox" id="isRemPwd" checked>
							</c:if>
							<c:if test="${empty cookie.loginAct or empty cookie.loginPwd}">
								<input type="checkbox" id="isRemPwd">
							</c:if>
							十天内免登录
						</label>
						&nbsp;&nbsp;
						<span style="color:red" id="msg"></span>
					</div>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>