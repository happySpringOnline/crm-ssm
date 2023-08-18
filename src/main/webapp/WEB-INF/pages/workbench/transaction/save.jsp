<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";

	Map<String,String> pMap = (Map<String, String>) application.getAttribute("pMap");

	Set<String> set = pMap.keySet();

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

	<script type="text/javascript" >

		var json={
			<%
			for (String stage:set){
			String possibility = pMap.get(stage);
			 %>
			"<%=stage%>":<%=possibility%>,
			<%
			}
			%>
		}

		$(function () {

			$(".mydate").datetimepicker({
				language:'zh-CN',//语言
				format:'yyyy-mm-dd',//日期的格式
				minView:'month',//可以选择的最小视图
				initialDate:new Date(),//默认选中现在的时间
				todayBtn:true,//显示今天
				autoclose:true,//设置选择完日期或者时间之后，是否自动关闭日历
				pickerPosition: "top-left"
			});

			//【阶段与可能性】
			$("#create-transactionStage").change(function () {
				var stage = $(this).val();
				var possibility = json[stage];
				$("#create-possibility").val(possibility);
			});

			//【补全客户名字】
			$("#create-accountName").typeahead({
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

			$("#activitySrcA").click(function () {
				//初始化
				$("#activityName").val("");
				$("#activityListBody").html("");
				$("#findMarketActivity").modal("show");
			});

			//【查找市场活动】
			$("#activityName").keyup(function () {
				$.ajax({
					url:'workbench/tran/queryActivityListByAName.do',
					data:{
						activityName:this.value
					},
					dataType:'json',
					type:'get',
					success:function (data) {
						var html ="";
						$.each(data,function (i,a) {
							html += '<tr>';
							html += '<td><input type="radio" name="activity" value="'+a.id+'" activityName="'+a.name+'"/></td>';
							html += '<td>'+a.name+'</td>';
							html += '<td>'+a.startDate+'</td>';
							html += '<td>'+a.endDate+'</td>';
							html += '<td>'+a.owner+'</td>';
							html += '</tr>';
						});
						$("#activityListBody").html(html);
					}

				});
			});

			$("#activityListBody").on("click","input[name=activity]",function () {
				var activityId = $(this).val();
				var activityName = $(this).attr("activityName");
				$("#create-activitySrc").val(activityName);
				$("#create-activityId").val(activityId);

				$("#findMarketActivity").modal("hide");
			});

			$("#create-contactsSrc").click(function () {
				$("#contactsName").val("");
				$("#contactsListBody").html("");

				$("#findContacts").modal("show");
			});

			//【查找联系人】
			$("#contactsName").keyup(function () {
				$.ajax({
					url:'workbench/tran/queryContactsListByCName.do',
					data:{
						contactsName:this.value
					},
					dataType:'json',
					type:'get',
					success:function (data) {
						var html = "";
						$.each(data,function (i,c) {
							html += '<tr>';
							html += '<td><input type="radio" name="contacts" value="'+c.id+'" contactsName="'+c.fullname+'"/></td>';
							html += '<td>'+c.fullname+'</td>';
							html += '<td>'+c.email+'</td>';
							html += '<td>'+c.mphone+'</td>';
							html += '</tr>';
						});
						$("#contactsListBody").html(html)
					}
				});
			});
			
			$("#contactsListBody").on("click","input[name=contacts]",function () {
				var contactsId = $(this).val();
				var fullname = $(this).attr("contactsName");

				$("#create-contactsName").val(fullname);
				$("#create-contactsId").val(contactsId);

				$("#findContacts").modal("hide");
			});

			//【保存交易】
			$("#saveCreateTranBtn").click(function () {
				//收集参数
				var owner = $("#create-transactionOwner").val();//
				var money = $.trim($("#create-amountOfMoney").val());
				var name = $.trim($("#create-transactionName").val());
				var expectedDate = $("#create-expectedClosingDate").val();//
				var customerName = $("#create-accountName").val();
				var stage = $("#create-transactionStage").val();//
				var type = $("#create-transactionType").val();//
				var source = $("#create-clueSource").val();//
				var activityId = $("#create-activityId").val();//
				var contactsId = $("#create-contactsId").val();//
				var description = $.trim($("#create-describe").val());
				var contactSummary = $.trim($("#create-contactSummary").val());
				var nextContactTime = $("#create-nextContactTime").val();//

				//表单验证
				if(owner==""||owner==null){
					alert("所有者项为必填项!");
					return;
				}
				if(name==""||name==null){
					alert("交易名称项为必填项!");
					return;
				}
				if(expectedDate==""||expectedDate==null){
					alert("预计成交日期项为必填项!");
					return;
				}
				if(customerName==""||customerName==null){
					alert("客户名字项为必填项!");
					return;
				}
				if(stage==""||stage==null){
					alert("交易阶段项为必填项!");
					return;
				}
				if (money!=""||money!=null){
					var regExp = /^(([1-9]\d*)|0)$/;
					if (!regExp.test(money)){
						alert("金额只能为非负整数");
						return;
					}
				}

				//发送请求
				$.ajax({
					url:'workbench/tran/saveCreateTran.do',
					data:{
						owner :owner,
						money :money,
						name :name,
						expectedDate :expectedDate,
						customerName :customerName,
						stage :stage,
						type :type,
						source :source,
						activityId :activityId,
						contactsId :contactsId,
						description :description,
						contactSummary :contactSummary,
						nextContactTime :nextContactTime
					},
					dataType:'json',
					type:'post',
					success:function (data) {
						if (data.code=="1"){
							window.location.href="workbench/tran/index.do";
						}else {
							alert(data.message);
						}
					}
				});
			});

		});
	</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="activityName" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityListBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="contactsName" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead >
						<tbody id="contactsListBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveCreateTranBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
				  <option></option>
					<c:forEach items="${userList}" var="user">
						<option value="${user.id}">${user.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control mydate" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
			  	<option></option>
				  <c:forEach items="${stage}" var="stage">
					  <option value="${stage.value}">${stage.text}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
					<c:forEach items="${transactionType}" var="transactionType">
						<option value="${transactionType.value}">${transactionType.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <option></option>
					<c:forEach items="${source}" var="source">
						<option value="${source.value}">${source.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">1市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="activitySrcA"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-activitySrc" readonly>
				<input type="hidden" id="create-activityId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人1名称&nbsp;&nbsp;<a href="javascript:void(0);" id="create-contactsSrc"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contactsName" readonly>
				<input type="hidden" id="create-contactsId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control mydate" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>