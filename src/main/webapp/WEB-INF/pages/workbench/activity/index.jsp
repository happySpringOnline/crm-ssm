<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
		//日期控件
		//$("input[name=mydate]").datetimepicker({
		$(".mydate").datetimepicker({
			language:'zh-CN',//语言
			format:'yyyy-mm-dd',//日期的格式
			minView:'month',//可以选择的最小视图
			initialDate:new Date(),//默认选中现在的时间
			todayBtn:true,//显示今天
			autoclose:true,//设置选择完日期或者时间之后，是否自动关闭日历
			clearBtn:true,//设置是否显示“清空”按钮，默认是false
			pickerPosition: "bottom-left"
		})

		//1)市场活动主页面加载完成后，调用页面展示的方法，默认每页展示10条
		queryActivityByConditionForPage(1,7);

		//给【创建】按钮添加单击事件
		$("#createActivityBtn").click(function () {
			//初始化工作
			//重置表单
			//reset()是dom对象的方法
			$("#createActivityForm")[0].reset();
			//弹出创建市场活动的模态窗口
			$("#createActivityModal").modal("show");
		});

		//给【保存】按钮添加单击事件
		$("#saveCreateActivityBtn").click(function(){
			//收集参数
			var owner = $("#create-marketActivityOwner").val();
			//表单验证
			if(owner == ""){
				alert("所有者不能为空");
				return;
			}
			var name = $.trim($("#create-marketActivityName").val());
			//表单验证
			if(name == "") {
				alert("名称不能为空");
				return;
			}
			var startDate = $("#create-startTime").val();
			var endDate = $("#create-endTime").val();
			//表单验证
			if(startDate != "" && endDate != ""){
				//使用字符串的大小代替日期的大小
				if(endDate < startDate){
					alert("开始日期不能大于结束日期！");
					return;
				}
			}
			var cost = $.trim($("#create-cost").val());
			/*
                正则表达式：
                1、定义字符串的匹配模式，可以用来判断指定的具体字符串是否符合匹配模式
                2、语法通则：
                    1)//:在js中定义一个正则表达式。 var regExp=/.../;
                    2)^:匹配字符串的开头位置
                      $:匹配字符串的结尾
                    3)[]:匹配指定字符集中一位字符。 var regExp=/^[abc]$/;
                                                  var regExp=/^[a-z0-9]/;
                    4){}:匹配次数 var regExp=/^[abc]{5}/;
                    5)特殊符号：
                        \d:匹配一位数字，相当于[0-9]
                        \D:匹配一位非数字
                        \w:匹配所有字符，包括字母、数字、下划线
                        \W:匹配非字符，除了字母、数字、下划线之外的字符。

                        *：匹配0次或者多次，相当于{0,}
                        +:匹配1次或者多次，相当于{1,}
                        ?:匹配0次或者1次，相当于{0,1}
             */
			//表单验证（成本必须是非负整数）
			var regExp = /^(([1-9]\d*)|0)$/;
			if(!regExp.test(cost)){
				alert("成本只能是非负整数");
				return;
			}
			var description = $.trim($("#create-describe").val());

			//发送请求
			$.ajax({
				url:'workbench/activity/saveCreateActivity.do',
				data:{
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//关闭模态窗口
						$("#createActivityModal").modal("hide");
						//4)创建市场活动之后，刷新市场活动列表。
						queryActivityByConditionForPage(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
					}else {
						//提示错误信息
						alert(data.message);
						//模态窗口不关闭
						$("#createActivityModal").modal("show");
					}
				}
			});

		});

        //2)点击【查询】按钮，调用页面展示的方法
        $("#searchActivityBtn").click(function () {
			//查询时，pageSize按照用户选择的每页展示的条数展示，若用户没有指定，默认是10
            queryActivityByConditionForPage(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
            return false;
        });

		//【全选】
		$("#checkAll").click(function () {
			//如果“全选”按钮是选中状态，则列表中所有checkbox都选中
			$("input[name=xz]").prop("checked",this.checked);
		});
		/*
		动态生成的标签，不能用以下的方法绑定函数
		 */
		/*$("#activityTBody input[type='checkbox']").click(function () {
			alert(123)
			$("#checkAll").prop("checked",$("#activityTBody input[type='checkbox']").size()==$("#activityTBody input[type='checkbox']:checked").size());
		});*/
		$("#activityTBody").on("click",$("input[name=xz]"),function(){
			$("#checkAll").prop("checked",$("input[name=xz]").size()==$("input[name=xz]:checked").size());
		});

		//【删除】
		$("#deleteActivityBtn").click(function () {
			//收集参数
			//获取列表中所有被选中的checkbox
			var checkedIds = $("#activityTBody input[type=checkbox]:checked");
			if(checkedIds.size()==0){
				alert("请选择要删除的市场活动");
				return;
			}
			if(window.confirm("确定选择删除选中的市场活动吗？")){
				//遍历
				var ids = "";
				$.each(checkedIds,function (i,a) {
					ids += "id="+a.value+"&";
				});
				//str.substr(startIndex,length)
				//str.substring(startIndex,endIndex)
				ids = ids.substring(0,ids.length-1);
				$.ajax({
					url:'workbench/activity/deleteActivityByIds.do',
					data:ids,
					dataType:'json',
					type:'post',
					success:function (data) {
						if (data.code=="1"){
							//5)删除市场活动之后,刷新市场活动列表
							queryActivityByConditionForPage(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
							alert("删除成功！");
						}else {
							alert(data.message);
						}
					}
				});
			}

		});
		
		//【修改】--模态窗口铺值
		$("#editActivityBtn").click(function () {
			var checkedId = $("#activityTBody input[type=checkbox]:checked");
			if (checkedId.size()==0){
				alert("请选择要修改的市场活动！");
				return;
			}else if(checkedId.size()>1){
				alert("只能选择一条市场活动去修改！");
				return;
			}
			var aid = checkedId.val();
			$.ajax({
				url:'workbench/activity/queryActivityById.do',
				data: {
					id:aid
				},
				dataType:'json',
				type:'post',
				success:function (a) {
					//给修改市场活动的模态窗口加一个隐藏域保存市场活动的id
					$("#edit-marketActivityId").val(a.id);
					$("#edit-marketActivityOwner").val(a.owner);
					$("#edit-marketActivityName").val(a.name);
					$("#edit-startTime").val(a.startDate);
					$("#edit-endTime").val(a.endDate);
					$("#edit-cost").val(a.cost);
					$("#edit-describe").text(a.description);

					$("#editActivityModal").modal("show");
				}
			});

		});

		//【更新】
		$("#updateActivityBtn").click(function () {

			var id = $("#edit-marketActivityId").val();
			var owner = $("#edit-marketActivityOwner").val();
			//表单验证，所有者不能为空
			if (owner==""){
				alert("所有者不能为空！");
				return;
			}
			var name = $("#edit-marketActivityName").val();
			//表单验证，市场活动名称不能为空！
			if(name==""){
				alert("市场活动名称不能为空！");
				return;
			}
			var startDate = $("#edit-startTime").val();
			var endDate = $("#edit-endTime").val();
			//表单验证，开始日期不能大于结束日期
			if (startDate!="" && endDate != ""){
				if (startDate > endDate){
					alert("开始日期不能大于结束日期！");
					return;
				}
			}
			var cost = $("#edit-cost").val();
			//表单验证，成本只能是非负整数
			var regExp = /^(([1-9]\d*)|0)$/;
			if (!regExp.test(cost)){
				alert("成本只能是非负整数！");
				return;
			}
			var description = $("#edit-describe").val();

			$.ajax({
				url:'workbench/activity/saveEditedActivity.do',
				data:{
					id:id,
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				dataType:'json',
				type:'post',
				success:function (data) {
					if (data.code=="1"){
						//6)更新市场活动成功之后，刷新市场活动列表
						queryActivityByConditionForPage($("#pagination").bs_pagination('getOption','currentPage'),$("#pagination").bs_pagination('getOption','rowsPerPage'));
						//关闭模态窗口
						$("#editActivityModal").modal("hide");
					}else {
						alert(data.message);
						//模态窗口不关闭
						$("#editActivityModal").modal("show")
					}
				}
			})


		})

		//【全部导出】
		$("#exportActivityAllBtn").click(function (){
			if (confirm("确定要全部导出吗?")){
				//只能发同步请求
				window.location.href="workbench/activity/exportAllActivities.do"
			}
		});
		
		//【选择导出】
		$("#exportActivityXzBtn").click(function () {
			var checkedIds = $("#activityTBody input[type=checkbox]:checked");
			if (checkedIds.size()==0){
				alert("请选择需要导出的市场活动！");
				return;
			}
			var ids = "";
			/*for (let i = 0; i < checkedIds.size(); i++) {
				ids += "id="+checkedIds[i].value
				if (i<checkedIds.size()-1){
					ids += "&"
				}
			}*/
			$.each(checkedIds,function (i,a) {
				ids += "id="+a.value+"&";
			});
			ids = ids.substring(0,ids.length-1);

			window.location.href ="workbench/activity/exportSelectedActivities.do?"+ids;

		});

		//【导入】
		$("#importActivityBtn").click(function () {
			//收集参数
			var activityFileName = $("#activityFile").val();
			var suffix = activityFileName.substr(activityFileName.lastIndexOf(".")+1);
			if (suffix.toLowerCase() != "xls"){
				alert("只支持上传xls文件!");
				return;
			}
			var activityFile = $("#activityFile")[0].files[0];
			if (activityFile.size > 5*1024*1024 ){
				alert("文件大小不能超过5MB!");
				return;
			}

			//FormData是ajax提供的接口，可以模拟键值对向后台提交参数;
			//FormData最大的优势是不但能提交文本数据，还能提交二进制数据
			var formData = new FormData();
			formData.append("activityFile",activityFile);

			//发送ajax请求
			$.ajax({
				url:'workbench/activity/importActivity.do',
				data:formData,
				processData:false,//设置ajax向后台提交参数，是否把参数统一转换成字符串：true--是；false--不是
				contentType:false,//设置ajax向后台提交参数之前，是否把所有的参数统一按urlencoded编码：true---是，false---不是
				dataType:'json',
				type:'post',
				success:function (data) {
					if (data.code=="1"){
						//提示成功导入记录数
						alert("成功导入"+data.retData+"条记录");
						//上传成功，关闭模态窗口
						$("#importActivityModal").modal("hide");
						//刷新市场活动列表，保存页号和每页显示的条数都不变
						queryActivityByConditionForPage($("#pagination").bs_pagination('getOption','currentPage'),$("#pagination").bs_pagination('getOption','rowsPerPage'));
					}else {
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#importActivityModal").modal("show");
					}
				}
			});
		});
	});

	//展示市场活动列表
	//1)市场活动主页面加载完成后,调用活动页面展示的方法
	//2)点击“查询”按钮,调用活动页面展示的方法
	//3)分页插件在每次切换页号的时候,调用展示活动页面列表的方法
	//4)创建新的市场活动之后,刷新市场活动列表,即调用展示活动页面列表的方法
	//5)删除市场活动之后,刷新市场活动列表,即调用展示活动页面列表的方法
	//6)更新市场活动成功之后，刷新市场活动列表,即调用展示活动页面列表的方法
	function queryActivityByConditionForPage(pageNo,pageSize) {
		var name = $("#search-activityName").val();
		var owner = $("#search-activityOwner").val();
		var startDate = $("#search-activityStartDate").val();
		var endDate = $("#search-activityEndDate").val();
		/*var pageNo = 1;
		var pageSize = 10;*/
		//发送请求
		$.ajax({
			url:'workbench/activity/queryActivityByConditionForPage.do',
			data:{
				name:name,
				owner:owner,
				startDate:startDate,
				endDate:endDate,
				pageNo:pageNo,
				pageSize:pageSize
			},
			type:'POST',
			dataType: 'JSON',
			success:function (data) {
				//显示市场活动的列表
				//遍历activityList,拼接所有行数据
				var html = "";
				$.each(data.activityList,function (i, activity) {
					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="xz" value="'+activity.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detailActivity.do?id='+activity.id+'\'">'+activity.name+'</a></td>';
					html += '<td>'+activity.owner+'</td>';
					html += '<td>'+activity.startDate+'</td>';
					html += '<td>'+activity.endDate+'</td>';
					html += '</tr>';
				});

				$("#activityTBody").html(html);

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
						queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		});
	}
	
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="createActivityForm">
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
									<option></option>
								  <c:forEach items="${userList}" var="u">
									  <option value="${u.id}">${u.name}</option>
								  </c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" name="mydate" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" name="mydate" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">
                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-marketActivityId">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<option></option>
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" >
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" name="mydate" id="edit-startTime">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" name="mydate" id="edit-endTime">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
				      <input class="form-control" type="text" id="search-activityName">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-activityOwner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control mydate" type="text" id="search-activityStartDate"/>
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control mydate" type="text" id="search-activityEndDate">
				    </div>
				  </div>
				  
				  <button id="searchActivityBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityTBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="pagination"></div>
			</div>


			<%--<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB">50</b>条记录</button>
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