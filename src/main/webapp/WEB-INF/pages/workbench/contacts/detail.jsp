<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
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

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		showremark();

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


		//【保存备注】
		$("#saveContactsRemarkBtn").click(function () {
			//收集参数
			var noteContent = $.trim($("#remark").val());
			var contactsId = '${contact.id}';
			if (remark==""){
				alert("备注内容不能为空！");
				return;
			}
			//发送ajax请求
			$.ajax({
				url:'workbench/contacts/saveContactsRemark.do',
				data:{
					noteContent:noteContent,
					contactsId:contactsId
				},
				dataType:'json',
				type:'post',
				success:function (data) {
					if (data.code=="1"){
						//清空输入框
						$("#remark").val("");

						showremark();
					}else {
						alert(data.message);
					}
				}
			});
		});

		//【删除备注】
		$("#remarkListBody").on("click","a[name=deleteA]",function () {
			if (confirm("确定删除该条记录?")){
				//收集参数
				var id = $(this).attr("remarkId");
				//发送请求
				$.ajax({
					url:'workbench/contacts/deleteContactsRemarkById.do',
					data:{
						id:id
					},
					type:'post',
					dataType:'json',
					success:function (data) {
						if (data.code=="1"){
							alert("删除成功！")
							//移除该条记录对应的div
							$("#div_"+id).remove();
						}else {
							//提示信息
							alert(data.message);
						}
					}
				});
			}

		});

		//【点击修改备注】
		$("#remarkListBody").on("click","a[name=editA]",function () {
			var id = $(this).attr("remarkId");
			var noteContent = $("#div_"+id+" h5").text();
			//alert(noteContent);
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
				url:'workbench/contacts/updateContactsRemark.do',
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
						$("#div_"+id+" small").text(data.retData.editTime+' 由 ${sessionScope.sessionUser.name} 修改');
						//关闭模态窗口
						$("#editRemarkModal").modal("hide");
					}else {
						alert(data.message);
						$("#editRemarkModal").modal("show");
					}
				}
			});
		});

		//打开【删除交易】的模态窗口
		$("#tranListBody").on("click","#delTranBtn",function () {
			var id = $(this).attr("tranId");
			$("#del-tranId").val(id);
			$("#unbundModal").modal("show");
		})

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
							$("#unbundModal").modal("hide");
						}else {
							alert(data.message);
							$("#unbundModal").modal("show");
						}
					}
				});
			}
		});

		//打开【解除市场活动】的模态窗口
		$("#activityListBody").on("click","#unbundActivityBtn",function () {
			var id = $(this).attr("activityId");

			$("#unbund-activityId").val(id);
			$("#unbund-contactsId").val("${contact.id}");


			$("#unbundActivityModal").modal("show");
		});

		//【解除市场活动和联系人的关系】
		$("#unbundRelationBtn").click(function () {
			var activityId = $("#unbund-activityId").val();
			var contactsId = $("#unbund-contactsId").val();
			$.ajax({
				url:'workbench/contacts/unbundRelation.do',
				data:{
					activityId:activityId,
					contactsId:contactsId
				},
				dataType:'json',
				type:'post',
				success:function (data) {
					if (data.code=="1"){
						alert("解除市场活动与联系人关系成功！");
						$("#tr_"+activityId).remove();
						$("#unbundActivityModal").modal("hide");
					}else {
						alert(data.message);
						$("#unbundActivityModal").modal("show");
					}
				}
			});
		});

		$("#bundActivityBtn").click(function () {
			//初始化工作
			//清空搜索框
			$("#search-aname").val("");
			//清空搜索的市场活动列表
			$("#activityTBody").html("");
			$("#bundActivityModal").modal("show");
		});

		//根据名字模糊查询市场活动
		$("#search-aname").keyup(function () {
			//收集参数
			var activityName = this.value;
			var contactsId = '${contact.id}';
			//发送ajax请求
			$.ajax({
				url:'workbench/contacts/queryActivityForDetailByNameAndContactsId.do',
				data:{
					contactsId:contactsId,
					activityName:activityName
				},
				dataType:'json',
				type:'get',
				success:function (data) {
					var html = "";
					$.each(data,function (i,a) {
						html += '<tr>';
						html += '<td><input type="checkbox" name="a" value="'+a.id+'"/></td>';
						html += '<td>'+a.name+'</td>';
						html += '<td>'+a.startDate+'</td>';
						html += '<td>'+a.endDate+'</td>';
						html += '<td>'+a.owner+'</td>';
						html += '</tr>';
					});
					$("#activityTBody").html(html);
				}
			});
		});

		//【关联】按钮绑定事件
		$("#bundRelationBtn").click(function () {
			var checkedAIds = $("input[name=a]:checked");
			if (checkedAIds.length==0){
				alert("您还未选中需要关联的市场活动!");
				return;
			}
			var ids = "";
			$.each(checkedAIds,function (i,a) {
				ids += "activityId="+a.value+"&";
			});
			var contactsId = "${contact.id}";
			ids += "contactsId="+contactsId;

			$.ajax({
				url:'workbench/contacts/saveContactsActivityRelation.do',
				data:ids,
				dataType:'json',
				type:'post',
				success:function (data) {
					if (data.code=="1"){
						$("#bundActivityModal").modal("hide");
						var html = "";
						$.each(data.retData,function (i,a) {
							html += '<tr id="tr_'+a.id+'">';
							html += '<td><a href="activity/detail.jsp" style="text-decoration: none;">'+a.name+'</a></td>';
							html += '<td>'+a.startDate+'</td>';
							html += '<td>'+a.endDate+'</td>';
							html += '<td>'+a.owner+'</td>';
							html += '<td><a href="javascript:void(0);" activityId="'+a.id+'" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
							html += '</tr>';
						});
						$("#activityListBody").append(html);
					}else{
						alert(data.message);
						$("#bundActivityModal").modal("show");
					}
				}
			});
		});
		
	});

	function showremark() {
		$.ajax({
			url:'workbench/contacts/showContactsRemarkList.do',
			data:{
				contactsId:"${contact.id}"
			},
			dataType:'json',
			type:'get',
			success:function (data) {
				var html = "";
				$.each(data,function (i,c) {
					html += '<div id="div_'+c.id+'" class="remarkDiv" style="height: 60px;">';
					html += '<img title="'+c.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5>'+c.noteContent+'</h5>';
					html += '<font color="gray">联系人</font> <font color="gray">-</font> <b>${contact.fullname}${contact.appellation}-${contact.customerId}</b> <small style="color: gray;">'+(c.editFlag==0?c.createTime:c.editTime)+' 由 '+(c.editFlag==0?c.createBy:c.editBy)+' '+(c.editFlag==0?'创建':'修改')+'</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" name="editA" remarkId="'+c.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" name="deleteA" remarkId="'+c.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';
				});
				$("#remarkListBody").html(html);
			}
		})
	}
	
