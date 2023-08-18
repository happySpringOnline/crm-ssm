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

	<!--PAGINATION plugin-->
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
	
	<script type="text/javascript">
		$(function () {

			queryDicValueByConditionForPage(1,8);

			//【全选】
			$("#checkAll").click(function () {
				$("input[name=xz]").prop("checked",this.checked);
			});
			$("#dicValueTBody").on("click",$("input[name=xz]"),function () {
				$("#checkAll").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
			})

		});

		function queryDicValueByConditionForPage(pageNo,pageSize){
			$.ajax({
				url:'settings/dictionary/value/queryDicValueByConditionForPage.do',
				data:{
					pageNo:pageNo,
					pageSize:pageSize
				},
				dataType:'json',
				type:'get',
				success:function (data) {
					var html="";
					$.each(data.dicValueList,function (i,dicValue) {
						html += '<tr class="active">';
						html += '<td><input type="checkbox" name="xz" value="'+dicValue.id+'"/></td>';
						html += '<td>'+(i+1)+'</td>';
						html += '<td>'+dicValue.value+'</td>';
						html += '<td>'+dicValue.text+'</td>';
						html += '<td>'+dicValue.orderNo+'</td>';
						html += '<td>'+dicValue.typeCode+'</td>';
						html += '</tr>';
					});
					$("#dicValueTBody").html(html);

					//取消全选按钮
					$("#checkAll").prop("checked",false);

					var totalPages = data.totalRows % pageSize == 0?data.totalRows/pageSize:parseInt(data.totalRows/pageSize)+1
					//分页插件
					//对容器调用bs_pagination工具函数，显示翻页信息
					$("#pagination").bs_pagination({
						currentPage:pageNo,//当前页号，相当于pageNo

						rowsPerPage:pageSize,//每页显示条数，相当于pageSize
						totalRows:data.totalRows,//总条数
						totalPages:totalPages,//总页数，必填参数

						visiblePageLinks:5,//最多可以显示的卡片数

						showGoToPage:true, //是否显示“跳转到”部分，默认true---显示
						showRowsPerPage:true,//是否显示“每页显示条数”部分。默认true---显示
						showRowsInfo:true,//是否显示记录的信息，默认true---显示

						//切换页面时,会自动触发该函数
						//该函数会返回切换页号之后的 pageNo和 pageSize
						onChangePage:function (event,pageObj) {
							//js代码
							//3)每次切换页号的时候，调用展示活动页面列表的方法
							queryDicValueByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
						}
					});
				}
			})
		}
	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/value/toSaveDicValuePage.do'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-default" onclick="window.location.href='edit.jsp'"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="checkAll"/></td>
					<td>序号</td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>
			<tbody id="dicValueTBody">
				<%--<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td>m</td>
					<td>男</td>
					<td>1</td>
					<td>sex</td>
				</tr>--%>
				<%--<c:forEach items="${dicValueList}" var="dicValue" varStatus="dicValueStatus">
					<tr class="active">
						<td><input type="checkbox" value="${dicValue.id}" name="xz"/></td>
						<td>${dicValueStatus.count}</td>
						<td>${dicValue.value}</td>
						<td>${dicValue.text}</td>
						<td>${dicValue.orderNo}</td>
						<td>${dicValue.typeCode}</td>
					</tr>
				</c:forEach>--%>
			</tbody>
		</table>
		<div id="pagination"></div>
	</div>
	
</body>
</html>