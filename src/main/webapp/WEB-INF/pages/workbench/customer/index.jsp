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

		queryCustomerByConditionForPage(1,5)

		$(".mydate").datetimepicker({
			language:'zh-CN',//语言
			format:'yyyy-mm-dd',//日期的格式
			minView:'month',//可以选择的最小视图
			initialDate:new Date(),//默认选中现在的时间
			todayBtn:true,//显示今天
			autoclose:true,//设置选择完日期或者时间之后，是否自动关闭日历
			clearBtn:true,//设置是否显示“清空”按钮，默认是false
			pickerPosition: "top-left"
		});
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		//【查询】
		$("#searchCustomerBtn").click(function () {
			queryCustomerByConditionForPage(1,5);
			return false;
		});
		//【保存客户】
		$("#saveCustomerBtn").click(function () {


			var owner = $("#create-owner").val();
			var name = $.trim($("#create-name").val());
			var website = $.trim($("#create-website").val());
			var phone = $.trim($("#create-phone").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $("#create-nextContactTime").val();
			var description = $.trim($("#create-description").val());
			var address = $.trim($("#create-address").val());

			if(owner == ""){
				alert("所有者不能为空");
				return;
			}
			if(name == ""){
				alert("客户名称不能为空");
				return;
			}
			var RegExp = /\d{3}-\d{8}|\d{4}-\d{7}/;
			if (!RegExp.test(phone)){
				alert("座机号码格式非法！");
				return;
			}

			$.ajax({
				url:'workbench/customer/saveCreateCustomer.do',
				data:{
					owner:owner,
					name:name,
					phone:phone,
					website:website,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				dataType:'json',
				type:'post',
				success:function (data) {
					if (data.code=="1"){
						alert("创建客户成功！");
						queryCustomerByConditionForPage(1,5);

						$("#createCustomerModal").modal("hide");
					}else {
						alert(data.message);

						$("#createCustomerModal").modal("show");
					}
				}
			});

		});
		//【修改前的铺值】
		$("#editCustomerBtn").click(function () {
			var checkedIds = $("input[name=xz]:checked");
			if (checkedIds.length==0){
				alert("请选择需要修改的线索！");
				return;
			}
			if (checkedIds.length>1){
				alert("只能选择一条线索记录去修改！");
				return;
			}
			var customerId = checkedIds.val();
			$.ajax({
				url:'workbench/customer/editCustomerBefore.do',
				data:{
					id:customerId
				},
				dataType:'json',
				type:'get',
				success:function (data) {

					$("#edit-id").val(customerId);
					$("#edit-owner").val(data.owner);
					$("#edit-name").val(data.name);
					$("#edit-website").val(data.website);
					$("#edit-phone").val(data.phone);
					$("#edit-contactSummary").val(data.contactSummary);
					$("#edit-nextContactTime").val(data.nextContactTime);
					$("#edit-description").val(data.description);
					$("#edit-address").val(data.address);

					$("#editCustomerModal").modal("show");
				}
			});
		});
		//【更新修改】
		$("#updateCustomerBtn").click(function () {
			//收集参数
			var id = $("#edit-id").val();
			var owner = $("#edit-owner").val();
			var name = $.trim($("#edit-name").val());
			var website = $.trim($("#edit-website").val());
			var phone = $.trim($("#edit-phone").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime = $("#edit-nextContactTime").val();
			var description = $.trim($("#edit-description").val());
			var address = $.trim($("#edit-address").val());

			//表单验证
			if(owner==""||owner==null){
				alert("所有者不能为空！");
				return;
			}

			if(name==""||name==null){
				alert("公司不能为空！");
				return;
			}
			var RegExp = /\d{3}-\d{8}|\d{4}-\d{7}/;
			if (!RegExp.test(phone)){
				alert("座机号码格式非法！");
				return;
			}

			$.ajax({
				url:'workbench/customer/updateCustomer.do',
				data:{
					id:id,
					owner:owner,
					name:name,
					phone:phone,
					website:website,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				dataType:'json',
				type:'post',
				success:function (data) {
					if (data.code=="1"){
						alert("更新客户成功!");
						//刷新线索列表
						queryCustomerByConditionForPage(1,5);
						$("#editCustomerModal").modal("hide");
					}else {
						alert(data.message);
						$("#editCustomerModal").modal("show");
					}
				}
			});
		});
		//【删除客户】
		$("#delCustomerBtn").click(function () {
			var checkedIds = $("input[name=xz]:checked");
			if(checkedIds.size()==0){
				alert("请选择要删除的联系人");
				return;
			}
			if(window.confirm("确定选择删除选中的联系人吗？")) {
				//遍历
				var ids = "";
				$.each(checkedIds, function (i, a) {
					ids += "id=" + a.value + "&";
				});
				ids = ids.substring(0, ids.length - 1);
				$.ajax({
					url: 'workbench/customer/deleteCustomerByIds.do',
					data: ids,
					dataType: 'json',
					type: 'post',
					success: function (data) {
						if (data.code == "1") {
							//5)删除市场活动之后,刷新市场活动列表
							queryCustomerByConditionForPage(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
							alert("删除成功！");
						} else {
							alert(data.message);
						}
					}
				});
			}
		});

	});

	function queryCustomerByConditionForPage(pageNo,pageSize) {
		//收集参数
		var name = $("#search-name").val();
		var owner = $("#search-owner").val();
		var phone = $("#search-phone").val();
		var website = $("#search-website").val();

		$.ajax({
			url:'workbench/customer/queryCustomerByConditionForPage.do',
			data:{
				name:name,
				owner:owner,
				phone:phone,
				website:website,
				pageNo:pageNo,
				pageSize:pageSize
			},
			dataType:'json',
			type:'get',
			success:function (data) {
				var html = ""
				$.each(data.customerList,function (i,c) {
					html += '<tr>';
					html += '<td><input type="checkbox" name="xz" value="'+c.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/toDetailPage.do?id='+c.id+'\';">'+c.name+'</a></td>';
					html += '<td>'+c.owner+'</td>';
					html += '<td>'+c.phone+'</td>';
					html += '<td>'+c.website+'</td>';
					html += '</tr>';
				});
				$("#customerTBody").html(html);

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
						queryCustomerByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		});
	}
	
</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <option></option>
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control mydate" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCustomerBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<input type="hidden" id="edit-id">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								  <option></option>
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control mydate" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateCustomerBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" type="text" id="search-website">
				    </div>
				  </div>
				  
				  <button type="button" id="searchCustomerBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createCustomerModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editCustomerBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="delCustomerBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customerTBody">
					</tbody>
				</table>
				<div id="pagination"></div>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>