</script>

</head>
<body>

	<!-- 解除联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="unbundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">解除关联</h4>
				</div>
				<div class="modal-body">
					<p>您确定要解除该关联关系吗？</p>
					<input type="hidden" id="unbund-activityId">
					<input type="hidden" id="unbund-contactsId">
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="unbundRelationBtn">解除</button>
				</div>
			</div>
		</div>
	</div>


	<div class="modal fade" id="unbundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除</h4>
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
	
	<!-- 联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="bundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" id="search-aname" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable2" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityTBody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="bundRelationBtn">关联</button>
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
					<h4 class="modal-title" id="myModalLabel">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">
								  <option selected>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource">
								  <option></option>
								  <option selected>广告</option>
								  <option>推销电话</option>
								  <option>员工介绍</option>
								  <option>外部介绍</option>
								  <option>在线商场</option>
								  <option>合作伙伴</option>
								  <option>公开媒介</option>
								  <option>销售邮件</option>
								  <option>合作伙伴研讨会</option>
								  <option>内部研讨会</option>
								  <option>交易会</option>
								  <option>web下载</option>
								  <option>web调研</option>
								  <option>聊天</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
								  <option selected>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>
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
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-birth">
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
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
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
									<input type="text" class="form-control" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address1">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改线索备注的模态窗口 -->
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${contact.fullname}${contact.appellation} <small> - ${contact.customerId}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editContactsModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
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
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contact.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contact.fullname}${contact.appellation}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contact.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.job}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contact.birth}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contact.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${contact.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contact.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${contact.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${contact.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${contact.contactSummary}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contact.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                   ${contact.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	<!-- 备注 -->
	<div style="position: relative; top: 20px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<div id="remarkListBody">
			<!-- 备注2 -->
			<%--<c:forEach items="${remarkList}" var="remark">

				<div class="remarkDiv" style="height: 60px;">
					<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
					<div style="position: relative; top: -40px; left: 40px;" >
						<h5>${remark.noteContent}</h5>
						<font color="gray">联系人</font> <font color="gray">-</font> <b>${contact.fullname}${contact.appellation}-${contact.customerId}</b> <small style="color: gray;"> ${remark.editFlag=='0'? remark.createTime:remark.editTime} 由 ${remark.editFlag=='0'? remark.createBy:remark.editBy}</small>
						<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
							<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
						</div>
					</div>
				</div>

			</c:forEach>--%>
		</div>

		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" id="saveContactsRemarkBtn" class="btn btn-primary">保存</button>
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
				<table id="activityTable3" class="table table-hover" style="width: 900px;">
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
								<td><a href="transaction/detail.jsp" style="text-decoration: none;" >${tran.name}</a></td>
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
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityListBody">
					<c:forEach items="${activityList}" var="activity">
						<tr id="tr_${activity.id}">
							<td><a href="activity/detail.jsp" style="text-decoration: none;">${activity.name}</a></td>
							<td>${activity.startDate}</td>
							<td>${activity.endDate}</td>
							<td>${activity.owner}</td>
							<td><a href="javascript:void(0);" id="unbundActivityBtn" activityId="${activity.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</c:forEach>

					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="bundActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>