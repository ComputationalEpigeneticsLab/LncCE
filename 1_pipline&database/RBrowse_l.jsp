<%@page import="org.eclipse.jdt.internal.compiler.ast.WhileStatement"%>
<%@ page import="action.Array1" import="util.*" import="action.ChartsData" language="java"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- CSS
================================================== -->
<link rel="stylesheet" href="css/zerogrid.css">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/responsive.css">
<link rel="stylesheet" href="css/responsiveslides.css" />		
<link href='./images/favicon.ico' rel='icon' type='image/x-icon'/>	
<script src="js/jquery.min.js"></script>
<script src="js/responsiveslides.js"></script>
<!-- my css js -->
<!-- CSS -->
<link href="Bootstrap/bootstrap.min.css" rel="stylesheet">
<script src="jquery-ui-1.13.2/jquery-3.5.1.js" ></script>
<!-- jQuery and JavaScript Bundle with Popper -->
<script src="Bootstrap/jquery.slim.js"></script>
<script src="Bootstrap/bootstrap.bundle.min.js"></script>
<script src="js/iconify.min.js"></script>
<script src="js/jquery-2.0.0.min.js" ></script>

<script type="text/javascript" src="echarts/echarts.min.js"></script>
<title>LncCE</title>
</head>
<style>
.BT{
	background-color: #fff;
	text-align: center;
}
</style>
<body>
<div style="background-color: #fff;">
<div class="BT"><h3>Top 20 CE lncRNAs with highest entries</h3></div>
<!--  
<div class="Tipp">
<span class="iconify" data-icon="fluent:tag-multiple-24-filled" style="color: #f5b9f5;" data-width="25" data-height="25"></span>
Note: selecting different resourses, the bar plots is correspondingly changed.
</div>
-->
<div style="height:46px;"></div>
<div class="row" style="background-color: #fff;">
<div class="col">
	<div id="bar" style="width: 500px;height:500px;float:left;"></div>
</div>
<div class="col">
	<div id="pie" style="width: 500px;height:500px;float:right;"></div>
</div>
</div>
</div>
<%
DBConn2 db = new DBConn2();
ResultSet rs;
String sel;
List<String> gene = new ArrayList<String>();
List<String> emtab = new ArrayList<String>();
List<String> ngdc = new ArrayList<String>();
List<String> tts = new ArrayList<String>();
List<String> cell_res = new ArrayList<String>();
List<String> hcl = new ArrayList<String>();
List<String> tica = new ArrayList<String>();
List<String> geo = new ArrayList<String>();
List<String> sum = new ArrayList<String>();
db.open();
sel = "select * from lncrna_barplot";
rs=db.execute(sel);
while(rs.next()){
	gene.add(rs.getString("gene_name"));
	emtab.add(rs.getString("EMTAB"));
	ngdc.add(rs.getString("NGDC"));
	tts.add(rs.getString("tts"));
	hcl.add(rs.getString("hcl"));
	cell_res.add(rs.getString("cell_res"));
	tica.add(rs.getString("tica"));
	geo.add(rs.getString("GEO"));
	sum.add(rs.getString("total"));
}
rs.close();
db.close();
%>
<script type="text/javascript">
// 基于准备好的dom，初始化echarts实例
var myChart_bar = echarts.init(document.getElementById('bar'));

