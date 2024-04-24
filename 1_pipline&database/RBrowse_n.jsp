<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="util.*" import="action.ChartsData"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
<%
DBConn2 db = new DBConn2();
ResultSet rs;
String sel;
%>
<div style="background-color: #fff;">
<div class="BT"><h3>Distribution of normal tissues CE lncRNAs</h3></div>
<div class="card border-primary">
  <h5 class="card-header">Human Cell Landcape</h5>
  <div class="card-body">
    <h5 class="card-title">Adult tissues</h5>
    <div class="row">    
    <div id="bar_a" style="width: 1300px;height:860px;"></div>
	<div id="pie_a" style="width: 1000px;height:650px;"></div>
	</div>
	<h5 class="card-title">Fetal tissues</h5>
	<div class="row">	
	<div id="bar_f" style="width: 1300px;height:860px;"></div>
	<div id="pie_f" style="width: 1000px;height:650px;"></div>
	</div>  
  </div>
</div>
<div class="card border-info">
  <h5 class="card-header">The Tabula Sapiens</h5>
  <div class="card-body">
    <h5 class="card-title">Adult tissues</h5>
    <div class="row">    
    <div id="bar_tts" style="width: 1300px;height:860px;"></div>
	<div id="pie_tts" style="width: 1000px;height:650px;"></div>
	</div>  
  </div>
</div>
<div class="card border-success">
  <h5 class="card-header">TICA</h5>
  <div class="card-body">
    <h5 class="card-title">Adult tissues</h5>
    <div class="row">    
    <div id="bar_tica" style="width: 1300px;height:860px;"></div>
	<div id="pie_tica" style="width: 1000px;height:650px;"></div>
	</div>  
  </div>
</div>
</div>

<%
//Human Cell Landscape
List<String> colname0 = new ArrayList<String>();
List<String> v0 = new ArrayList<String>();
db.open();
sel = "select distinct tissue,cenum from hcl_adult_order";
rs=db.execute(sel);
while(rs.next()){
     v0.add(rs.getString("cenum"));
	 colname0.add(rs.getString("tissue"));
}
rs.close();
db.close();

db.open();
sel = "select distinct tissue,cenum from hcl_fetal_order";
rs=db.execute(sel);
List<String> colname1 = new ArrayList<String>();
List<String> v1 = new ArrayList<String>();
while(rs.next()){
     v1.add(rs.getString("cenum"));
	 colname1.add(rs.getString("tissue"));
}
rs.close();
db.close();

db.open();
sel="select * from hcl_adult_sunburst";
rs=db.execute(sel);
List<String> tissue = new ArrayList<String>();
List<String> cell = new ArrayList<String>();
List<String> num = new ArrayList<String>();
List<String> ce = new ArrayList<String>();
while(rs.next()){
	tissue.add(rs.getString("tissue"));
	cell.add(rs.getString("cell"));
	num.add(rs.getString("num"));
	ce.add(rs.getString("CE"));
}
rs.close();
db.close();

db.open();
sel="select * from hcl_fetal_sunburst";
rs=db.execute(sel);
List<String> tissue1 = new ArrayList<String>();
List<String> cell1 = new ArrayList<String>();
List<String> num1 = new ArrayList<String>();
List<String> ce1 = new ArrayList<String>();
while(rs.next()){
	tissue1.add(rs.getString("tissue"));
	cell1.add(rs.getString("cell"));
	num1.add(rs.getString("num"));
	ce1.add(rs.getString("CE"));
}
rs.close();
db.close();
%>
<%
//tts
List<String> colname2 = new ArrayList<String>();
List<String> v2 = new ArrayList<String>();
db.open();
sel = "select distinct tissue_type,SUM(CE_num) from tts_celltree where source='adult' GROUP BY tissue_type ORDER BY SUM(CE_num) asc";
rs=db.execute(sel);
while(rs.next()){
     v2.add(rs.getString("SUM(CE_num)"));
	 colname2.add(rs.getString("tissue_type").replace("_"," "));
}
rs.close();
db.close();

db.open();
sel="select * from tts_adult_sunburst";
rs=db.execute(sel);
List<String> tissue_tts = new ArrayList<String>();
List<String> cell_tts = new ArrayList<String>();
List<String> num_tts = new ArrayList<String>();
List<String> ce_tts = new ArrayList<String>();
while(rs.next()){
	tissue_tts.add(rs.getString("tissue"));
	cell_tts.add(rs.getString("cell"));
	num_tts.add(rs.getString("num"));
	ce_tts.add(rs.getString("CE"));
}
rs.close();
db.close();
%>
<%
//tica
List<String> colname3 = new ArrayList<String>();
List<String> v3 = new ArrayList<String>();
db.open();
sel = "select distinct tissue,cenum from tica_order";
rs=db.execute(sel);
while(rs.next()){
     v3.add(rs.getString("cenum"));
	 colname3.add(rs.getString("tissue"));
}
rs.close();
db.close();

