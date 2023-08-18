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

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
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

		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		$("#remarkListBody").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		});

		$("#remarkListBody").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		});

		$("#remarkListBody").on("mouseover",".myHref",function () {
			$(this).children("span").css("color","red");
		});
		$("#remarkListBody").on("mouseout",".myHref",function () {
			$(this).children("span").css("color","#E6E6E6");
		});

		//打开【删除交易】的模态窗口
		$("#tranListBody").on("click","#delTranBtn",function () {
			var id = $(this).attr("tranId");
			$("#del-tranId").val(id);
			$("#removeTransactionModal").modal("show");
		});

		//【删除交易】
		$("#deleteTranBtn").click(function () {
			var id = $("#del-tranId").val();
			if (confirm("确定要删除选中的记录吗?")){
				$.ajax({
					url:'workbench/tran/deleteTranByIds.do',
					data:{
						id:id
					},
					dataType:'json',
					type:'post',
					success:function (data) {
						if (data.code=="1"){
							alert("删除交易成功！");
							$("#tr_"+id).remove();
							$("#removeTransactionModal").modal("hide");
						}else {
							alert(data.message);
							$("#removeTransactionModal").modal("show");
						}
					}
				});
			}
		});
		//打开【删除联系人】的模态窗口
		$("#contactsListBody").on("click","#delContactA",function (){
			var id = $(this).attr("contactsId");
			$("#del-contactsId").val(id);
			$("#removeContactsModal").modal("show");
		});
		//【删除联系人】
		$("#delContactBtn").click(function () {
			var id = $("#del-contactsId").val();
			if (confirm("确定要删除选中的记录吗?")){
				$.ajax({
					url:'workbench/contacts/deleteContactsByIds.do',
					data:{
						id:id
					},
					dataType:'json',
					type:'post',
					success:function (data) {
						if (data.code=="1"){
							alert("删除交易成功！");
							$("#tr_"+id).remove();
							$("#removeTransactionModal").modal("hide");
						}else {
							alert(data.message);
							$("#removeTransactionModal").modal("show");
						}
					}
				});
			}
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

		//【保存联系人】
		$("#saveCreateContactBtn").click(function () {
			//收集参数
			var owner = $("#create-owner").val();
			var source = $("#create-source").val();
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
						var html = '';
						html += '<tr>';
						html += '<td><a href="contacts/detail.html" style="text-decoration: none;">'+fullname+'</a></td>';
						html += '<td>'+email+'</td>';
						html += '<td>'+mphone+'</td>';
						html += '<td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeContactsModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>';
						html += '</tr>';
						$("#contactsListBody").append(html);
						$("#createContactsModal").modal("hide");
					}else {
						alert(data.message);

						$("#createContactsModal").modal("show");
					}
				}
			});
		});

		//【保存备注】
		$("#saveCustomerRemarkBtn").click(function () {
			//收集参数
			var noteContent = $.trim($("#remark").val());
			var customerId = '${customer.id}';
			if (remark==""){
				alert("备注内容不能为空！");
				return;
			}
			//发送ajax请求
			$.ajax({
				url:'workbench/customer/saveCustomerRemark.do',
				data:{
					noteContent:noteContent,
					customerId:customerId
				},
				dataType:'json',
				type:'post',
				success:function (data) {
					if (data.code=="1"){
						//清空输入框
						$("#remark").val("");
						var html = "";
						html += '<div id="div_'+data.retData.id+'" class="remarkDiv" style="height: 60px;">';
						html += '<img title="${sessionScope.sessionUser.name}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						html += '<h5>'+data.retData.noteContent+'</h5>';
						html += '<font color="gray">客户</font> <font color="gray">-</font> <b>${customer.name}</b> <small style="color: gray;"> '+data.retData.createTime+' 由 ${sessionScope.sessionUser.name} 创建</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html += '<a class="myHref"  name="editA" remarkId="'+data.retData.id+'"  href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a class="myHref" name="deleteA" remarkId="'+data.retData.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
						html += '</div>';
						html += '</div>';
						html += '</div>';

						$("#remarkDiv").before(html)
					}else {
						alert(data.message);
					}
				}
			});
		});

		//【点击修改备注】
		$("#remarkListBody").on("click","a[name=editA]",function () {
			var id = $(this).attr("remarkId");
			var noteContent = $("#div_"+id+" h5").text();
			$("#edit-id").val(id);
			$("#edit-noteContent").val(noteContent);
			$("#editRemarkModal").modal("show");

			$("#editRemarkModal").on("shown.bs.modal",function () {
				$("#editRemarkModal #edit-noteContent").focus();
			});
		});

		//【更新】
		$("#updateRemarkBtn").click(function () {
			//收集参数
			var noteContent = $.trim($("#edit-noteContent").val());
			var id = $("#edit-id").val();
			//alert(id)
			//表单验证
			if(noteContent==""){
				alert("备注内容不能为空！");
				return;
			}
			$.ajax({
				url:'workbench/customer/updateCustomerRemark.do',
				data:{
					noteContent:noteContent,
					id:id
				},
				dataType:'json',
				type:'post',
				success:function (data) {
					if (data.code=="1"){
						//更新选中修改的备注信息
						$("#div_"+id+" h5").text(noteContent);
						$("#div_"+id+" small").text(data.retData.editTime+' 由 ${sessionScope.sessionUser.name}修改');
						//关闭模态窗口
						$("#editRemarkModal").modal("hide");
					}else {
						alert(data.message);
						$("#editRemarkModal").modal("show");
					}
				}
			});
		});

		//【删除】
		$("#remarkListBody").on("click","a[name=deleteA]",function () {
			if (confirm("确定删除选中的备注吗？")){
				var id = $(this).attr("remarkId");
				$.ajax({
					url:'workbench/customer/deleteCustomerRemark.do',
					data:{
						id:id
					},
					dataType:'json',
					type:'post',
					success:function (data) {
						if (data.code=="1"){
							$("#div_"+id).remove();
						}else {
							alert(data.message);
						}
					}
				});
			}
		});

	});
	