// 指定图表的配置项和数据
var option2 = {
        legend: {},
        grid:{containLabel:true,left:0},//完整显示坐标轴名称
        title:{
        	text:'Eight resources',
        	left:'center'
        },
        tooltip: {
            //trigger: 'axis',
            showContent: true,
        },
        dataset: {
        	<%
        	out.println("source: [");
        		//
        		out.println("['all_lncrna',");
        		for(int i=0;i<gene.size()-1;i++){
        			out.println("'"+gene.get(i)+"'"+",");
        		}
        		out.println("'"+gene.get(gene.size()-1)+"'"+"],");
        		//
        		out.println("['all_number',");
        		for(int i=0;i<sum.size()-1;i++){
        			out.println(sum.get(i)+",");
        		}
        		out.println(sum.get(sum.size()-1)+"],");
        		//
        		out.println("['Junbin Qian. Cell Research. 2020',");
        		for(int i=0;i<cell_res.size()-1;i++){
        			out.println(cell_res.get(i)+",");
        		}
        		out.println(cell_res.get(cell_res.size()-1)+"],");
        		//
        		out.println("['Human Cell Landscape',");
        		for(int i=0;i<hcl.size()-1;i++){
        			out.println(hcl.get(i)+",");
        		}
        		out.println(hcl.get(hcl.size()-1)+"],");
        		//
        		out.println("['GEO',");
        		for(int i=0;i<geo.size()-1;i++){
        			out.println(geo.get(i)+",");
        		}
        		out.println(geo.get(geo.size()-1)+"],");
        		//
        		out.println("['The Tabula Sapiens',");
        		for(int i=0;i<tts.size()-1;i++){
        			out.println(tts.get(i)+",");
        		}
        		out.println(tts.get(tts.size()-1)+"],");
        		//
        		out.println("['TICA',");
        		for(int i=0;i<tica.size()-1;i++){
        			out.println(tica.get(i)+",");
        		}
        		out.println(tica.get(tica.size()-1)+"],");
        		//
        		out.println("['NGDC',");
        		for(int i=0;i<ngdc.size()-1;i++){
        			out.println(ngdc.get(i)+",");
        		}
        		out.println(ngdc.get(ngdc.size()-1)+"],");
        		//
        		out.println("['EMTAB',");
        		for(int i=0;i<emtab.size()-1;i++){
        			out.println(emtab.get(i)+",");
        		}
        		out.println(emtab.get(emtab.size()-1)+"]");
        	out.println("]");
        	%>
            /*source: [
                	['all_lncrna','A2M-AS1', 'ASMTL-AS1', 'CASC15', 'CECR7', 'CRNDE', 'DNAJC9-AS1', 'FOXN3-AS1', 'LINC00106', 'LINC00482', 'LINC00484', 'LINC00685', 'LINC00865', 'LINC00877','LINC00926', 'LINC01094','LINC01480', 'LUCAT1','NAPSB','RP11-390P2.4','TMEM220-AS1'],
                    ['all_number',52,74,51,53,52,52,53,72,52,70,54,59,52,67,54,53,55,54,53,52],
        			['Junbin Qian. Cell Research. 2020',4,2,3,2,1,2,1,0,2,2,0,3,3,4,4,2,4,0,0,3],
        			['Human Cell Landscape',29,52,31,35,29,32,40,60,38,60,48,37,36,38,30,38,31,44,39,37],
        			['TISCH',19,20,17,16,22,18,12,12,12,8,6,19,13,25,20,13,20,10,14,12]
            ]*/
        },
        color:['#cccccc'],
        xAxis: {
        	
        },
        yAxis: {
        	type: 'category',
        	gridIndex: 0,
        	inverse: true,//倒叙
        },
        series: [{
        	type: 'bar',
        	id:'bar',
        	seriesLayoutBy: 'row',
        	encode:{
        		x:'all_number',
        		y:'all_lncrna',
        	}
        }]
    };
// 使用刚指定的配置项和数据显示图表。
myChart_bar.setOption(option2);
</script>
<script type="text/javascript">
        // 基于准备好的dom，初始化echarts实例
var myChart_pie = echarts.init(document.getElementById('pie'));

