<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	
	<script type="text/javascript">
		$(function () {
			//【去修改页面】
			$("#editDicTypeBtn").click(function () {
				var checkedCodes = $("#dicTypeTBody input[type=checkbox]:checked");
				if (checkedCodes.size()==0){
					alert("请选择需要编辑的字典类型记录！");
					return;
				}
				if (checkedCodes.size()>1){
					alert("只能选择一条记录进行编辑！");
					return;
				}
				var code = checkedCodes.val();
				window.location.href = "settings/dictionary/type/toEditDicTypePage.do?code="+code;
			});
			
			//【删除】
			$("#deleteDicTypeBtn").click(function (){
				var checkedCodes = $("#dicTypeTBody input[type=checkbox]:checked");
				if (checkedCodes.size()==0){
					alert("请选择需要删除的字典类型记录！");
					return;
				}
				if (confirm("确定要删除选中的记录吗?")){
					var param = ""
					$.each(checkedCodes,function (i,dicTypeCode) {
						param += "code="+dicTypeCode.value+"&";
					})
					param = param.substring(0,param.length-1);
					$.ajax({
						url:'settings/dictionary/type/deleteDicTypeByBatch.do',
						data:param,
						dataType:'json',
						type:'post',
						success:function (data) {
							if (data.code=="1"){
								alert("成功删除"+data.retData+"记录！");
								//刷新页面
								window.location.href="settings/dictionary/type/index.do"
							}else {
								alert(data.message);
							}
						}
					});
				}

			});
			
			//【全选】
			$("#checkAll").click(function () {
				$("input[name=xz]").prop("checked",this.checked);
			});
			
			$("#dicTypeTBody").on("click",$("input[name=xz]"),function () {
				$("#checkAll").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
			});
		});
		
	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/type/toSaveDicTypePage.do'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-default" id="editDicTypeBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger" id="deleteDicTypeBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="checkAll"/></td>
					<td>序号</td>
					<td>编码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>
			<tbody id="dicTypeTBody">
				<c:forEach items="${dicTypeList}" var="dicType" varStatus="dicTypeStatus">
					<tr class="active">
						<td><input type="checkbox" value="${dicType.code}" name="xz"/></td>
						<td>${dicTypeStatus.count}</td>
						<td>${dicType.code}</td>
						<td>${dicType.name}</td>
						<td>${dicType.description}</td>
					</tr>
				</c:forEach>
				<%--<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td>sex</td>
					<td>性别</td>
					<td>性别包括男和女</td>
				</tr>--%>
			</tbody>
		</table>
	</div>
	
</body>
</html>