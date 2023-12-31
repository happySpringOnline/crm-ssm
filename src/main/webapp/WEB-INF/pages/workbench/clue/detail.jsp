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

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
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

		$("#remarkBody").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		});

		$("#remarkBody").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		});

		$("#remarkBody").on("mouseover",".myHref",function () {
			$(this).children("span").css("color","red");
		});

		$("#remarkBody").on("mouseout",".myHref",function () {
			$(this).children("span").css("color","#E6E6E6");
		});

		//【关联市场活动】超链接
		$("#bundActivityBtn").click(function () {
			//初始化工作
			//清空搜索框
			$("#activityName").val("");
			//清空搜索的市场活动列表
			$("#activityTBody").html("");

			$("#bundModal").modal("show");
		});

		//根据名字模糊查询市场活动
		$("#activityName").keyup(function () {
			//收集参数
			var activityName = this.value;
			var clueId = '${clue.id}';
			//发送ajax请求
			$.ajax({
				url:'workbench/clue/queryActivityForDetailByNameAndClueId.do',
				data:{
					clueId:clueId,
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
		$("#bundBtn").click(function () {
			var checkedAIds = $("input[name=a]:checked");
			if (checkedAIds.length==0){
				alert("您还未选中需要关联的市场活动!");
				return;
			}
			var ids = "";
			$.each(checkedAIds,function (i,a) {
				ids += "activityId="+a.value+"&";
			});
			var clueId = "${clue.id}";
			ids += "clueId="+clueId;
			
			$.ajax({
				url:'workbench/clue/saveCreateClueActivityRelation.do',
				data:ids,
				dataType:'json',
				type:'post',
				success:function (data) {
					if (data.code=="1"){
						$("#bundModal").modal("hide");
						var html = "";
						$.each(data.retData,function (i,a) {
							html += '<tr id="tr_'+a.id+'">';
							html += '<td>'+a.name+'</td>';
							html += '<td>'+a.startDate+'</td>';
							html += '<td>'+a.endDate+'</td>';
							html += '<td>'+a.owner+'</td>';
							html += '<td><a href="javascript:void(0);" activityId="'+a.id+'" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
							html += '</tr>';
						});
						$("#relationTBody").append(html);
					}else{
						alert(data.message);
						$("#bundModal").modal("show");
					}
				}
			});
		});

		//“解除关联”---因为市场活动列表是动态生成的，不是固有元素，需要用on函数
		$("#relationTBody").on("click","a",function () {
			/*
				获取属性值：
				选择器.attr("属性名")---除了true/false以外的所有属性值
				选择器.prop("属性名")---true/false属性值
			*/
			var activityId = $(this).attr("activityId");
			var clueId = '${clue.id}';
			if (window.confirm("确定要解除选中的关联关系吗?")){
				//发送请求
				$.ajax({
					url:'workbench/clue/deleteClueActivityRelation.do',
					data:{
						activityId:activityId,
						clueId:clueId
					},
					dataType:'json',
					type:'post',
					success:function (data) {
						if (data.code=="1"){
							//移除选中的元素
							$("#tr_"+activityId).remove();
							alert("解除关联成功！");
						}else {
							alert(data.message)
						}
					}
				});
			}
		});

		//【保存备注】
		$("#saveClueRemarkBtn").click(function () {
			//收集参数
			var noteContent = $.trim($("#remark").val());
			var clueId = '${clue.id}';
			if (remark==""){
				alert("备注内容不能为空！");
				return;
			}
			//发送ajax请求
			$.ajax({
				url:'workbench/clue/saveClueRemark.do',
				data:{
					noteContent:noteContent,
					clueId:clueId
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
						html += '<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;">'+data.retData.createTime+' 由 ${sessionScope.sessionUser.name} 创建</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html += '<a class="myHref" name="editA" remarkId="'+data.retData.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
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
		$("#remarkBody").on("click","a[name=editA]",function () {
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
				url:'workbench/clue/updateClueRemark.do',
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
		$("#remarkBody").on("click","a[name=deleteA]",function () {
			if (confirm("确定删除选中的备注吗？")){
				var id = $(this).attr("remarkId");
				$.ajax({
					url:'workbench/clue/deleteClueRemark.do',
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

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
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
						    <input type="text" class="form-control" style="width: 300px;" id="activityName" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table class="table table-hover" style="width: 900px; position: relative;top: 10px;">
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
					<button type="button" class="btn btn-primary" id="bundBtn">关联</button>
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
			<h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/toConvertPage.do?id=${clue.id}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>


		<!-- 备注1 -->
		<c:forEach items="${clueRemarkList}" var="clueRemark">
			<div id="div_${clueRemark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${clueRemark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${clueRemark.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;">${clueRemark.editFlag=='1'?clueRemark.editTime:clueRemark.createTime} 由 ${clueRemark.editFlag=='1'?clueRemark.editBy:clueRemark.createBy} ${clueRemark.editFlag=='1'?'修改':'创建'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" remarkId=${clueRemark.id} name="editA" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" remarkId=${clueRemark.id} name="deleteA" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveClueRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="relationTBody">
						<%--<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
						<c:forEach items="${activityList}" var="activity">
							<tr id="tr_${activity.id}">
								<td>${activity.name}</td>
								<td>${activity.startDate}</td>
								<td>${activity.endDate}</td>
								<td>${activity.owner}</td>
								<td><a href="javascript:void(0);" activityId="${activity.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
							</tr>
						</c:forEach>

					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" id="bundActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>