// 指定图表的配置项和数据
var option1 = {
        legend: {},
        tooltip: {
            //trigger: 'axis',
            showContent: true,
        },
        dataset: {
            source: [
                ['all_resource', 'number'],
                ['Junbin Qian. Cell Research. 2020', 59],
                ['Human Cell Landscape', 349],
                ['GEO',544],
                ['The Tabula Sapiens',530],
                ['TICA',154],
                ['NGDC',14],
                ['EMTAB',11]
            ]
        },
        color:['#D4E7F6','#E3B7D4','#D0E5BA','#F9F1B7','#F7B27F','#60F4F0'],
        series: [
            {
                type: 'pie',
                id: 'pie',
                radius: '30%',
                label: {
                    formatter: '{b}:({d}%)'
                },
                encode: {
                    itemName: 'all_resource',
                    value: 'number',
                    tooltip: 'number'
                },
                selectedMode:'single',
                selectedOffset:10
            }
        ]
    };
	myChart_pie.setOption(option1);
    //图表联动功能
	myChart_pie.on('click',function(params){
    	var xAxisInfo = params.value[0];
    	//console.log(params.color);
    	//清空图并刷新
    	myChart_bar.clear();
    	myChart_bar.setOption(option2);
        myChart_bar.setOption({
        	tooltip: {
                //trigger: 'axis',
                showContent: true,
            },
            dataset: {
            	<%
            	out.println("source: [");
            		//
            		out.println("['all_lncrna',");
            		for(int i=0;i<gene.size()-1;i++){
            			out.println("'"+gene.get(i)+"'"+",");
            		}
            		out.println("'"+gene.get(gene.size()-1)+"'"+"],");
            		//
            		out.println("['all_number',");
            		for(int i=0;i<sum.size()-1;i++){
            			out.println(sum.get(i)+",");
            		}
            		out.println(sum.get(sum.size()-1)+"],");
            		//
            		out.println("['Junbin Qian. Cell Research. 2020',");
            		for(int i=0;i<cell_res.size()-1;i++){
            			out.println(cell_res.get(i)+",");
            		}
            		out.println(cell_res.get(cell_res.size()-1)+"],");
            		//
            		out.println("['Human Cell Landscape',");
            		for(int i=0;i<hcl.size()-1;i++){
            			out.println(hcl.get(i)+",");
            		}
            		out.println(hcl.get(hcl.size()-1)+"],");
            		//
            		out.println("['GEO',");
            		for(int i=0;i<geo.size()-1;i++){
            			out.println(geo.get(i)+",");
            		}
            		out.println(geo.get(geo.size()-1)+"],");
            		//
            		out.println("['The Tabula Sapiens',");
            		for(int i=0;i<tts.size()-1;i++){
            			out.println(tts.get(i)+",");
            		}
            		out.println(tts.get(tts.size()-1)+"],");
            		//
            		out.println("['TICA',");
            		for(int i=0;i<tica.size()-1;i++){
            			out.println(tica.get(i)+",");
            		}
            		out.println(tica.get(tica.size()-1)+"],");
            		//
            		out.println("['NGDC',");
            		for(int i=0;i<ngdc.size()-1;i++){
            			out.println(ngdc.get(i)+",");
            		}
            		out.println(ngdc.get(ngdc.size()-1)+"],");
            		//
            		out.println("['EMTAB',");
            		for(int i=0;i<emtab.size()-1;i++){
            			out.println(emtab.get(i)+",");
            		}
            		out.println(emtab.get(emtab.size()-1)+"]");
            	out.println("]");
            	%>
            	/*source: [
                	['all_lncrna','A2M-AS1', 'ASMTL-AS1', 'CASC15', 'CECR7', 'CRNDE', 'DNAJC9-AS1', 'FOXN3-AS1', 'LINC00106', 'LINC00482', 'LINC00484', 'LINC00685', 'LINC00865', 'LINC00877','LINC00926', 'LINC01094','LINC01480', 'LUCAT1','NAPSB','RP11-390P2.4','TMEM220-AS1'],
                    ['all_number',52,74,51,53,52,52,53,72,52,70,54,59,52,67,54,53,55,54,53,52],
        			['Junbin Qian. Cell Research. 2020',4,2,3,2,1,2,1,0,2,2,0,3,3,4,4,2,4,0,0,3],
        			['Human Cell Landscape',29,52,31,35,29,32,40,60,38,60,48,37,36,38,30,38,31,44,39,37],
        			['TISCH',19,20,17,16,22,18,12,12,12,8,6,19,13,25,20,13,20,10,14,12]
            	]*/
            },
            color:[params.color],
            xAxis: {},
            yAxis: {type: 'category',gridIndex: 0},
        	title:{
        		show:true,
        		text:xAxisInfo
        	},
            series: {
                id: 'bar',
                encode: {
                    x:xAxisInfo,
                    y:'all_lncrna'
                }
            }
        });
    });

    myChart_pie.on('legendselectchanged', function(params) {
    	//每个资源被选中的情况，用于后面判断
    	var cell_res = params.selected["Junbin Qian. Cell Research. 2020"];
    	var geo = params.selected["GEO"];
    	var hcl = params.selected["Human Cell Landscape"];
    	var tts = params.selected["The Tabula Sapiens"];
    	var tica = params.selected["TICA"];
    	var ngdc = params.selected["NGDC"];
    	var emtab = params.selected["EMTAB"];
    	var opt = myChart_bar.getOption();//柱状图的option
    	var allNumber = opt.dataset[0].source[1];//所有资源中lncRNA总数
    	allNumber[0] = 'auto';
    	var length = allNumber.length;
    	//每个资源中组织的个数
    	var cell_resNumber = opt.dataset[0].source[2];//GTEx
    	var geoNumber = opt.dataset[0].source[3];//HPA
    	var hclNumber = opt.dataset[0].source[4];//HBM2
    	var ttsNumber = opt.dataset[0].source[5];
    	var ticaNumber = opt.dataset[0].source[6];//GTEx
    	var ngdcNumber = opt.dataset[0].source[7];//HPA
    	var emtabNumber = opt.dataset[0].source[8];//HBM2
  
    	if(!cell_res){
    		for(var i=1;i<length;i++){
    			allNumber[i] = allNumber[i]-cell_resNumber[i];
    		}
    	}
    	if(!geo){
    		for(var i=1;i<length;i++){
    			allNumber[i] = allNumber[i]-geoNumber[i];
    		}
    	}
    	if(!hcl){
    		for(var i=1;i<length;i++){
    			allNumber[i] = allNumber[i]-hclNumber[i];
    		}
    	}
    	if(!tts){
    		for(var i=1;i<length;i++){
    			allNumber[i] = allNumber[i]-ttsNumber[i];
    		}
    	}
    	if(!tica){
    		for(var i=1;i<length;i++){
    			allNumber[i] = allNumber[i]-ticaNumber[i];
    		}
    	}
    	if(!ngdc){
    		for(var i=1;i<length;i++){
    			allNumber[i] = allNumber[i]-ngdcNumber[i];
    		}
    	}
    	if(!emtab){
    		for(var i=1;i<length;i++){
    			allNumber[i] = allNumber[i]-emtabNumber[i];
    		}
    	}
    	//console.log(allNumber);
    	//清空图并刷新
    	myChart_bar.clear();
    	myChart_bar.setOption(option2);
    	//重新设置柱状图
        myChart_bar.setOption({
        	legend: {},
            tooltip: {
                //trigger: 'axis',
                showContent: true,
            },
            dataset: {
            	<%
            	out.println("source: [");
            		//
            		out.println("['all_lncrna',");
            		for(int i=0;i<gene.size()-1;i++){
            			out.println("'"+gene.get(i)+"'"+",");
            		}
            		out.println("'"+gene.get(gene.size()-1)+"'"+"],");
            		//
            		out.println("['all_number',");
            		for(int i=0;i<sum.size()-1;i++){
            			out.println(sum.get(i)+",");
            		}
            		out.println(sum.get(sum.size()-1)+"],");
            		//
            		out.println("['Junbin Qian. Cell Research. 2020',");
            		for(int i=0;i<cell_res.size()-1;i++){
            			out.println(cell_res.get(i)+",");
            		}
            		out.println(cell_res.get(cell_res.size()-1)+"],");
            		//
            		out.println("['Human Cell Landscape',");
            		for(int i=0;i<hcl.size()-1;i++){
            			out.println(hcl.get(i)+",");
            		}
            		out.println(hcl.get(hcl.size()-1)+"],");
            		//
            		out.println("['GEO',");
            		for(int i=0;i<geo.size()-1;i++){
            			out.println(geo.get(i)+",");
            		}
            		out.println(geo.get(geo.size()-1)+"],");
            		//
            		out.println("['The Tabula Sapiens',");
            		for(int i=0;i<tts.size()-1;i++){
            			out.println(tts.get(i)+",");
            		}
            		out.println(tts.get(tts.size()-1)+"],");
            		//
            		out.println("['TICA',");
            		for(int i=0;i<tica.size()-1;i++){
            			out.println(tica.get(i)+",");
            		}
            		out.println(tica.get(tica.size()-1)+"],");
            		//
            		out.println("['NGDC',");
            		for(int i=0;i<ngdc.size()-1;i++){
            			out.println(ngdc.get(i)+",");
            		}
            		out.println(ngdc.get(ngdc.size()-1)+"],");
            		//
            		out.println("['EMTAB',");
            		for(int i=0;i<emtab.size()-1;i++){
            			out.println(emtab.get(i)+",");
            		}
            		out.println(emtab.get(emtab.size()-1)+"]");
            	out.println("]");
            	%>
            	/*source: [
                	['all_lncrna','A2M-AS1', 'ASMTL-AS1', 'CASC15', 'CECR7', 'CRNDE', 'DNAJC9-AS1', 'FOXN3-AS1', 'LINC00106', 'LINC00482', 'LINC00484', 'LINC00685', 'LINC00865', 'LINC00877','LINC00926', 'LINC01094','LINC01480', 'LUCAT1','NAPSB','RP11-390P2.4','TMEM220-AS1'],
                    ['all_number',52,74,51,53,52,52,53,72,52,70,54,59,52,67,54,53,55,54,53,52],
        			['Junbin Qian. Cell Research. 2020',4,2,3,2,1,2,1,0,2,2,0,3,3,4,4,2,4,0,0,3],
        			['Human Cell Landscape',29,52,31,35,29,32,40,60,38,60,48,37,36,38,30,38,31,44,39,37],
        			['TISCH',19,20,17,16,22,18,12,12,12,8,6,19,13,25,20,13,20,10,14,12]
            ]*/
            },
            color:['#cccccc'],
        	 xAxis: {},
             yAxis: {type: 'category',gridIndex: 0},
            series: {
            	type: 'bar',
                id: 'bar',
                encode: {
                    x:'auto',
                    y:'all_lncrna'
                }
            }
        });
    });
</script>
</body>
</html>
