<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>演示echarts插件</title>
    <!--引入jquery-->
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <!--引入eacharts插件-->
    <script type="text/javascript" src="jquery/echars/echarts.min.js"></script>

    <script type="text/javascript">
        $(function () {
            //基于准备好的dom,初始化echarts实例
            var myChart = echarts.init(document.getElementById("main"));
            //指定图表的配置项和数据
            var option = {
                title:{//标题
                    text:'Echarts 入门示例',
                    textStyle:{
                        fontStyle:'normal'
                    },
                    subtext:'测试副标题',
                },
                tooltip:{//提示框
                    textStyle:{
                        color:'black'
                    }
                },
                legend:{//图例
                    data:['销量','进货量']
                },
                xAxis:{
                    data:["衬衫","羊毛衫","雪纺衫","裤子","高跟鞋","袜子"]
                },
                yAxis:{},
                series:[{
                    name:'销量',
                    type:'bar',
                    data:[5,20,37,10,10,20]
                },
                    {
                        name:'进货量',
                        type:'bar',//柱状图
                        data:[1,4,45,12,60,90]
                    }
                ]
            };
            //使用刚指定的配置项和数据显示图表
            myChart.setOption(option);
        });
    </script>
</head>
<body>
<!--为ECharts准备一个具备大小（宽高）的Dom-->
<div id="main" style="width: 600px;height: 400px;"></div>
</body>
</html>
