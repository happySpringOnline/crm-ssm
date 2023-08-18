<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<!--PAGINATION plugin-->
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>


<script type="text/javascript">

	$(function(){

		queryTranListForPageByCondition(1,5);

		//【查询】
		$("#searchTranBtn").click(function () {
			queryTranListForPageByCondition(1,5);
		});

		//【去修改页面】
		$("#editTranBtn").click(function () {
			var checkedIds = $("input[name=tran]:checked");
			if (checkedIds.length==0){
				alert("还未选择需要修改的记录！");
				return;
			}
			if (checkedIds.length>1){
				alert("只能选择一条记录修改！");
				return;
			}
			var tranId = checkedIds.val();

			window.location.href="workbench/tran/toEditPage.do?id="+tranId;
		});

		//【删除】
		$("#deleteTranBtn").click(function () {
			var checkedIds = $("input[name=tran]:checked");
			if (checkedIds.length==0){
				alert("请选择需要删除的交易！");
				return;
			}
			if (confirm("确定要删除选中的记录吗")){
				var param = ""
				$.each(checkedIds,function (i,c) {
					param += "id="+c.value+"&"
				});
				param = param.substring(0,param.length-1);
				$.ajax({
					url:'workbench/tran/deleteTranByIds.do',
					data:param,
					dataType:'json',
					type:'post',
					success:function (data) {
						if (data.code=="1"){
							alert("删除交易成功！")
							queryTranListForPageByCondition(1,5);
						}else {
							alert(data.message);
						}
					}
				});
			}
		});
		
	});

	function queryTranListForPageByCondition(pageNo,pageSize){
		var owner = $.trim($("#search-owner").val());
		var name = $.trim($("#search-name").val());
		var customerName = $.trim($("#search-customerName").val());
		var stage = $("#search-stage").val();
		var type = $("#search-type").val();
		var source = $("#search-source").val();
		var contactsName = $.trim($("#search-contactsName").val());

		$.ajax({
			url:'workbench/tran/queryTranListForPageByCondition.do',
			data:{
				owner:owner,
				name:name,
				customerName:customerName,
				stage:stage,
				type:type,
				source:source,
				contactsName:contactsName,
				pageNo:pageNo,
				pageSize:pageSize
			},
			dataType:'json',
			type:'get',
			success:function (data) {
				var html = "";
				$.each(data.tranList,function (i,t) {

					html += '<tr>';
					html += '<td><input type="checkbox" name="tran" value="'+t.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/tran/toDetailPage.do?tranId='+t.id+'\';">'+t.name+'</a></td>';
					html += '<td>'+t.customerId+'</td>';
					html += '<td>'+t.stage+'</td>';
					html += '<td>'+t.type+'</td>';
					html += '<td>'+t.owner+'</td>';
					html += '<td>'+t.source+'</td>';
					html += '<td>'+t.contactsId+'</td>';
					html += '</tr>';
				});

				$("#tranTBody").html(html);

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
						queryTranListForPageByCondition(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		});
	}
	
</script>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="search-stage">
					  	<option></option>
					  	<c:forEach items="${stage}" var="stage">
							<option value="${stage.value}">${stage.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="search-type">
					  	<option></option>
						  <c:forEach items="${transactionType}" var="transactionType">
							  <option value="${transactionType.value}">${transactionType.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${source}" var="source">
							  <option value="${source.value}">${source.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="search-contactsName">
				    </div>
				  </div>
				  
				  <button type="button"  id="searchTranBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/tran/toCreateTranPage.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editTranBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteTranBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tranTBody">


					</tbody>
				</table>
				<div id="pagination"></div>
			</div>
			

			
		</div>
		
	</div>
</body>
</html>