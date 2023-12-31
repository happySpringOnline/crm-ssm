<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.List" %>
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

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

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

		//【保存备注】
		$("#saveTranRemarkBtn").click(function () {
			//收集参数
			var noteContent = $.trim($("#remark").val());
			var tranId = '${tran.id}';
			if (remark==""){
				alert("备注内容不能为空！");
				return;
			}
			//发送ajax请求
			$.ajax({
				url:'workbench/tran/saveTranRemark.do',
				data:{
					noteContent:noteContent,
					tranId:tranId
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
						html += '<font color="gray">交易</font> <font color="gray">-</font> <b>${tran.name}</b> <small style="color: gray;"> '+data.retData.createTime+' 由 ${sessionScope.sessionUser.name} 创建</small>';
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

		//【更新备注】
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
				url:'workbench/tran/updateTranRemark.do',
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

		//【删除备注】
		$("#remarkListBody").on("click","a[name=deleteA]",function () {
			if (confirm("确定删除选中的备注吗？")){
				var id = $(this).attr("remarkId");
				$.ajax({
					url:'workbench/tran/deleteTranRemark.do',
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


		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });



	});


	function changeStage(stage,i){
		$.ajax({
			url:"workbench/tran/changeStage.do",
			data:{
				"id":"${tran.id}",
				"stage":stage,
				"money":"${tran.money}",
				"expectedDate":"${tran.expectedDate}"
			},
			dataType: "JSON",
			type:"POST",
			success:function (data) {
				if(data.code=="1"){

					//改变阶段成功后
					//(1)需要在详细信息页上局部刷新 刷新阶段，可能性，修改人，修改时间
					$("#tran-stage").html(data.retData.stage)
					$("#tran-possibility").html(data.retData.possibility)
					$("#tran-editBy").html(data.retData.editBy)
					$("#tran-editTime").html(data.retData.editTime)

					//(2)将所有的阶段图标重新判断，重新赋予样式及颜色
					changeIcon(stage,i);

					//(3)底部添加阶段历史
					var html = "";
					html += '<tr>';
					html += '<td>'+data.retData.stage+'</td>';
					html += '<td>'+data.retData.money+'</td>';
					html += '<td>'+data.retData.expectedDate+'</td>';
					html += '<td>'+data.retData.editTime+'</td>';
					html += '<td>'+data.retData.editBy+'</td>';
					html += '</tr>';

					$("#tranHistoryList").append(html);
				}else {
					alert("变更交易失败！")
				}
			}
		})
	}
	function changeIcon(stage,i) {
		//当前阶段
		var currentStage = stage;
		//当前阶段可能性
		var currentPossibility = json[currentStage];
		//当前阶段的下标
		var currentIndex = i-1;
		//准备：前面正常阶段和后面丢失阶段的分界点下标
		var point = 7;

		//如果当前阶段的可能性为0 前七个一定是黑圈，后两个一个是红叉，一个是黑叉
		if("0"==currentPossibility){
			//遍历前七个
			for (let i = 0; i < point; i++) {
				//黑圈-----------------------
				//移除掉原有的样式
				$("#"+i).removeClass();
				//添加新样式
				$("#"+i).addClass("glyphicon glyphicon-record mystage");
				$("#"+i).css("color","#000000");
			}
			//遍历后两个
			for (let i = point; i < 9; i++) {
				if(i==currentIndex){
					//红叉------------------------
					//移除掉原有的样式
					$("#"+i).removeClass();
					//添加新样式
					$("#"+i).addClass("glyphicon glyphicon-remove mystage");
					$("#"+i).css("color","#FF0000");

				}else {
					//黑叉------------------------
					//移除掉原有的样式
					$("#"+i).removeClass();
					//添加新样式
					$("#"+i).addClass("glyphicon glyphicon-remove mystage");
					$("#"+i).css("color","#000000");
				}
			}

			//如果当前阶段的可能性不为0 前七个绿圈，绿色标记，黑圈，后两个一定是黑叉
		}else{
			//遍历前七个
			for (let i = 0; i < point; i++) {
				if(i==currentIndex){
					//绿标----------------------
					//移除掉原有的样式
					$("#"+i).removeClass();
					//添加新样式
					$("#"+i).addClass("glyphicon glyphicon-map-marker mystage");
					$("#"+i).css("color","#90F790");
				}else if(i<currentIndex){
					//绿圈---------------------
					//移除掉原有的样式
					$("#"+i).removeClass();
					//添加新样式
					$("#"+i).addClass("glyphicon glyphicon-ok-circle mystage");
					$("#"+i).css("color","#90F790");
				}else {
					//黑圈----------------------
					//移除掉原有的样式
					$("#"+i).removeClass();
					//添加新样式
					$("#"+i).addClass("glyphicon glyphicon-record mystage");
					$("#"+i).css("color","#000000");
				}
			}
			//遍历后两个
			for (let i = point; i < 9; i++) {

				//黑叉------------------------
				//移除掉原有的样式
				$("#"+i).removeClass();
				//添加新样式
				$("#"+i).addClass("glyphicon glyphicon-remove mystage");
				$("#"+i).css("color","#000000")
			}

		}
	}
	
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
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${tran.name} <small>￥${tran.money}</small></h3>
		</div>
		
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<!--遍历stageList,依次显示每一个阶段对应的图标-->
		<c:forEach items="${stageList}" var="stage" varStatus="stageStatus">
			<!--如果stage就是交易所处阶段，则图标显示为map-marker,验证显示为绿色-->
			<c:if test="${tran.stage==stage.value}">
				<span id="${stageStatus.count-1}" class="glyphicon glyphicon-map-marker mystage" onclick="changeStage('${stage.value}','${stageStatus.count}')" data-toggle="popover" data-content="${stage.value}" data-placement="bottom" style="color: #90F790;"></span>
				-----------
			</c:if>

			<!--如果stage处在交易所处阶段前边，则图标显示为ok-circle,颜色显示为绿色-->
			<c:if test="${tran.orderNo > stage.orderNo}">
				<span id="${stageStatus.count-1}" class="glyphicon glyphicon-ok-circle mystage" onclick="changeStage('${stage.value}','${stageStatus.count}')" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: #90F790;"></span>
				-----------
			</c:if>

			<!--如果stage处在交易所处阶段后边，则图标显示为record,颜色显示为黑色-->
			<c:if test="${tran.orderNo < stage.orderNo}">
				<span id="${stageStatus.count-1}" class="glyphicon glyphicon-record mystage" onclick="changeStage('${stage.value}','${stageStatus.count}')" data-toggle="popover" data-placement="bottom" data-content="${stage.value}"></span>
				-----------
			</c:if>
		</c:forEach>
		<%--
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-------------%>
		<span class="closingDate">${tran.expectedDate}</span>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;" ><b id="tran-stage">${tran.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;" ><b id="tran-possibility">${tran.possibility}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.activityId}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">&nbsp;${tran.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="tran-editBy">${tran.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="tran-editTime">&nbsp;${tran.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.contactSummary}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<div id="remarkListBody">
			<!-- 备注1 -->
			<c:forEach items="${tranRemarks}" var="tranRemark">
				<div id="div_${tranRemark.id}" class="remarkDiv" style="height: 60px;">
					<img title="${tranRemark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
					<div  style="position: relative; top: -40px; left: 40px;" >
						<h5>${tranRemark.noteContent}</h5>
						<font color="gray">交易</font> <font color="gray">-</font> <b>${tran.name}</b> <small style="color: gray;"> ${tranRemark.editFlag=="0"?tranRemark.createTime:tranRemark.editTime} 由 ${tranRemark.editFlag=="0"?tranRemark.createBy:tranRemark.editBy} ${tranRemark.editFlag=="0"?"创建":"修改"}</small>
						<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
							<a class="myHref" remarkId=${tranRemark.id} name="editA" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<a class="myHref" remarkId=${tranRemark.id} name="deleteA" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
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
					<button type="button" class="btn btn-primary" id="saveTranRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="tranHistoryList">
						<c:forEach items="${tranHistories}" var="tranHistory">
							<tr>
								<td>${tranHistory.stage}</td>
								<td>${tranHistory.money}</td>
								<td>${tranHistory.expectedDate}</td>
								<td>${tranHistory.createTime}</td>
								<td>${tranHistory.createBy}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>