db.open();
sel="select * from tica_sunburst";
rs=db.execute(sel);
List<String> tissue_tica = new ArrayList<String>();
List<String> cell_tica = new ArrayList<String>();
List<String> num_tica = new ArrayList<String>();
List<String> ce_tica = new ArrayList<String>();
while(rs.next()){
	tissue_tica.add(rs.getString("tissue"));
	cell_tica.add(rs.getString("cell"));
	num_tica.add(rs.getString("num"));
	ce_tica.add(rs.getString("CE"));
}
rs.close();
db.close();
%>
<script>
var chartDom = document.getElementById('bar_a');
var myChart1 = echarts.init(chartDom);
var option1;

option1 = {
  /*title: {
    text: 'Three resources'
  },*/
  color:['#F7B27F'],
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'shadow'
    }
  },
  legend: {show:false},
  grid: {
    left: '18%',
    right: '4%',
    bottom: '3%',
    containLabel: true,
    height:'800px',
    width:'700px'
  },
  xAxis: {
    type: 'value',
    boundaryGap: [0, 0.01]
  },
  yAxis: {
    type: 'category',
    <%
    out.println("data:[");
    for(int i=0;i<colname0.size()-1;i++){
    	out.println("'"+colname0.get(i)+"'"+",");
    }
    out.println("'"+colname0.get(colname0.size()-1)+"'");
    out.println("]");
    %>
  },
  series: [
    {
      //name: 'CE:',
      type: 'bar',
      <%
      out.println("data:[");
      for(int i=0;i<v0.size()-1;i++){
      	out.println(v0.get(i)+",");
      }
      out.println(v0.get(v0.size()-1));
      out.println("]");
      %>
    }
  ]
};
myChart1.setOption(option1);
</script>
<script>
var chartDom = document.getElementById('bar_f');
var myChart2 = echarts.init(chartDom);
var option2;

option2 = {
  /*title: {
    text: 'Three resources'
  },*/
  color:['#F7B27F'],
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'shadow'
    }
  },
  legend: {show:false},
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true,
    //height:'800px',
    //width:'700px'
  },
  xAxis: {
    type: 'value',
    boundaryGap: [0, 0.01]
  },
  yAxis: {
    type: 'category',
    <%
    out.println("data:[");
    for(int i=0;i<colname1.size()-1;i++){
    	out.println("'"+colname1.get(i)+"'"+",");
    }
    out.println("'"+colname1.get(colname1.size()-1)+"'");
    out.println("]");
    %>
  },
  series: [
    {
      //name: 'CE:',
      type: 'bar',
      <%
      out.println("data:[");
      for(int i=0;i<v1.size()-1;i++){
      	out.println(v1.get(i)+",");
      }
      out.println(v1.get(v1.size()-1));
      out.println("]");
      %>
    }
  ]
};
myChart2.setOption(option2);
</script>
<script>
var app = {};
var chartDom = document.getElementById('pie_a');
var myChart3 = echarts.init(chartDom);
var option3;
<%
out.println("var data3=[");
for(int i=0;i<tissue.size();i++){
	out.println("{");
	out.println("name:"+tissue.get(i)+",");
	out.println("children: [");
			for(int j=0;j<cell.get(i).split(",").length;j++){
				out.println("{");
				out.println("name:"+cell.get(i).split(",")[j]+",");
					//out.println("value:"+num.get(i).split(",")[j]+",");
						out.println("children: [");
						for(int k=0;k<ce.get(i).split(";")[j].split(",").length;k++){
							out.println("{");
							out.println("name:"+ce.get(i).split(";")[j].split(",")[k]+",");
							out.println("value:"+num.get(i).split(";")[j].split(",")[k]+",");
							out.println("},");
						}
						out.println("],");
						out.println("},");
			}
			out.println("]");
			out.println("},");
}
out.println("];");
%>
option3 = {
	  series: {
	    type: 'sunburst',
	    data: data3,
	    radius: [0, '100%'],
	    sort: undefined,
	    emphasis: {
	      focus: 'ancestor'
	    },
	    center: ["60%", "50%"],
	    levels: [
	      {},
	      {
	        r0: '15%',
	        r: '35%',
	        itemStyle: {
	          borderWidth: 2
	        },
	        label: {
	          rotate: 'center',
	          minAngle: 12
	        }
	      },
	      {
	        r0: '35%',
	        r: '70%',
	        label: {
	          align: 'right',
	          minAngle: 12
	        }
	      },
	      {
	        r0: '70%',
	        r: '82%',
	        label: {
	          position: 'outside',
	          padding: 3,
	          silent: true,
	          minAngle: 1
	        },
	        itemStyle: {
	          borderWidth: 3
	        }
	      }
	    ]
	  }
	};
