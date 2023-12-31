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
    <script src="jquery/echars/echarts.min.js"></script>

    <script type="text/javascript">
        $(function () {
            
            $.ajax({
                url:'workbench/chart/queryCountOfTranGroupByStage.do',
                dataType:'json',
                type:'get',
                success:function (data) {
                    //基于准备好的dom,初始化echarts实例
                    var myChart = echarts.init(document.getElementById("main"));
                    //指定图表的配置项和数据
                    var option = {
                        title: {
                            text: '交易统计图表',
                            subtext:'交易表中各阶段的数据量',
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: '{b}:{c}'
                        },
                        toolbox: {
                            feature: {
                                dataView: { readOnly: false },
                                restore: {},
                                saveAsImage: {}
                            }
                        },
                        series: [
                            {
                                name: '交易统计图表',
                                type: 'funnel',
                                left: '10%',
                                width: '80%',
                                label: {
                                    formatter: '{b}'
                                },
                                labelLine: {
                                    show: true
                                },
                                itemStyle: {
                                    opacity: 1
                                },
                                emphasis: {
                                    label: {
                                        position: 'inside',
                                        formatter:'{b}:{c}'
                                    }
                                },
                                data: data
                            }
                        ]
                    };
                    //使用刚指定的配置项和数据显示图表
                    myChart.setOption(option);
                }
            });
        });
    </script>
</head>
<body>
<!--为ECharts准备一个具备大小（宽高）的Dom-->
<div id="main" style="width: 600px;height: 400px;"></div>
</body>
</html>
