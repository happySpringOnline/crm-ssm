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
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<!--PAGINATION plugin-->
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){

		$(".mydate").datetimepicker({
			language:'zh-CN',//语言
			format:'yyyy-mm-dd',//日期的格式
			minView:'month',//可以选择的最小视图
			initialDate:new Date(),//默认选中现在的时间
			todayBtn:true,//显示今天
			autoclose:true,//设置选择完日期或者时间之后，是否自动关闭日历
			pickerPosition: "bottom-right"
		});

		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		queryContactsForPageByCondition(1,5);
		
		$("#searchContactsBtn").click(function () {
			queryContactsForPageByCondition(1,5);
			return false;
		});
		
		$("#createContactBtn").click(function () {
			$("#createContactForm")[0].reset();
			$("#createContactsModal").modal("show");
		});

		//【补全客户名字】
		$("#create-customerName").typeahead({
			source:function (query,process) {
				$.ajax({
					url:'workbench/tran/queryAllCustomerName.do',
					data:{
						customerName: query
					},
					type:'get',
					dataType:'json',
					success:function (data) {
						process(data);
					}
				});
			}
		});
		$("#edit-customerName").typeahead({
			source:function (query,process) {
				$.ajax({
					url:'workbench/tran/queryAllCustomerName.do',
					data:{
						customerName: query
					},
					type:'get',
					dataType:'json',
					success:function (data) {
						process(data);
					}
				});
			}
		});

		//【保存联系人】
		$("#saveCreateContactBtn").click(function () {
			//收集参数
			var owner = $("#create-contactsOwner").val();
			var source = $("#create-clueSource").val();
			var customerName = $.trim($("#create-customerName").val());
			var fullname = $.trim($("#create-fullname").val());
			var appellation = $("#create-appellation").val();
			var email = $.trim($("#create-email").val());
			var mphone = $.trim($("#create-mphone").val());
			var job = $.trim($("#create-job").val());
			var description = $.trim($("#create-description").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $("#create-nextContactTime").val();
			var address = $.trim($("#create-address").val());
			var birth = $("#create-birth").val();

			if(owner == ""){
				alert("所有者不能为空");
				return;
			}
			if(fullname == "") {
				alert("名称不能为空");
				return;
			}
			var RegExp1 = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if (!RegExp1.test(email)){
				alert("邮箱格式非法！");
				return;
			}
			var RegExp2 = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}/;
			if (!RegExp2.test(mphone)){
				alert("手机号码格式非法！");
				return;
			}

			$.ajax({
				url:'workbench/contacts/saveContacts.do',
				data:{
					owner:owner,
					source:source,
					customerName:customerName,
					fullname:fullname,
					appellation:appellation,
					email:email,
					mphone:mphone,
					job:job,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address,
					birth:birth
				},
				dataType: 'json',
				type:'post',
				success:function (data) {
					if (data.code=="1"){
						alert("创建联系人成功！");
						queryContactsForPageByCondition(1,5);

						$("#createContactsModal").modal("hide");
					}else {
						alert(data.message);

						$("#createContactsModal").modal("show");
					}
				}
			});
		});
		//【修改联系人铺值】
		$("#editContactBtn").click(function () {
			var checkedIds = $("input[name=contact]:checked");
			if (checkedIds.size()==0){
				alert("请选择要修改的市场活动！");
				return;
			}else if(checkedIds.size()>1){
				alert("只能选择一条市场活动去修改！");
				return;
			}
			var cid = checkedIds.val();
			$.ajax({
				url:'workbench/contacts/queryContactsForEdit.do',
				data: {
					id:cid
				},
				dataType:'json',
				type:'get',
				success:function (c) {
					//给修改市场活动的模态窗口加一个隐藏域保存市场活动的id
					$("#edit-contactsId").val(c.id);
					$("#edit-contactsOwner").val(c.owner);
					$("#edit-clueSource").val(c.source);
					$("#edit-customerName").val(c.customerId);
					$("#edit-fullname").val(c.fullname);
					$("#edit-appellation").val(c.appellation);
					$("#edit-email").val(c.email);
					$("#edit-mphone").val(c.mphone);
					$("#edit-job").val(c.job);
					$("#edit-description").val(c.description);
					$("#edit-contactSummary").val(c.contactSummary);
					$("#edit-nextContactTime").val(c.nextContactTime);
					$("#edit-address").val(c.address);
					$("#edit-birth").val(c.birth);

					$("#editContactsModal").modal("show");
				}
			});
		});
		//【更新联系人】
		$("#updateContactBtn").click(function () {

			var id=$("#edit-contactsId").val();
			var owner=$("#edit-contactsOwner").val();
			var source=$("#edit-clueSource").val();
			var customerName=$.trim($("#edit-customerName").val());
			var fullname=$.trim($("#edit-fullname").val());
			var appellation=$("#edit-appellation").val();
			var email=$.trim($("#edit-email").val());
			var mphone=$.trim($("#edit-mphone").val());
			var job=$.trim($("#edit-job").val());
			var description=$.trim($("#edit-description").val());
			var contactSummary=$.trim($("#edit-contactSummary").val());
			var nextContactTime=$("#edit-nextContactTime").val();
			var address=$.trim($("#edit-address").val());
			var birth=$("#edit-birth").val();

			if(owner == ""){
				alert("所有者不能为空");
				return;
			}
			if(fullname == "") {
				alert("名称不能为空");
				return;
			}
			var RegExp1 = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if (!RegExp1.test(email)){
				alert("邮箱格式非法！");
				return;
			}
			var RegExp2 = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}/;
			if (!RegExp2.test(mphone)){
				alert("手机号码格式非法！");
				return;
			}

			$.ajax({
				url:'workbench/contacts/saveEditedContacts.do',
				data:{
					id:id,
					owner:owner,
					source:source,
					customerName:customerName,
					fullname:fullname,
					appellation:appellation,
					email:email,
					mphone:mphone,
					job:job,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address,
					birth:birth
				},
				dataType:'json',
				type:'post',
				success:function (data) {
					if (data.code=="1"){
						//6)更新市场活动成功之后，刷新市场活动列表
						queryContactsForPageByCondition($("#pagination").bs_pagination('getOption','currentPage'),$("#pagination").bs_pagination('getOption','rowsPerPage'));
						//关闭模态窗口
						$("#editContactsModal").modal("hide");
					}else {
						alert(data.message);
						//模态窗口不关闭
						$("#editContactsModal").modal("show")
					}
				}
			})
		});
		//【删除联系人】
		$("#delContactBtn").click(function () {
			var checkedIds = $("input[name=contact]:checked");
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
					url: 'workbench/contacts/deleteContactsByIds.do',
					data: ids,
					dataType: 'json',
					type: 'post',
					success: function (data) {
						if (data.code == "1") {
							//5)删除市场活动之后,刷新市场活动列表
							queryContactsForPageByCondition(1, $("#pagination").bs_pagination('getOption', 'rowsPerPage'));
							alert("删除成功！");
						} else {
							alert(data.message);
						}
					}
				});
			}
	});

	function queryContactsForPageByCondition(pageNo,pageSize) {
		//收集参数
		var owner = $.trim($("#search-owner").val());
		var name = $.trim($("#search-name").val());
		var company = $.trim($("#search-company").val());
		var source = $("#search-clueSource").val();
		var birth = $("#search-birth").val();

		$.ajax({
			url:'workbench/contacts/queryContactsForPageByCondition.do',
			data:{
				owner:owner,
				fullname:name,
				company:company,
				source:source,
				birth:birth,
				pageNo:pageNo,
				pageSize:pageSize
			},
			type:'get',
			dataType: 'JSON',
			success:function (data) {
				var html = "";
				$.each(data.contactsList, function (i, c) {
					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="contact" value="' + c.id + '"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contacts/toDetailPage.do?id=' + c.id + '\';">' + c.fullname + '</a></td>';
					html += '<td>' + c.customerId + '</td>';
					html += '<td>' + c.owner + '</td>';
					html += '<td>' + c.source + '</td>';
					html += '<td>' + c.birth + '</td>';
					html += '</tr>';
				});
				$("#contactsTBody").html(html);

				var totalPages = data.totalRows % pageSize == 0 ? data.totalRows / pageSize : parseInt(data.totalRows / pageSize) + 1;
				//分页插件
				//对容器调用bs_pagination工具函数，显示翻页信息
				$("#pagination").bs_pagination({
					currentPage: pageNo,//当前页号，相当于pageNo

					rowsPerPage: pageSize,//每页显示条数，相当于pageSize
					totalRows: data.totalRows,//总条数
					totalPages: totalPages,//总页数，必填参数

					visiblePageLinks: 5,//最多可以显示的卡片数

					showGoToPage: true, //是否显示“跳转到”部分，默认true---显示
					showRowsPerPage: true,//是否显示“每页显示条数”部分。默认true---显示
					showRowsInfo: true,//是否显示记录的信息，默认true---显示

					//切换页面时,会自动触发该函数
					//该函数会返回切换页号之后的 pageNo和 pageSize
					onChangePage: function (event, pageObj) {
						//js代码
						//3)每次切换页号的时候，调用展示活动页面列表的方法
						queryContactsForPageByCondition(pageObj.currentPage, pageObj.rowsPerPage);
					}
				});
			}
		});
	}})
</script>
</head>
<body>

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createContactForm">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">
								  <option></option>
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
								  <option></option>
								  <c:forEach items="${source}" var="source">
									  <option value="${source.value}">${source.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <c:forEach items="${appellation}" var="call">
									  <option value="${call.value}">${call.text}</option>
								  </c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
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
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveCreateContactBtn" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-contactsId">
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">
								  <option></option>
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource">
								  <option></option>
								  <c:forEach items="${source}" var="source">
									  <option value="${source.value}">${source.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname">
							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
								  <c:forEach items="${appellation}" var="appellation">
									  <option value="${appellation.value}">${appellation.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control mydate" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address2" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateContactBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	

	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
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
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-company">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-clueSource">
						  <option></option>
						  <c:forEach items="${source}" var="source">
							  <option value="${source.value}">${source.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input class="form-control mydate" type="text" id="search-birth">
				    </div>
				  </div>
				  
				  <button type="button" id="searchContactsBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createContactBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editContactBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="delContactBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="contactsTBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>
							<td>动力节点</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>2000-10-10</td>
						</tr>
                        --%>
					</tbody>
				</table>
				<div id="pagination"></div>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 10px;">
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