myChart3.setOption(option3);
</script>
<script>
var app = {};
var chartDom = document.getElementById('pie_f');
var myChart4 = echarts.init(chartDom);
var option4;
<%
out.println("var data4=[");
for(int i=0;i<tissue1.size();i++){
	out.println("{");
		out.println("name:"+tissue1.get(i)+",");
		out.println("children: [");
			for(int j=0;j<cell1.get(i).split(",").length;j++){
				out.println("{");
					out.println("name:"+cell1.get(i).split(",")[j]+",");
					//out.println("value:"+num.get(i).split(",")[j]+",");
						out.println("children: [");
						for(int k=0;k<ce1.get(i).split(";")[j].split(",").length;k++){
							out.println("{");
								out.println("name:"+ce1.get(i).split(";")[j].split(",")[k]+",");
								out.println("value:"+num1.get(i).split(";")[j].split(",")[k]+",");
							out.println("},");
						}
						out.println("],");
				out.println("},");
			}
		out.println("]");
	out.println("},");
}
out.println("];");
%>
option4 = {
	  series: {
	    type: 'sunburst',
	    data: data4,
	    radius: [0, '100%'],
	    sort: undefined,
	    emphasis: {
	      focus: 'ancestor'
	    },
	    center: ["60%", "50%"],
	    levels: [
	      {},
	      {
	        r0: '15%',
	        r: '35%',
	        itemStyle: {
	          borderWidth: 2
	        },
	        label: {
	          rotate: 'center',
	          minAngle: 15
	        }
	      },
	      {
	        r0: '35%',
	        r: '70%',
	        label: {
	          align: 'center',
	          minAngle: 10
	        }
	      },
	      {
	        r0: '70%',
	        r: '72%',
	        label: {
	          position: 'outside',
	          padding: 3,
	          silent: true,
	          minAngle: 1
	        },
	        itemStyle: {
	          borderWidth: 3
	        }
	      }
	    ]
	  }
	};
myChart4.setOption(option4);
</script>

<script>
/*tts*/
var chartDom = document.getElementById('bar_tts');
var myChart5 = echarts.init(chartDom);
var option;

option = {
  /*title: {
    text: 'Three resources'
  },*/
  color:['#F7B27F'],
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'shadow'
    }
  },
  legend: {show:false},
  grid: {
    left: '16%',
    right: '4%',
    bottom: '3%',
    containLabel: true,
    height:'800px',
    width:'700px'
  },
  xAxis: {
    type: 'value',
    boundaryGap: [0, 0.01]
  },
  yAxis: {
    type: 'category',
    <%
    out.println("data:[");
    for(int i=0;i<colname2.size()-1;i++){
    	out.println("'"+colname2.get(i)+"'"+",");
    }
    out.println("'"+colname2.get(colname2.size()-1)+"'");
    out.println("]");
    %>
  },
  series: [
    {
      //name: 'CE:',
      type: 'bar',
      <%
      out.println("data:[");
      for(int i=0;i<v2.size()-1;i++){
      	out.println(v2.get(i)+",");
      }
      out.println(v2.get(v2.size()-1));
      out.println("]");
      %>
    }
  ]
};
myChart5.setOption(option);
</script>
<script>
var app = {};
var chartDom = document.getElementById('pie_tts');
var myChart6 = echarts.init(chartDom);
var option6;
<%
out.println("var data6=[");
for(int i=0;i<tissue_tts.size();i++){
	out.println("{");
		out.println("name:"+tissue_tts.get(i)+",");
		out.println("children: [");
			for(int j=0;j<cell_tts.get(i).split(",").length;j++){
				out.println("{");
					out.println("name:"+cell_tts.get(i).split(",")[j]+",");
					//out.println("value:"+num.get(i).split(",")[j]+",");
						out.println("children: [");
						for(int k=0;k<ce_tts.get(i).split(";")[j].split(",").length;k++){
							out.println("{");
								out.println("name:"+ce_tts.get(i).split(";")[j].split(",")[k]+",");
								out.println("value:"+num_tts.get(i).split(";")[j].split(",")[k]+",");
							out.println("},");
						}
						out.println("],");
				out.println("},");
			}
		out.println("]");
	out.println("},");
}
out.println("];");
%>
option6 = {
	  series: {
	    type: 'sunburst',
	    data: data6,
	    radius: [0, '100%'],
	    sort: undefined,
	    emphasis: {
	      focus: 'ancestor'
	    },
	    center: ["60%", "50%"],
	    levels: [
	      {},
	      {
	        r0: '15%',
	        r: '35%',
	        itemStyle: {
	          borderWidth: 2
	        },
	        label: {
	          rotate: 'center',
	          minAngle: 15
	        }
	      },
	      {
	        r0: '35%',
	        r: '70%',
	        label: {
	          align: 'center',
	          minAngle: 100
	        }
	      },
	      {
	        r0: '70%',
	        r: '72%',
	        label: {
	          position: 'outside',
	          padding: 3,
	          silent: true,
	          minAngle: 1
	        },
	        itemStyle: {
	          borderWidth: 3
	        }
	      }
	    ]
	  }
	};