</script>

</head>
<body>

<!-- 修改备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
	<%-- 备注的id --%>
	<input type="hidden" id="edit-id">
	<div class="modal-dialog" role="document" style="width: 40%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">修改备注</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<div class="form-group">
						<label for="edit-describe" class="col-sm-2 control-label">内容</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
			</div>
		</div>
	</div>
</div>

	<!-- 删除联系人的模态窗口 -->
	<div class="modal fade" id="removeContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除联系人</h4>
				</div>
				<div class="modal-body">
					<p>您确定要删除该联系人吗？</p>
					<input type="hidden" id="del-contactsId">
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="delContactBtn">删除</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 删除交易的模态窗口 -->
    <div class="modal fade" id="removeTransactionModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 30%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title">删除交易</h4>
                </div>
                <div class="modal-body">
                    <p>您确定要删除该交易吗？</p>
					<input type="hidden" id="del-tranId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-danger" id="deleteTranBtn">删除</button>
                </div>
            </div>
        </div>
    </div>
	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <c:forEach items="${source}" var="s">
									  <option value="${s.value}">${s.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
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
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control mydate" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateContactBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${customer.name} <small><a href="${customer.website}" target="_blank">${customer.website}</a></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editCustomerModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${customer.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.contactSummary}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${customer.nextContactTime}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${customer.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 10px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<div id="remarkListBody">
			<c:forEach items="${customerRemarkList}" var="remark">
				<!-- 备注2 -->
				<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
					<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
					<div style="position: relative; top: -40px; left: 40px;" >
						<h5>${remark.noteContent}</h5>
						<font color="gray">客户</font> <font color="gray">-</font> <b>${customer.name}</b> <small style="color: gray;"> ${remark.editFlag=='0'? remark.createTime:remark.editTime} 由 ${remark.editFlag=='0'? remark.createBy:remark.editBy} ${remark.editFlag=='0'? '创建':'修改'}</small>
						<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
							<a class="myHref" remarkId=${remark.id} name="editA"  href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<a class="myHref" remarkId=${remark.id} name="deleteA" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
						</div>
					</div>
				</div>

			</c:forEach>

		</div>

		

		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveCustomerRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tranListBody">
					<c:forEach items="${tranList}" var="tran">
						<tr id="tr_${tran.id}">
							<td><a href="transaction/detail.jsp" style="text-decoration: none;">${tran.name}</a></td>
							<td>${tran.money}</td>
							<td>${tran.stage}</td>
							<td>${tran.possibility}</td>
							<td>${tran.expectedDate}</td>
							<td>${tran.type}</td>
							<td><a href="javascript:void(0);" id="delTranBtn" tranId="${tran.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>
					</c:forEach>

					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/tran/toCreateTranPage.do" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contactsListBody">
					<c:forEach items="${contactsList}" var="contact" >
						<tr id="tr_${contact.id}">
							<td><a href="contacts/detail.jsp" style="text-decoration: none;">${contact.fullname}</a></td>
							<td>${contact.email}</td>
							<td>${contact.mphone}</td>
							<td><a href="javascript:void(0);" id="delContactA" contactsId="${contact.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>
					</c:forEach>

					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" data-target="#createContactsModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>