myChart6.setOption(option6);
</script>

<script>
/*tica*/
var chartDom = document.getElementById('bar_tica');
var myChart7 = echarts.init(chartDom);
var option;

option = {
  /*title: {
    text: 'Three resources'
  },*/
  color:['#F7B27F'],
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'shadow'
    }
  },
  legend: {show:false},
  grid: {
    left: '16%',
    right: '4%',
    bottom: '3%',
    containLabel: true,
    height:'800px',
    width:'700px'
  },
  xAxis: {
    type: 'value',
    boundaryGap: [0, 0.01]
  },
  yAxis: {
    type: 'category',
    <%
    out.println("data:[");
    for(int i=0;i<colname3.size()-1;i++){
    	out.println("'"+colname3.get(i)+"'"+",");
    }
    out.println("'"+colname3.get(colname3.size()-1)+"'");
    out.println("]");
    %>
  },
  series: [
    {
      //name: 'CE:',
      type: 'bar',
      <%
      out.println("data:[");
      for(int i=0;i<v3.size()-1;i++){
      	out.println(v3.get(i)+",");
      }
      out.println(v3.get(v3.size()-1));
      out.println("]");
      %>
    }
  ]
};
myChart7.setOption(option);
</script>
<script>
var app = {};
var chartDom = document.getElementById('pie_tica');
var myChart8 = echarts.init(chartDom);
var option8;
<%
out.println("var data8=[");
for(int i=0;i<tissue_tica.size();i++){
	out.println("{");
		out.println("name:'"+tissue_tica.get(i)+"',");
		out.println("children: [");
			for(int j=0;j<cell_tica.get(i).split(",").length;j++){
				out.println("{");
					out.println("name:'"+cell_tica.get(i).split(",")[j]+"',");
					//out.println("value:"+num.get(i).split(",")[j]+",");
						out.println("children: [");
						for(int k=0;k<ce_tica.get(i).split(";")[j].split(",").length;k++){
							out.println("{");
								out.println("name:'"+ce_tica.get(i).split(";")[j].split(",")[k]+"',");
								out.println("value:"+num_tica.get(i).split(";")[j].split(",")[k]+",");
							out.println("},");
						}
						out.println("],");
				out.println("},");
			}
		out.println("]");
	out.println("},");
}
out.println("];");
%>
option8 = {
	  /*title: {
	    text: 'Human Cell Landscape',
	    left:'center',
	    //subtext: 'Source: https://worldcoffeeresearch.org/work/sensory-lexicon/',
	    textStyle: {
	      fontSize: 19
	    }/*,
	    subtextStyle: {
	      align: 'center'
	    },*/
	    //sublink: 'https://worldcoffeeresearch.org/work/sensory-lexicon/'
	  //},
	  series: {
	    type: 'sunburst',
	    data: data8,
	    radius: [0, '100%'],
	    sort: undefined,
	    emphasis: {
	      focus: 'ancestor'
	    },
	    levels: [
	      {},
	      {
	        r0: '15%',
	        r: '35%',
	        itemStyle: {
	          borderWidth: 2
	        },
	        label: {
	          rotate: 'center',
	          minAngle: 20
	        }
	      },
	      {
	        r0: '35%',
	        r: '70%',
	        label: {
	          align: 'right',
	          minAngle: 8
	        }
	      },
	      {
	        r0: '70%',
	        r: '72%',
	        label: {
	          position: 'outside',
	          padding: 3,
	          silent: true,
	          minAngle: 2
	        },
	        itemStyle: {
	          borderWidth: 3
	        }
	      }
	    ]
	  }
	};
myChart8.setOption(option8);
</script>
</body>
</html>
